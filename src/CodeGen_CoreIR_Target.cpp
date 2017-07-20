#include <iostream>
#include <fstream>
#include <limits>
#include <algorithm>

#include "CodeGen_Internal.h"
#include "CodeGen_CoreIR_Target.h"
#include "Substitute.h"
#include "IRMutator.h"
#include "IROperator.h"
#include "Param.h"
#include "Var.h"
#include "Lerp.h"
#include "Simplify.h"

#include "coreir.h"
#include "coreir-lib/stdlib.h"
#include "coreir-lib/cgralib.h"
#include "coreir-pass/passes.h"


namespace Halide {
namespace Internal {

using std::ostream;
using std::endl;
using std::string;
using std::vector;
using std::ostringstream;
using std::ofstream;

namespace {

class ContainForLoop : public IRVisitor {
    using IRVisitor::visit;
    void visit(const For *op) {
        found = true;
        return;
    }

public:
    bool found;

    ContainForLoop() : found(false) {}
};

bool contain_for_loop(Stmt s) {
    ContainForLoop cfl;
    s.accept(&cfl);
    return cfl.found;
}

}

CodeGen_CoreIR_Target::CodeGen_CoreIR_Target(const string &name)
    : target_name(name),
      hdrc(hdr_stream, CodeGen_CoreIR_C::CPlusPlusHeader),
      srcc(src_stream, CodeGen_CoreIR_C::CPlusPlusImplementation) { }

CodeGen_CoreIR_Target::CodeGen_CoreIR_C::CodeGen_CoreIR_C(std::ostream &s, OutputKind output_kind) : CodeGen_CoreIR_Base(s, output_kind) {
    // set up coreir generation
    bitwidth = 16;
    context = CoreIR::newContext();
    global_ns = context->getGlobal();
    CoreIR::Namespace* stdlib = CoreIRLoadLibrary_stdlib(context);
    CoreIR::Namespace* cgralib = CoreIRLoadLibrary_cgralib(context);

    // add all generators from stdlib
    std::vector<string> stdlib_gen_names = {"add", "mul", "sub", "and", "or", "eq", "ult", "ugt", "ule", "uge", "const"};
    for (auto gen_name : stdlib_gen_names) {
      gens[gen_name] = stdlib->getGenerator(gen_name);
      assert(gens[gen_name]);
    }

    // add all generators from cgralib
    std::vector<string> cgra_gen_names = {"Linebuffer", "IO"};
    for (auto gen_name : cgra_gen_names) {
      gens[gen_name] = cgralib->getGenerator(gen_name);
      assert(gens[gen_name]);
    }
}


CodeGen_CoreIR_Target::~CodeGen_CoreIR_Target() {
    hdr_stream << "#endif\n";

    // write the header and the source streams into files
    string src_name = target_name + ".cpp";
    string hdr_name = target_name + ".h";
    ofstream src_file(src_name.c_str());
    ofstream hdr_file(hdr_name.c_str());
    src_file << src_stream.str() << endl;
    hdr_file << hdr_stream.str() << endl;
    src_file.close();
    hdr_file.close();
}

CodeGen_CoreIR_Target::CodeGen_CoreIR_C::~CodeGen_CoreIR_C() {
  if (def != NULL && def->hasInstances()) {
    // check the completed coreir design
    design->setDef(def);
    context->checkerrors();
    //design->print();
    
    bool err = false;
    std::string GREEN = "\033[0;32m";
    std::string RED = "\033[0;31m";
    std::string RESET = "\033[0m";
    
    CoreIR::saveModule(design, "design_top.txt", &err);
    if (err) {
      cout << RED << "Could not save dot file :(" << RESET << endl;
      context->die();
    }
    

    cout << "Running Generators" << endl;
    rungenerators(context,design,&err);
    if (err) context->die();
    //design->print();
    //CoreIR::Instance* i = cast<CoreIR::Instance>(design->getDef()->sel("DesignTop"));
    //i->getModuleRef()->print();

    cout << "Flattening everything" << endl;
    flatten(context,design,&err);
    design->print();
    design->getDef()->validate();

  
    // write out the json
    CoreIR::saveModule(design, "design_top.json", &err);
    if (err) {
      cout << RED << "Could not save json :(" << RESET << endl;
      context->die();
    }
    /*
    CoreIR::saveModule(design, "design_full.txt", &err);
    if (err) {
      cout << RED << "Could not save dot file :(" << RESET << endl;
      context->die();
    }
    */
    // check that we can reload the created json
    CoreIR::loadModule(context,"design_top.json", &err);
    if (err) {
      cout << RED << "failed to reload json" << RESET << endl;
      context->die();
    } else {
      cout << GREEN << "We created the .json!!! (GREEN PASS) Yay!" << RESET << endl;
    }
    
    CoreIR::deleteContext(context);
  } else {
    cout << "No target json outputted " << endl;
  }
}

namespace {
const string hls_header_includes =
    "#include <assert.h>\n"
    "#include <stdio.h>\n"
    "#include <stdlib.h>\n"
    "#include <hls_stream.h>\n"
    "#include \"Stencil.h\"\n";
}

void CodeGen_CoreIR_Target::init_module() {
    debug(1) << "CodeGen_CoreIR_Target::init_module\n";

    // wipe the internal streams
    hdr_stream.str("");
    hdr_stream.clear();
    src_stream.str("");
    src_stream.clear();

    // initialize the header file
    string module_name = "HALIDE_CODEGEN_COREIR_TARGET_" + target_name + "_H";
    std::transform(module_name.begin(), module_name.end(), module_name.begin(), ::toupper);
    hdr_stream << "#ifndef " << module_name << '\n';
    hdr_stream << "#define " << module_name << "\n\n";
    hdr_stream << hls_header_includes << '\n';

    // initialize the source file
    src_stream << "#include \"" << target_name << ".h\"\n\n";
    src_stream << "#include \"Linebuffer.h\"\n"
               << "#include \"halide_math.h\"\n";

}

void CodeGen_CoreIR_Target::add_kernel(Stmt s,
                                    const string &name,
                                    const vector<CoreIR_Argument> &args) {
    debug(1) << "CodeGen_CoreIR_Target::add_kernel " << name << "\n";

    hdrc.add_kernel(s, name, args);
    srcc.add_kernel(s, name, args);
}

void CodeGen_CoreIR_Target::dump() {
    std::cerr << src_stream.str() << std::endl;
}


string CodeGen_CoreIR_Target::CodeGen_CoreIR_C::print_stencil_pragma(const string &name) {
    ostringstream oss;
    internal_assert(stencils.contains(name));
    Stencil_Type stype = stencils.get(name);
    if (stype.type == Stencil_Type::StencilContainerType::Stream ||
        stype.type == Stencil_Type::StencilContainerType::AxiStream) {
        oss << "#pragma CoreIR STREAM variable=" << print_name(name) << " depth=" << stype.depth << "\n";
        if (stype.depth <= 100) {
            // use shift register implementation when the FIFO is shallow
            oss << "#pragma CoreIR RESOURCE variable=" << print_name(name) << " core=FIFO_SRL\n\n";
        }
    } else if (stype.type == Stencil_Type::StencilContainerType::Stencil) {
        oss << "#pragma CoreIR ARRAY_PARTITION variable=" << print_name(name) << ".value complete dim=0\n\n";
    } else {
        internal_error;
    }
    return oss.str();
}


void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::add_kernel(Stmt stmt,
                                                   const string &name,
                                                   const vector<CoreIR_Argument> &args) {

    // Emit the function prototype
    int num_inouts = 0;
    CodeGen_CoreIR_Base::Stencil_Type stype_last; // keeps track of the last stencil (output)
    stream << "void " << print_name(name) << "(\n";
    for (size_t i = 0; i < args.size(); i++) {
        string arg_name = "arg_" + std::to_string(i);
        if (args[i].is_stencil) {
            CodeGen_CoreIR_Base::Stencil_Type stype = args[i].stencil_type;

            internal_assert(args[i].stencil_type.type == Stencil_Type::StencilContainerType::AxiStream ||
                            args[i].stencil_type.type == Stencil_Type::StencilContainerType::Stencil);
            stream << print_stencil_type(args[i].stencil_type) << " ";
            if (args[i].stencil_type.type == Stencil_Type::StencilContainerType::AxiStream) {
                stream << "&";  // hls_stream needs to be passed by reference
            }
            stream << arg_name;
            allocations.push(args[i].name, {args[i].stencil_type.elemType, "null"});
            stencils.push(args[i].name, args[i].stencil_type);
	    if (args[i].stencil_type.type == Stencil_Type::StencilContainerType::AxiStream) {
	      hw_inout_set.insert(arg_name);
              cout << "inout: " << arg_name << " added with type " << CodeGen_C::print_type(stype.elemType) << " and bitwidth " << stype.elemType.bits() << endl;
	      num_inouts++;
              stype_last = stype;
	    }
        } else {
            stream << print_type(args[i].scalar_type) << " " << arg_name;
        }

        if (i < args.size()-1) stream << ",\n";
    }

    // Emit prototype to coreir
    create_json = (num_inouts > 0);
    int num_inputs = num_inouts ? num_inouts-1 : 1;
    int out_bitwidth = stype_last.elemType.bits() > 1 ? 16 : 1;

    cout << "design has " << num_inputs << " inputs with bitwidth " << to_string(bitwidth) << " " <<endl;
    // FIXME: can't create input and output for coreir dag, bc can't distinguish
    // FIXME: look at the bitwidth of the inputs as well as the output
    CoreIR::Type* design_type = context->Record({
	{"in",context->Array(num_inputs, context->Array(bitwidth,context->BitIn()))},
        {"out",context->Array(out_bitwidth,context->Bit())}
    });
    design = global_ns->newModuleDecl("DesignTop", design_type);
    def = design->newModuleDef();
    self = def->sel("self");
    input_idx = 0;

    if (is_header()) {
        stream << ");\n";
    } else {
        stream << ")\n";
        open_scope();

        // add CoreIR pragma at function scope
        stream << "#pragma CoreIR DATAFLOW\n"
               << "#pragma CoreIR INLINE region\n"
               << "#pragma CoreIR INTERFACE s_axilite port=return"
               << " bundle=config\n";
        for (size_t i = 0; i < args.size(); i++) {
            string arg_name = "arg_" + std::to_string(i);
            if (args[i].is_stencil) {
                if (ends_with(args[i].name, ".stream")) {
                    // stream arguments use AXI-stream interface
                    stream << "#pragma CoreIR INTERFACE axis register "
                           << "port=" << arg_name << "\n";
                } else {
                    // stencil arguments use AXI-lite interface
                    stream << "#pragma CoreIR INTERFACE s_axilite "
                           << "port=" << arg_name
                           << " bundle=config\n";
                    stream << "#pragma CoreIR ARRAY_PARTITION "
                           << "variable=" << arg_name << ".value complete dim=0\n";
                }
            } else {
                // scalar arguments use AXI-lite interface
                stream << "#pragma CoreIR INTERFACE s_axilite "
                       << "port=" << arg_name << " bundle=config\n";
            }
        }
        stream << "\n";

        // create alias (references) of the arguments using the names in the IR
        do_indent();
        stream << "// alias the arguments\n";
        for (size_t i = 0; i < args.size(); i++) {
            string arg_name = "arg_" + std::to_string(i);
            do_indent();
            if (args[i].is_stencil) {
                CodeGen_CoreIR_Base::Stencil_Type stype = args[i].stencil_type;
                stream << print_stencil_type(args[i].stencil_type) << " &"
                       << print_name(args[i].name) << " = " << arg_name << ";\n";
		if (hw_inout_set.count(arg_name) > 0) {
		  hw_inout_set.insert(print_name(args[i].name));
		}
		
            } else {
                stream << print_type(args[i].scalar_type) << " &"
                       << print_name(args[i].name) << " = " << arg_name << ";\n";
            }
        }
	stream << "\n// hw_inout_set contains: ";
	for (const std::string& x : hw_inout_set) {
	  stream << " " << x;
	}
        stream << "\n";

        // print body
        print(stmt);

        close_scope("kernel hls_target" + print_name(name));
    }
    stream << "\n";

    for (size_t i = 0; i < args.size(); i++) {
        // Remove buffer arguments from allocation scope
        if (args[i].stencil_type.type == Stencil_Type::StencilContainerType::Stream) {
            allocations.pop(args[i].name);
            stencils.pop(args[i].name);
        }
    }
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Provide *op) {
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
        CodeGen_CoreIR_Base::visit(op);
    }
}


// almost that same as CodeGen_C::visit(const For *)
// we just add a 'CoreIR PIPELINE' pragma after the 'for' statement
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const For *op) {
    internal_assert(op->for_type == ForType::Serial)
        << "Can only emit serial for loops to CoreIR C\n";

    string id_min = print_expr(op->min);
    string id_extent = print_expr(op->extent);

    do_indent();
    stream << "for (int "
           << print_name(op->name)
           << " = " << id_min
           << "; "
           << print_name(op->name)
           << " < " << id_min
           << " + " << id_extent
           << "; "
           << print_name(op->name)
           << "++)\n";

    open_scope();
    // add a 'PIPELINE' pragma if it is an innermost loop
    if (!contain_for_loop(op->body)) {
        //stream << "#pragma CoreIR DEPENDENCE array inter false\n"
        //       << "#pragma CoreIR LOOP_FLATTEN off\n";
        stream << "#pragma CoreIR PIPELINE II=1\n";
    }
    op->body.accept(this);
    close_scope("for " + print_name(op->name));
}

