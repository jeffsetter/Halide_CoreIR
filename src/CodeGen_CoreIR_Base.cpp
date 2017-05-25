#include <iostream>
#include <limits>

#include "CodeGen_Internal.h"
#include "CodeGen_CoreIR_Base.h"
#include "Substitute.h"
#include "IROperator.h"
#include "Param.h"
#include "Var.h"
#include "Lerp.h"
#include "Simplify.h"

#include "coreir.h"

namespace Halide {
namespace Internal {

using std::ostream;
using std::endl;
using std::string;
using std::vector;
using std::ostringstream;
using std::to_string;

string CodeGen_CoreIR_Base::print_stencil_type(Stencil_Type stencil_type) {
    ostringstream oss;
    // C: Stencil<uint16_t, 1, 1, 1> stencil_var;
    // C: hls::stream<Stencil<uint16_t, 1, 1, 1> > stencil_stream_var;

    switch(stencil_type.type) {
    case Stencil_Type::StencilContainerType::Stencil :
        oss << "Stencil<" << print_type(stencil_type.elemType);

        for(const auto &range : stencil_type.bounds) {
            internal_assert(is_one(simplify(range.min == 0)));
            oss << ", " << range.extent;
        }
        oss << ">";
        break;
    case Stencil_Type::StencilContainerType::Stream :
        oss << "hls::stream<PackedStencil<";
        oss << print_type(stencil_type.elemType);

        for(const auto &range : stencil_type.bounds) {
            internal_assert(is_one(simplify(range.min == 0)));
            oss << ", " << range.extent;
        }
        oss << "> >";
        break;
    case Stencil_Type::StencilContainerType::AxiStream :
        oss << "hls::stream<AxiPackedStencil<";
        oss << print_type(stencil_type.elemType);

        for(const auto &range : stencil_type.bounds) {
            internal_assert(is_one(simplify(range.min == 0)));
            oss << ", " << range.extent;
        }
        oss << "> >";
        break;
    default: internal_error;
    }
    return oss.str();
}

string CodeGen_CoreIR_Base::print_name(const string &name) {
    ostringstream oss;

    // Prefix an underscore to avoid reserved words (e.g. a variable named "while")
    if (isalpha(name[0])) {
        oss << '_';
    }

    for (size_t i = 0; i < name.size(); i++) {
	// vivado CoreIR compiler doesn't like '__'
        if (!isalnum(name[i])) {
            oss << "_";
        }
        else oss << name[i];
    }
    return oss.str();
}

string CodeGen_CoreIR_Base::print_stencil_pragma(const string &name) {
    // nothing is printed by default
    return string();
}

void CodeGen_CoreIR_Base::visit(const Call *op) {
    if (op->name == "linebuffer") {
        //IR: linebuffer(buffered.stencil_update.stream, buffered.stencil.stream, extent_0[, extent_1, ...])
        //C: linebuffer<extent_0[, extent_1, ...]>(buffered.stencil_update.stream, buffered.stencil.stream)
        internal_assert(op->args.size() >= 3);
        string a0 = print_expr(op->args[0]);
        string a1 = print_expr(op->args[1]);
	const Variable *stencil_var = op->args[1].as<Variable>();
	Stencil_Type stencil_type = stencils.get(stencil_var->name);

        do_indent();
        stream << "linebuffer<";
        for(size_t i = 2; i < op->args.size(); i++) {
            stream << print_expr(op->args[i]);
            if (i != op->args.size() -1)
                stream << ", ";
        }
        stream << ">(" << a0 << ", " << a1 << ");\n";
        id = "0"; // skip evaluation
	
	// add potentially to coreir as input
	string lb_in_name = print_name(a0);
	string lb_out_name = print_name(a1);
	if (hw_inout_set.count(lb_in_name) > 0) {
	  stream << "// " << lb_in_name << " added as an input" << input_idx  << "\n";
	  hw_wire_set[lb_in_name] = self->sel("in")->sel(input_idx);
	  input_idx++;
	} else {
	  stream << "// " << lb_in_name << " not found as an input" << "\n";
	}

	// add linebuffer to coreir
	Expr lb_dim0 = stencil_type.bounds[0].extent;
	Expr lb_dim1 = stencil_type.bounds[1].extent;
	stream << "// linebuffer size: " << lb_dim0 << " " << lb_dim1 << "\n";

	string lb_name = "lb" + lb_in_name;
	int stencil_width = id_cnst_value(lb_dim0);
	int stencil_height = id_cnst_value(lb_dim1);
	int image_width = id_cnst_value(op->args[0]);
	CoreIR::Wireable* coreir_lb = def->addInstance(lb_name, gens["Linebuffer"],
  			         {{"bitwidth",context->argInt(bitwidth)}, {"stencil_width", context->argInt(stencil_width)},
				  {"stencil_height", context->argInt(stencil_height)}, {"image_width", context->argInt(image_width)}}
						       );
	def->connect(hw_wire_set[lb_in_name], coreir_lb->sel("in"));
	hw_wire_set[lb_out_name] = coreir_lb->sel("out");

	/*
	if ( id_cnst_value(lb_dim0) == 3 && id_cnst_value(lb_dim1) == 3 ) {
	  stream << "// insert linebuffer33 for " << lb_in_name << ", " << lb_out_name << " in set\n";
	  string lb_name = "lb33" + lb_in_name;
	  CoreIR::Wireable* coreir_lb = def->addInstance(lb_name, mdefs["linebuffer33"]);
	  def->connect(hw_wire_set[lb_in_name], coreir_lb->sel("in"));
	  hw_wire_set[lb_out_name] = coreir_lb->sel("out");
	}
	*/
	

    } else if (op->name == "write_stream") {
        string printed_stream_name;
	string input_name;
        if (op->args.size() == 2) {
            // normal case
            // IR: write_stream(buffered.stencil_update.stream, buffered.stencil_update)
            // C: buffered_stencil_update_stream.write(buffered_stencil_update);
            string a0 = print_expr(op->args[0]);
            string a1 = print_expr(op->args[1]);
            do_indent();
            stream << a0 << ".write(" << a1 << ");\n";
            id = "0"; // skip evaluation 
	    printed_stream_name = a0;
	    input_name = a1;
        } else {
            // write stream call for the dag output kernel
            // IR: write_stream(output.stencil.stream, output.stencil, loop_var_1, loop_max_1, ...)
            // C:  AxiPackedStencil<uint8_t, 1, 1, 1> _output_stencil_packed = _output_stencil;
            //     if (_loop_var_1 == loop_max_1 && ...)
            //       _output_stencil_packed.last = 1;
            //     else
            //       _output_stencil_packed.last = 0;
            //     _output_stencil_stream.write(_output_stencil_packed);
            internal_assert(op->args.size() > 2 && op->args.size() % 2 == 0);
            const Variable *stream_var = op->args[0].as<Variable>();
            const Variable *stencil_var = op->args[1].as<Variable>();
            internal_assert(stream_var && stencil_var);
            string stream_name = stream_var->name;
            string stencil_name = stencil_var->name;
            string packed_stencil_name = stencil_name + "_packed";

            internal_assert(stencils.contains(stencil_name));
            Stencil_Type stencil_type = stencils.get(stencil_name);
            internal_assert(stencil_type.type == Stencil_Type::StencilContainerType::Stencil);

            // emit code declaring the packed stencil
            do_indent();
            stream << "AxiPacked" << print_stencil_type(stencil_type) << " "
                   << print_name(packed_stencil_name) << " = "
                   << print_name(stencil_name) << ";\n";

            // emit code asserting TLAST
            vector<string> loop_vars, loop_maxes;
            for (size_t i = 2; i < op->args.size(); i += 2) {
                loop_vars.push_back(print_expr(op->args[i]));
                loop_maxes.push_back(print_expr(op->args[i+1]));
            }
            do_indent();
            stream << "if (";
            for (size_t i = 0; i < loop_vars.size(); i++) {
                stream << loop_vars[i] << " == " << loop_maxes[i];
                if (i < loop_vars.size() - 1)
                    stream << " && ";
            }
            stream << ") {\n";
            do_indent();
            stream << ' ' << print_name(packed_stencil_name) << ".last = 1;\n";
            do_indent();
            stream << "} else {\n";
            do_indent();
            stream << ' ' << print_name(packed_stencil_name) << ".last = 0;\n";
            do_indent();
            stream << "}\n";

            // emit code writing stream
            do_indent();
            stream << print_name(stream_name) << ".write("
                   << print_name(packed_stencil_name) << ");\n";
            id = "0"; // skip evaluation
	    printed_stream_name = print_name(stream_name);
	    input_name = print_name(stencil_name);
        }

	// add as output for coreir
	if (hw_wire_set.count(input_name) > 0) {
	  if (hw_inout_set.count(printed_stream_name) > 0) {
	    stream << "// " << printed_stream_name << " added as an output" << "\n";
	    def->connect(hw_wire_set[input_name], self->sel("out"));
	  } else {
	    stream << "// " << printed_stream_name << " not found as an output, adding as wire" << "\n";
	    hw_wire_set[printed_stream_name] = hw_wire_set[input_name];
	  }
	} else {
	  // FIXME: remove this temp fix for stencils
	  input_name += "_0_0";
	  if (hw_wire_set.count(input_name) > 0) {
	    if (hw_inout_set.count(printed_stream_name) > 0) {
	      stream << "// " << printed_stream_name << " added as an output" << "\n";
	      def->connect(hw_wire_set[input_name], self->sel("out"));
	    } else {
	      stream << "// " << printed_stream_name << " not found as an output, adding as wire" << "\n";
	      hw_wire_set[printed_stream_name] = hw_wire_set[input_name];
	    }
	  } else {
	    stream << "// " << input_name << " not found in wireset" << endl;
	  }
	}

    } else if (op->name == "read_stream") {
        internal_assert(op->args.size() == 2 || op->args.size() == 3);
        string a1 = print_expr(op->args[1]);

        const Variable *stream_name_var = op->args[0].as<Variable>();
        internal_assert(stream_name_var);
        string stream_name = stream_name_var->name;
        if (op->args.size() == 3) {
            // stream name is maggled with the consumer name
            const StringImm *consumer_imm = op->args[2].as<StringImm>();
            internal_assert(consumer_imm);
            stream_name += ".to." + consumer_imm->value;
        }
        do_indent();
        stream << a1 << " = " << print_name(stream_name) << ".read();\n";
        id = "0"; // skip evaluation

	// add as coreir input
	string stream_print_name = print_name(stream_name);
	if (hw_inout_set.count(stream_print_name) > 0) {
	  stream << "// " << stream_print_name << " added as an input" << input_idx  << "\n";
	  hw_wire_set[stream_print_name] = self->sel("in")->sel(input_idx);
	  input_idx++;
	} else if (hw_wire_set.count(stream_print_name)) {
	  hw_wire_set[a1] = hw_wire_set[stream_print_name];
	  stream << "// added to wire_set: " << a1 << "\n";
	} else {
	  stream << "// " << stream_print_name << " not found as an input" << input_idx << " or in wire_set\n";
	}
    } else if (ends_with(op->name, ".stencil") ||
               ends_with(op->name, ".stencil_update")) {
        ostringstream rhs;
        // IR: out.stencil_update(0, 0, 0)
        // C: out_stencil_update(0, 0, 0)
        vector<string> args_indices(op->args.size());
        for(size_t i = 0; i < op->args.size(); i++)
            args_indices[i] = print_expr(op->args[i]);

        rhs << print_name(op->name) << "(";
	string stencil_print_name = print_name(op->name);
        for(size_t i = 0; i < op->args.size(); i++) {
            rhs << args_indices[i];
	    stencil_print_name += "_" + args_indices[i];
            if (i != op->args.size() - 1)
                rhs << ", ";
        }
        rhs << ")";
	rhs << "[stencil]";

        string out_var = print_assignment(op->type, rhs.str());

	// coreir
        if (hw_wire_set.count(stencil_print_name)) {
	  hw_wire_set[out_var] = hw_wire_set[stencil_print_name];
	  stream << "// added to wire_set: " << out_var << " using stencil+idx\n";
	} else if (hw_wire_set.count(print_name(op->name)) > 0) {
	  CoreIR::Wireable* stencil_wire = hw_wire_set[print_name(op->name)];
	  for(size_t i = 0; i < op->args.size(); i++) {
	    int index = stoi(args_indices[i]);
	    stencil_wire = stencil_wire->sel(index);
	  }
	  hw_wire_set[out_var] = stencil_wire;
	  stream << "// added to wire_set: " << out_var << " using stencil\n";
	} else {
	  //FIXME: fix input stencil cnst
	  stream << "// " << stencil_print_name << " not found so creating cnst" << endl;
	  string cnst_name = "cnst" + out_var;
	  int cnst_value = 999;
	  CoreIR::Wireable* cnst = def->addInstance(cnst_name,  gens["const"], {{"width", context->argInt(bitwidth)}},
						    {{"value",context->argInt(cnst_value)}});
	  hw_wire_set[out_var] = cnst->sel("out");;
	}
	
    } else if (op->name == "dispatch_stream") {
        // emits the calling arguments in comment
        vector<string> args(op->args.size());
        for(size_t i = 0; i < op->args.size(); i++)
            args[i] = print_expr(op->args[i]);

        do_indent();
        stream << "// dispatch_stream(";
        for(size_t i = 0; i < args.size(); i++) {
            stream << args[i];

            if (i != args.size() - 1)
                stream << ", ";
        }
        stream << ");\n";
        // syntax:
        //   dispatch_stream(stream_name, num_of_dimensions,
        //                   stencil_size_dim_0, stencil_step_dim_0, store_extent_dim_0,
        //                   [stencil_size_dim_1, stencil_step_dim_1, store_extent_dim_1, ...]
        //                   num_of_consumers,
        //                   consumer_0_name, fifo_0_depth,
        //                   consumer_0_offset_dim_0, consumer_0_extent_dim_0,
        //                   [consumer_0_offset_dim_1, consumer_0_extent_dim_1, ...]
        //                   [consumer_1_name, ...])

        // recover the structed data from op->args
        internal_assert(op->args.size() >= 2);
        const Variable *stream_name_var = op->args[0].as<Variable>();
        internal_assert(stream_name_var);
        string stream_name = stream_name_var->name;
        size_t num_of_demensions = *as_const_int(op->args[1]);
        vector<int> stencil_sizes(num_of_demensions);
        vector<int> stencil_steps(num_of_demensions);
        vector<int> store_extents(num_of_demensions);

        internal_assert(op->args.size() >= num_of_demensions*3 + 2);
        for (size_t i = 0; i < num_of_demensions; i++) {
            stencil_sizes[i] = *as_const_int(op->args[i*3 + 2]);
            stencil_steps[i] = *as_const_int(op->args[i*3 + 3]);
            store_extents[i] = *as_const_int(op->args[i*3 + 4]);
        }

        internal_assert(op->args.size() >= num_of_demensions*3 + 3);
        size_t num_of_consumers = *as_const_int(op->args[num_of_demensions*3 + 2]);
        vector<string> consumer_names(num_of_consumers);
        vector<int> consumer_fifo_depth(num_of_consumers);
        vector<vector<int> > consumer_offsets(num_of_consumers);
        vector<vector<int> > consumer_extents(num_of_consumers);

        internal_assert(op->args.size() >= num_of_demensions*3 + 3 + num_of_consumers*(2 + 2*num_of_demensions));
        for (size_t i = 0; i < num_of_consumers; i++) {
            const StringImm *string_imm = op->args[num_of_demensions*3 + 3 + (2 + 2*num_of_demensions)*i].as<StringImm>();
            internal_assert(string_imm);
            consumer_names[i] = string_imm->value;
            const IntImm *int_imm = op->args[num_of_demensions*3 + 4 + (2 + 2*num_of_demensions)*i].as<IntImm>();
            internal_assert(int_imm);
            consumer_fifo_depth[i] = int_imm->value;
            vector<int> offsets(num_of_demensions);
            vector<int > extents(num_of_demensions);
            for (size_t j = 0; j < num_of_demensions; j++) {
                offsets[j] = *as_const_int(op->args[num_of_demensions*3 + 5 + (2 + 2*num_of_demensions)*i + 2*j]);
                extents[j] = *as_const_int(op->args[num_of_demensions*3 + 6 + (2 + 2*num_of_demensions)*i + 2*j]);
            }
            consumer_offsets[i] = offsets;
            consumer_extents[i] = extents;
        }

        // emits declarations of streams for each consumer
        internal_assert(stencils.contains(stream_name));
        Stencil_Type stream_type = stencils.get(stream_name);

        // Optimization. if there is only one consumer and its fifo depth is zero
        // , use C++ reference for the consumer stream
        if (num_of_consumers == 1 && consumer_fifo_depth[0] == 0) {
            string consumer_stream_name = stream_name + ".to." + consumer_names[0];
            do_indent();
            stream << print_stencil_type(stream_type) << " &"
                   << print_name(consumer_stream_name) << " = "
                   << print_name(stream_name) << ";\n";
            id = "0"; // skip evaluation

	    // update coreir structure
	    string stream_in_name = print_name(stream_name);
	    string stream_out_name = print_name(consumer_stream_name);
	    if (hw_wire_set.count(stream_in_name) > 0) {
	      hw_wire_set[stream_out_name] = hw_wire_set[stream_in_name];
	      stream << "// updated list with " << stream_out_name << " = " << stream_in_name << "\n";
	    } else {
	      stream << "// couldn't find " << stream_in_name << "\n";
	    }
            return;
        }

        for (size_t i = 0; i < num_of_consumers; i++) {
            string consumer_stream_name = stream_name + ".to." + consumer_names[i];
            Stencil_Type consumer_stream_type = stream_type;
            consumer_stream_type.depth = std::max(consumer_fifo_depth[i], 1); // HLS tool doesn't support zero-depth FIFO yet
            do_indent();
            stream << print_stencil_type(consumer_stream_type) << ' '
                   << print_name(consumer_stream_name) << ";\n";
            // pragma
            stencils.push(consumer_stream_name, consumer_stream_type);
            stream << print_stencil_pragma(consumer_stream_name);
            stencils.pop(consumer_stream_name);
        }

        // emits for a loop for each dimensions (larger dimension number, outer the loop)
        for (int i = num_of_demensions - 1; i >= 0; i--) {
            string dim_name = "_dim_" + to_string(i);
            do_indent();
            // HLS C: for(int dim = 0; dim <= store_extent - stencil.size; dim += stencil.step)
            stream << "for (int " << dim_name <<" = 0; "
                   << dim_name << " <= " << store_extents[i] - stencil_sizes[i] << "; "
                   << dim_name << " += " << stencil_steps[i] << ")\n";
        }
        open_scope();
        // pragma
        stream << "#pragma HLS PIPELINE\n";
        // read stencil from stream
        Stencil_Type stencil_type = stream_type;
        stencil_type.type = Stencil_Type::StencilContainerType::Stencil;
        string stencil_name = "tmp_stencil";
        do_indent();
        stream << "Packed" << print_stencil_type(stencil_type) << ' '
               << print_name(stencil_name) << " = "
               << print_name(stream_name) << ".read();\n";

        // dispatch the stencil to each consumer stream
        for (size_t i = 0; i < num_of_consumers; i++) {
            string consumer_stream_name = stream_name + ".to." + consumer_names[i];
            // emits the predicate for dispatching stencils
            // HLS C: if(dim_0 >= consumer_offset_0 && dim_0 <= consumer_offset_0 + consumer_extent_0 - stencil_size_0
            //           [&& dim_1 >= consumer_offset_1 && dim_1 <= consumer_offset_1 + consumer_extent_1 - stencil_size_1...])
            do_indent();
            stream << "if (";
            for (size_t j = 0; j < num_of_demensions; j++) {
                string dim_name = "_dim_" + to_string(j);
                stream << dim_name << " >= " << consumer_offsets[i][j] << " && "
                       << dim_name << " <= " << consumer_offsets[i][j] + consumer_extents[i][j] - stencil_sizes[j];
                if (j != num_of_demensions - 1)
                    stream << " && ";
            }
            stream << ")\n";

            // emits the write call in the if body
            open_scope();
            do_indent();
            stream << print_name(consumer_stream_name) << ".write("
                   << print_name(stencil_name) << ");\n";
            close_scope("");
        }

        close_scope("");

        id = "0"; // skip evaluation
    } else {
        CodeGen_C::visit(op);
    }
}

void CodeGen_CoreIR_Base::visit(const Realize *op) {
    if (ends_with(op->name, ".stream")) {
        // create a stream type
        internal_assert(op->types.size() == 1);
        allocations.push(op->name, {op->types[0], "null"});
        Stencil_Type stream_type({Stencil_Type::StencilContainerType::Stream,
                    op->types[0], op->bounds, 1});
        stencils.push(op->name, stream_type);

        // emits the declaration for the stream
        do_indent();
        stream << print_stencil_type(stream_type) << ' ' << print_name(op->name) << ";\n";
        stream << print_stencil_pragma(op->name);

        // traverse down
        op->body.accept(this);

        // We didn't generate free stmt inside for stream type
        allocations.pop(op->name);
        stencils.pop(op->name);

    } else if (ends_with(op->name, ".stencil") ||
               ends_with(op->name, ".stencil_update")) {
        // create a stencil type
        internal_assert(op->types.size() == 1);
        allocations.push(op->name, {op->types[0], "null"});
        Stencil_Type stype({Stencil_Type::StencilContainerType::Stencil, op->types[0], op->bounds, 1});
        stencils.push(op->name, stype);

        do_indent();
        // Stencil<uint16_t, 1, 1, 1> conv1_stencil_update;
        stream << print_stencil_type(stype) << ' ' << print_name(op->name) << ";\n";
        stream << print_stencil_pragma(op->name);

        op->body.accept(this);

        // We didn't generate free stmt inside for stream type
        allocations.pop(op->name);
        stencils.pop(op->name);
    } else {
        CodeGen_C::visit(op);
    }
}

void CodeGen_CoreIR_Base::visit(const Provide *op) {
    if (ends_with(op->name, ".stencil") ||
        ends_with(op->name, ".stencil_update")) {
        // IR: buffered.stencil_update(1, 2, 3) =
        // C: buffered_stencil_update(1, 2, 3) =
        vector<string> args_indices(op->args.size());
        for(size_t i = 0; i < op->args.size(); i++)
            args_indices[i] = print_expr(op->args[i]);

        internal_assert(op->values.size() == 1);
        string id_value = print_expr(op->values[0]);

        do_indent();
	stream << "[provide]";
        stream << print_name(op->name) << "(";
	string new_name = print_name(op->name);

        for(size_t i = 0; i < op->args.size(); i++) {
            stream << args_indices[i];
	    new_name += "_" + args_indices[i];
            if (i != op->args.size() - 1)
                stream << ", ";
        }
        stream << ") = " << id_value << ";\n";

        cache.clear();

	// add to wire_set
	string in_name = id_value;
	CoreIR::Wireable* in_wire = get_wire(op->values[0], in_name);
	if (in_wire) {
	  hw_wire_set[new_name] = in_wire;
	  stream << "// added/modified in  wire_set: " << new_name << " = " << in_name << "\n";
	} else {
	  stream << "// " << in_name << " not found\n";
	}

    } else {
        CodeGen_C::visit(op);
    }
}

bool CodeGen_CoreIR_Base::id_hw_input(const Expr e) {
  return false;
  if (e.as<Load>()) {
    return true;
  } else {
    return false;
  }
}

bool CodeGen_CoreIR_Base::id_cnst(const Expr e) {
  if (e.as<IntImm>() || e.as<UIntImm>()) {
    return true;
  } else {
    return false;
  }
}

int CodeGen_CoreIR_Base::id_cnst_value(const Expr e) {
  const IntImm* e_int = e.as<IntImm>();
  const UIntImm* e_uint = e.as<UIntImm>();
  if (e_int) {
    return e_int->value;
  } else if (e_uint) {
    return e_uint->value;
  } else {
    cout << "invalid constant expr" <<endl;
    return -1;
  }
}

string CodeGen_CoreIR_Base::id_hw_section(Expr a, Expr b, Type t, char op_symbol, string a_name, string b_name) {
  bool is_input = id_hw_input(a) || id_hw_input(b);
  bool in_hw_section = hw_wire_set.count(a_name)>0 || hw_wire_set.count(b_name)>0;
  string out_var = print_assignment(t, a_name + " " + op_symbol + " " + b_name);

  //  if (hw_wire_set.size()>0) { stream << "a:" << print_expr(a) << " b:" << print_expr(b) << endl; }
  if (is_input || in_hw_section) {
    return out_var;
    //    if (is_input) {stream << "input mult with output: " << out_var << endl; }
    //    if (in_hw_section) {stream << "hw_section mult with output: " << out_var <<endl; }
  } else {
    return "";
  }
}

CoreIR::Wireable* CodeGen_CoreIR_Base::get_wire(Expr e, string name) {
  if (id_hw_input(e)) {
    stream << "// using hw input" << endl;
    return self->sel("in");
  } else if (id_cnst(e)) {
    int cnst_value = id_cnst_value(e);
    string cnst_name = "const" + name;
    CoreIR::Wireable* cnst = def->addInstance(cnst_name,  gens["const"], {{"width", context->argInt(bitwidth)}},
					      {{"value",context->argInt(cnst_value)}});
    stream << "// added cnst: " << name << "\n";
    return cnst->sel("out");
  } else  {
    CoreIR::Wireable* wire = hw_wire_set[name];

    if (wire) { 
      return wire;
    } else {
      cout << "ERROR: invalid wire in tb: " << name << endl; 
      stream << "// invalid wire: couldn't find " << name << endl;
	stream << "\n// hw_wire_set contains: ";
	for (auto x : hw_wire_set) {
	  stream << " " << x.first;
	}
        stream << "\n";

      return self->sel("in");
    }

  }
}

void CodeGen_CoreIR_Base::visit_binop(Type t, Expr a, Expr b, char op_sym, string coreir_name, string op_name) {
  //stream << "// b-saw a(n) " << op_name << endl;
  string a_name = print_expr(a);
  string b_name = print_expr(b);

  string out_var = id_hw_section(a, b, t, op_sym, a_name, b_name);
  if (out_var.compare("") != 0) {
    string binop_name = op_name + a_name + b_name;
    CoreIR::Wireable* coreir_inst = def->addInstance(binop_name,gens[coreir_name], {{"width", context->argInt(bitwidth)}});
    def->connect(get_wire(a, a_name), coreir_inst->sel("in")->sel(0));
    def->connect(get_wire(b, b_name), coreir_inst->sel("in")->sel(1));
    hw_wire_set[out_var] = coreir_inst->sel("out");
  } else {
    //    stream << "tb-performed a << op_name<< :!!! " <<endl;//<< print_type(a.type()) << " " << print_type(b.type()) << endl;
  }

    if (id_hw_input(a)) { stream << "// " << op_name <<"a: self.in "; } else { stream << "// " << op_name << "a: " << a_name << " "; }
    if (id_hw_input(b)) { stream << "// " << op_name <<"b: self.in "; } else { stream << "// " << op_name << "b: " << b_name << " "; }
    stream << "o: " << out_var << endl;

  }
  

void CodeGen_CoreIR_Base::visit(const Mul *op) {
  visit_binop(op->type, op->a, op->b, '*', "mul", "mul");
}

void CodeGen_CoreIR_Base::visit(const Add *op) {
  visit_binop(op->type, op->a, op->b, '+', "add", "add");
}
  
void CodeGen_CoreIR_Base::visit(const Sub *op) {
  visit_binop(op->type, op->a, op->b, '-', "mul", "sub");
}

void CodeGen_CoreIR_Base::visit(const Cast *op) {
    string in_var = print_expr(op->value);
    string out_var = print_assignment(op->type, "(" + print_type(op->type) + ")(" + in_var + ")");
    if (hw_wire_set.count(in_var) > 0) {
      hw_wire_set[out_var] = get_wire(op->value, in_var);
    } else {
      stream << "// couldn't find " << in_var << endl;
    }
}


}
}