class RenameAllocation : public IRMutator {
    const string &orig_name;
    const string &new_name;

    using IRMutator::visit;

    void visit(const Load *op) {
        if (op->name == orig_name ) {
            Expr index = mutate(op->index);
            expr = Load::make(op->type, new_name, index, op->image, op->param);
        } else {
            IRMutator::visit(op);
        }
    }

    void visit(const Store *op) {
        if (op->name == orig_name ) {
            Expr value = mutate(op->value);
            Expr index = mutate(op->index);
            stmt = Store::make(new_name, value, index, op->param);
        } else {
            IRMutator::visit(op);
        }
    }

    void visit(const Free *op) {
        if (op->name == orig_name) {
            stmt = Free::make(new_name);
        } else {
            IRMutator::visit(op);
        }
    }

public:
    RenameAllocation(const string &o, const string &n)
        : orig_name(o), new_name(n) {}
};

// most code is copied from CodeGen_C::visit(const Allocate *)
// we want to check that the allocation size is constant, and
// add a 'CoreIR ARRAY_PARTITION' pragma to the allocation
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Allocate *op) {
    // We don't add scopes, as it messes up the dataflow directives in CoreIR compiler.
    // Instead, we rename the allocation to a unique name
    //open_scope();

    internal_assert(!op->new_expr.defined());
    internal_assert(!is_zero(op->condition));
    int32_t constant_size;
    constant_size = op->constant_allocation_size();
    if (constant_size > 0) {

    } else {
        internal_error << "Size for allocation " << op->name
                       << " is not a constant.\n";
    }

    // rename allocation to avoid name conflict due to unrolling
    string alloc_name = op->name + unique_name('a');
    Stmt new_body = RenameAllocation(op->name, alloc_name).mutate(op->body);

    Allocation alloc;
    alloc.type = op->type;
    allocations.push(alloc_name, alloc);

    do_indent();
    stream << print_type(op->type) << ' '
           << print_name(alloc_name)
           << "[" << constant_size << "];\n";
    // add a 'ARRAY_PARTITION" pragma
    //stream << "#pragma CoreIR ARRAY_PARTITION variable=" << print_name(op->name) << " complete dim=0\n\n";

    new_body.accept(this);

    // Should have been freed internally
    internal_assert(!allocations.contains(alloc_name))
        << "allocation " << alloc_name << " is not freed.\n";

    //close_scope("alloc " + print_name(op->name));

}


void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Call *op) {
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
	  //cout << "// " << lb_in_name << " added as an input" << input_idx  << "\n";
	  hw_wire_set[lb_in_name] = self->sel("in")->sel(input_idx);
	  input_idx++;
	} else {
	  stream << "// " << lb_in_name << " not found as an input" << "\n";
	}

	// add linebuffer to coreir
	Expr lb_dim0 = stencil_type.bounds[0].extent;
	Expr lb_dim1 = stencil_type.bounds[1].extent;

	string lb_name = "lb" + lb_in_name;
	int stencil_width = id_cnst_value(lb_dim0);
	int stencil_height = id_cnst_value(lb_dim1);
	int image_width = id_cnst_value(op->args[2]);
        int fifo_depth = image_width;
        internal_assert(fifo_depth > 0);

	stream << "// stencil size: " << stencil_width << " " << stencil_height << " and image width " << image_width << std::endl
               << "//  using fifo_depth " << fifo_depth << std::endl;
        

	CoreIR::Wireable* coreir_lb = def->addInstance(lb_name, gens["Linebuffer"],
  			         {{"bitwidth",context->argInt(bitwidth)}, {"stencil_width", context->argInt(stencil_width)},
				  {"stencil_height", context->argInt(stencil_height)}, {"image_width", context->argInt(fifo_depth)}}
						       );
	def->connect(hw_wire_set[lb_in_name], coreir_lb->sel("in"));
	hw_wire_set[lb_out_name] = coreir_lb->sel("out");	

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
	  //cout << "// " << stream_print_name << " added as an input" << input_idx  << "\n";
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
          stream << "trying to hook up " << print_name(op->name) << endl;
          cout << "trying to hook up " << print_name(op->name) << endl;


	  CoreIR::Wireable* stencil_wire = hw_wire_set[print_name(op->name)];
	  CoreIR::Wireable* orig_stencil_wire = stencil_wire;
          for (size_t i = op->args.size(); i-- > 0 ;) {
	    uint index = stoi(args_indices[i]);
            CoreIR::Type* wire_type = stencil_wire->getType();
            cout << "type is " << wire_type->getKind() << " and has length " << static_cast<CoreIR::ArrayType*>(wire_type)->getLen() << endl;

            if (wire_type->getKind() == CoreIR::Type::TypeKind::TK_Array && 
                index < static_cast<CoreIR::ArrayType*>(wire_type)->getLen()) {
              cout << "found a " << to_string(index) << endl;
              stencil_wire = stencil_wire->sel(index);

            } else {
              stream << "// couldn't find selectStr " << to_string(index) << endl;
              cout << "couldn't find selectStr " << to_string(index) << endl;
              stencil_wire = orig_stencil_wire;
              break;
            }
	  }
	  hw_wire_set[out_var] = stencil_wire;
	  stream << "// added to wire_set: " << out_var << " using stencil\n";
	} else {
	  //FIXME: fix input stencil cnst
	  stream << "// " << stencil_print_name << " not found so creating cnst" << endl;
	  string cnst_name = "cnst" + out_var;
	  int cnst_value = 1;//999
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

            // coreir
            string stencil_print_name = print_name(stream_name);
            string out_var = print_name(consumer_stream_name);
            if (hw_wire_set.count(stencil_print_name)) {
              hw_wire_set[out_var] = hw_wire_set[stencil_print_name];
              stream << "// added to wire_set: " << out_var << " using stencil+idx\n";
              //cout << "added to wire set" << endl;
            } else if (hw_inout_set.count(stencil_print_name)) {
              stream << "// added to wire_set: " << out_var << " using inout\n";              
              hw_wire_set[out_var] = self->sel("in")->sel(input_idx);
              input_idx++;
              cout << "added " << out_var << " to wire inout set at index " << input_idx-1 << endl;
            } else {
              //FIXME: fix input stencil cnst
              stream << "// " << stencil_print_name << " not found so creating cnst" << endl;
              string cnst_name = "cnst" + out_var;
              int cnst_value = 1;//999
              CoreIR::Wireable* cnst = def->addInstance(cnst_name,  gens["const"], {{"width", context->argInt(bitwidth)}},
                                                        {{"value",context->argInt(cnst_value)}});
              hw_wire_set[out_var] = cnst->sel("out");;
      	    }
            stream << "// we should add this one" <<endl;



        }

        close_scope("");

        id = "0"; // skip evaluation


    } else {
        CodeGen_CoreIR_Base::visit(op);
    }
}


bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::id_hw_input(const Expr e) {
  return false;
  if (e.as<Load>()) {
    return true;
  } else {
    return false;
  }
}

bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::id_cnst(const Expr e) {
  if (e.as<IntImm>() || e.as<UIntImm>()) {
    return true;
  } else {
    return false;
  }
}

int CodeGen_CoreIR_Target::CodeGen_CoreIR_C::id_cnst_value(const Expr e) {
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

string CodeGen_CoreIR_Target::CodeGen_CoreIR_C::id_hw_section(Expr a, Expr b, Type t, const char* op_symbol, string a_name, string b_name) {
  bool is_input = id_hw_input(a) || id_hw_input(b);
  bool in_hw_section = hw_wire_set.count(a_name)>0 || hw_wire_set.count(b_name)>0;
  const string out_var = print_assignment(t, a_name + " " + op_symbol + " " + b_name);

  //  if (hw_wire_set.size()>0) { stream << "a:" << print_expr(a) << " b:" << print_expr(b) << endl; }
  if (is_input || in_hw_section) {
    return out_var;
    //    if (is_input) {stream << "input mult with output: " << out_var << endl; }
    //    if (in_hw_section) {stream << "hw_section mult with output: " << out_var <<endl; }
  } else {
    return "";
  }
}

CoreIR::Wireable* CodeGen_CoreIR_Target::CodeGen_CoreIR_C::get_wire(Expr e, string name) {
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
    //cout << "using wire " << name << endl;

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

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit_binop(Type t, Expr a, Expr b, const char*  op_sym, string op_name) {
  //stream << "// b-saw a(n) " << op_name << endl;
  string a_name = print_expr(a);
  string b_name = print_expr(b);

  const string out_var = id_hw_section(a, b, t, op_sym, a_name, b_name);
  if (out_var.compare("") != 0) {
    string binop_name = op_name + a_name + b_name;
    CoreIR::Wireable* coreir_inst = def->addInstance(binop_name,gens[op_name], {{"width", context->argInt(bitwidth)}});

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
  

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Mul *op) {
  visit_binop(op->type, op->a, op->b, "*", "mul");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Add *op) {
  visit_binop(op->type, op->a, op->b, "+", "add");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Sub *op) {
  visit_binop(op->type, op->a, op->b, "-", "sub");
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const EQ *op) {
  visit_binop(op->type, op->a, op->b, "==", "eq");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const LT *op) {
  visit_binop(op->type, op->a, op->b, "<", "ult");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const LE *op) {
  visit_binop(op->type, op->a, op->b, "<=", "ule");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const GT *op) {
  visit_binop(op->type, op->a, op->b, ">", "ugt");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const GE *op) {
  visit_binop(op->type, op->a, op->b, ">=", "uge");
}
  // FIXME: create signed or unsigned ops based on inputs


void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Cast *op) {
    string in_var = print_expr(op->value);
    string out_var = print_assignment(op->type, "(" + print_type(op->type) + ")(" + in_var + ")");
    if (hw_wire_set.count(in_var) > 0) {
      hw_wire_set[out_var] = get_wire(op->value, in_var);
    } else {
      stream << "// couldn't find " << in_var << endl;
    }
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Load *op) {
  
    Type t = op->type;
    bool type_cast_needed =
        !allocations.contains(op->name) ||
        allocations.get(op->name).type != t;

    string id_index = print_expr(op->index);
    string name = print_name(op->name);
    ostringstream rhs;
    if (type_cast_needed) {
        rhs << "(("
            << print_type(op->type)
            << " *)"
            << name
            << ")";
    } else {
      rhs << name;
    }
    rhs << "["
        << id_index
        << "][load]";

    string out_var = print_assignment(op->type, rhs.str());

    // add to coreir
    string in_var = name + "_" + id_index;
    if (hw_wire_set.count(in_var) > 0) {
      hw_wire_set[out_var] = hw_wire_set[in_var];
      stream << "// added load: " << name << "_" << id_index << std::endl;
    } else {
      stream << "// couldn't find " << in_var << endl;
    }
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Store *op) {
    Type t = op->value.type();

    bool type_cast_needed =
        t.is_handle() ||
        !allocations.contains(op->name) ||
        allocations.get(op->name).type != t;

    string id_index = print_expr(op->index);
    string id_value = print_expr(op->value);
    string name = print_name(op->name);
    do_indent();

    if (type_cast_needed) {
        stream << "((const "
               << print_type(t)
               << " *)"
               << name
               << ")";
    } else {
        stream << name;
    }
    stream << "["
           << id_index
           << "] = "
           << id_value
           << ";\n";

    // add to coreir
    hw_wire_set[name + "_" + id_index] = get_wire(op->value, id_value);
    stream << "// added store: " << name << "_" << id_index << std::endl;

}


}
}

