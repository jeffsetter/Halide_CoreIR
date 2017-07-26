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
#include "coreir-lib/commonlib.h"
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

    // add all generators from stdlib
    CoreIR::Namespace* stdlib = CoreIRLoadLibrary_stdlib(context);
    std::vector<string> stdlib_gen_names = {"mul", "add", "sub", 
                                            "and", "or", "xor",
                                            "eq",
                                            "ult", "ugt", "ule", "uge",
                                            "slt", "sgt", "sle", "sge", 
                                            "dshl", "dashr",
                                            "mux", "const"};
    for (auto gen_name : stdlib_gen_names) {
      gens[gen_name] = stdlib->getGenerator(gen_name);
      assert(gens[gen_name]);
    }

    // add all generators from commonlib
    CoreIR::Namespace* commonlib = CoreIRLoadLibrary_commonlib(context);
    std::vector<string> commonlib_gen_names = {"umin", "smin", "umax", "smax"};
    for (auto gen_name : commonlib_gen_names) {
      gens[gen_name] = commonlib->getGenerator(gen_name);
      assert(gens[gen_name]);
    }

    // add all generators from cgralib
    CoreIR::Namespace* cgralib = CoreIRLoadLibrary_cgralib(context);
    std::vector<string> cgralib_gen_names = {"Linebuffer", "IO"};
    for (auto gen_name : cgralib_gen_names) {
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
    
    // CoreIR::saveModule(design, "design_top.txt", &err);
    // if (err) {
    //   cout << RED << "Could not save dot file :(" << RESET << endl;
    //   context->die();
    // }
    

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
    
    CoreIR::saveModule(design, "design_top.txt", &err);
    if (err) {
      cout << RED << "Could not save dot file :(" << RESET << endl;
      context->die();
    }
    
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
    CodeGen_CoreIR_Base::Stencil_Type stype_first; // keeps track of the first stencil (output)
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
              if (num_inouts == 0) {
                  stype_first = stype;
              }
	      num_inouts++;
	    }
        } else {
            stream << print_type(args[i].scalar_type) << " " << arg_name;
        }

        if (i < args.size()-1) stream << ",\n";
    }

    // Emit prototype to coreir
    create_json = (num_inouts > 0);
    uint num_inputs = num_inouts ? num_inouts-1 : 1;
    uint out_bitwidth = stype_first.elemType.bits() > 1 ? 16 : 1;

    cout << "design has " << num_inputs << " inputs with bitwidth " << to_string(bitwidth) << " " <<endl;
    // FIXME: can't distinguish bw output/input easily (assuming single output first)
    // FIXME: one bit arrays in coreir?
    // FIXME: more closely follow input/output types

    CoreIR::Type* out_type;
    if (out_bitwidth > 1) {
      out_type = context->Array(out_bitwidth,context->Bit());
    } else {
      out_type = context->Bit();
    }

    CoreIR::Type* design_type = context->Record({
	{"in",context->Array(num_inputs, context->Array(bitwidth,context->BitIn()))},
        {"out", out_type}
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
	stream << "[provide]" << op->name << " ";
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
    if (op->is_intrinsic(Call::bitwise_and)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        visit_binop(op->type, a, b, "&", "and");
    } else if (op->is_intrinsic(Call::bitwise_or)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        visit_binop(op->type, a, b, "|", "or");
    } else if (op->is_intrinsic(Call::bitwise_xor)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        visit_binop(op->type, a, b, "^", "xor");

    } else if (op->is_intrinsic(Call::shift_left)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        stream << "[shift left] ";
        visit_binop(op->type, a, b, "<<", "dshl");
    } else if (op->is_intrinsic(Call::shift_right)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        stream << "[shift right] ";
        visit_binop(op->type, a, b, ">>", "dashr");

    } else if (op->is_intrinsic(Call::reinterpret)) {
        string in_var = print_expr(op->args[0]);
        print_reinterpret(op->type, op->args[0]);

        stream << "// reinterpreting " << op->args[0] << " as " << in_var << endl;
        hw_wire_set[in_var] = get_wire(op->args[0], in_var);

        if (hw_wire_set.count(in_var) > 0) {
          stream << "// found " << in_var << endl;
        } else {
          stream << "// couldn't find " << in_var << endl;
        }
    } else if (op->is_intrinsic(Call::address_of)) {
      cout   << "ignoring address_of" << endl;
      stream << "ignoring address_of" << endl;

    } else if (op->name == "linebuffer") {
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
          stream << "// trying to hook up " << print_name(op->name) << endl;
          //cout << "trying to hook up " << print_name(op->name) << endl;


	  CoreIR::Wireable* stencil_wire = hw_wire_set[print_name(op->name)];
	  CoreIR::Wireable* orig_stencil_wire = stencil_wire;
          for (size_t i = op->args.size(); i-- > 0 ;) {
	    uint index = stoi(args_indices[i]);
            CoreIR::Type* wire_type = stencil_wire->getType();
            //cout << "type is " << wire_type->getKind() << " and has length " << static_cast<CoreIR::ArrayType*>(wire_type)->getLen() << endl;

            if (wire_type->getKind() == CoreIR::Type::TypeKind::TK_Array && 
                index < static_cast<CoreIR::ArrayType*>(wire_type)->getLen()) {
              //cout << "found a " << to_string(index) << endl;
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
      stream << "couldn't find " << op << endl;
        CodeGen_CoreIR_Base::visit(op);
    }
}

bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::is_cnst(const Expr e) {
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
    cout << "invalid constant expr" << endl;
    return -1;
  }
}

bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::is_wire(string var_name) {
  bool wire_exists = hw_wire_set.count(var_name) > 0;
  return wire_exists;
}

bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::is_inout(string var_name) {
  bool inout_exists = hw_inout_set.count(var_name) > 0;
  return inout_exists;
}

CoreIR::Wireable* CodeGen_CoreIR_Target::CodeGen_CoreIR_C::get_wire(Expr e, string name) {
  if (is_cnst(e)) {
    int cnst_value = id_cnst_value(e);
    string cnst_name = unique_name("const" + to_string(cnst_value) + "_");
    internal_assert(gens["const"]);
    CoreIR::Wireable* cnst = def->addInstance(cnst_name,  gens["const"], {{"width", context->argInt(bitwidth)}},
					      {{"value",context->argInt(cnst_value)}});
    stream << "// added cnst: " << name << "\n";
    return cnst->sel("out");
  } else if (is_inout(name)) {
    CoreIR::Wireable* inout = self->sel("in")->sel(input_idx);
    input_idx++;;
    internal_assert(inout);
    return inout;

  } else if (is_wire(name)) {
    CoreIR::Wireable* wire = hw_wire_set[name];
    internal_assert(wire);
    //cout << "using wire " << name << endl;
    return wire;

  } else {
    cout << "ERROR- invalid wire: " << name << endl; 
    stream << "// invalid wire: couldn't find " << name
           << "\n// hw_wire_set contains: ";
    for (auto x : hw_wire_set) {
      stream << " " << x.first;
    }
    stream << "\n";

    return self->sel("in");
  }
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit_binop(Type t, Expr a, Expr b, const char*  op_sym, string op_name) {
  string a_name = print_expr(a);
  string b_name = print_expr(b);
  CoreIR::Wireable* a_wire = get_wire(a, a_name);
  CoreIR::Wireable* b_wire = get_wire(b, b_name);
  string out_var;

  if (a_wire != NULL && b_wire != NULL) {
    out_var = print_assignment(t, a_name + " " + op_sym + " " + b_name);
    // return if this variable is cached
    if (hw_wire_set[out_var]) { return; }

    internal_assert(a.type().bits() == b.type().bits()) << "function " << op_name << " with " << a_name << " and " << b_name;
    uint inst_bits = a.type().bits() == 1 ? 1 : bitwidth;
    string binop_name = op_name + a_name + b_name;
    CoreIR::Wireable* coreir_inst = def->addInstance(binop_name,gens[op_name], {{"width", context->argInt(inst_bits)}});

    def->connect(a_wire, coreir_inst->sel("in")->sel(0));
    def->connect(b_wire, coreir_inst->sel("in")->sel(1));
    hw_wire_set[out_var] = coreir_inst->sel("out");
  } else {
    out_var = "";
    print_assignment(t, a_name + " " + op_sym + " " + b_name);
    //    stream << "tb-performed a << op_name<< :!!! " <<endl;//<< print_type(a.type()) << " " << print_type(b.type()) << endl;
  }

  if (is_inout(a_name)) { stream << "// " << op_name <<"a: self.in "; } else { stream << "// " << op_name << "a: " << a_name << " "; }
  if (is_inout(b_name)) { stream << "// " << op_name <<"b: self.in "; } else { stream << "// " << op_name << "b: " << b_name << " "; }
  stream << "o: " << out_var << endl;
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit_ternop(Type t, Expr a, Expr b, Expr c, const char*  op_sym1, const char* op_sym2, string op_name) {
  string a_name = print_expr(a);
  string b_name = print_expr(b);
  string c_name = print_expr(c);
  CoreIR::Wireable* a_wire = get_wire(a, a_name);
  CoreIR::Wireable* b_wire = get_wire(b, b_name);
  CoreIR::Wireable* c_wire = get_wire(c, c_name);
  string out_var;

  if (a_wire != NULL && b_wire != NULL && c_wire != NULL) {
    out_var = print_assignment(t, a_name + " " + op_sym1 + " " + b_name + " " + op_sym2 + " " + c_name);
    // return if this variable is cached
    if (hw_wire_set[out_var]) { return; }

    internal_assert(b.type().bits() == c.type().bits());
    uint inst_bits = b.type().bits() == 1 ? 1 : bitwidth;
    string ternop_name = op_name + a_name + b_name + c_name;
    CoreIR::Wireable* coreir_inst = def->addInstance(ternop_name,gens[op_name], {{"width", context->argInt(inst_bits)}});

    def->connect(a_wire, coreir_inst->sel("in")->sel("bit"));
    def->connect(b_wire, coreir_inst->sel("in")->sel("data")->sel(0));
    def->connect(c_wire, coreir_inst->sel("in")->sel("data")->sel(1));
    hw_wire_set[out_var] = coreir_inst->sel("out");

  } else {
    out_var = "";
    print_assignment(t, a_name + " " + op_sym1 + " " + b_name + " " + op_sym2 + " " + c_name);
  }

  if (is_inout(a_name)) { stream << "// " << op_name <<"a: self.in "; } else { stream << "// " << op_name << "a: " << a_name << " "; }
  if (is_inout(b_name)) { stream << "// " << op_name <<"b: self.in "; } else { stream << "// " << op_name << "b: " << b_name << " "; }
  if (is_inout(c_name)) { stream << "// " << op_name <<"c: self.in "; } else { stream << "// " << op_name << "c: " << c_name << " "; }
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
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Div *op) {
    int shift_amt;
    if (is_const_power_of_two_integer(op->b, &shift_amt)) {
      uint param_bitwidth = op->a.type().bits();
      Expr shift_expr = UIntImm::make(UInt(param_bitwidth), shift_amt);
      visit_binop(op->type, op->a, shift_expr, ">>", "dashr");
    } else {
      stream << "divide is not fully supported" << endl;
    }
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const And *op) {
  visit_binop(op->type, op->a, op->b, "&&", "and");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Or *op) {
  visit_binop(op->type, op->a, op->b, "||", "or");
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const EQ *op) {
  visit_binop(op->type, op->a, op->b, "==", "eq");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const LT *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, "<",  "ult");
  } else {
    visit_binop(op->type, op->a, op->b, "s<", "slt");
  }
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const LE *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, "<=",  "ule");
  } else {
    visit_binop(op->type, op->a, op->b, "s<=", "sle");
  }
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const GT *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, ">",  "ugt");
  } else {
    visit_binop(op->type, op->a, op->b, "s>", "sgt");
  }
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const GE *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, ">=",  "uge");
  } else {
    visit_binop(op->type, op->a, op->b, "s>=", "sge");
  }
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Max *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, "<max>",  "umax");
  } else {
    visit_binop(op->type, op->a, op->b, "<smax>", "smax");
  }
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Min *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, "<min>",  "umin");
  } else {
    visit_binop(op->type, op->a, op->b, "<smin>", "smin");
  }
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Select *op) {
  visit_ternop(op->type, op->condition, op->true_value, op->false_value, "?",":", "mux");
}
  /*
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const GE *op) {
  visit_binop(op->type, op->a, op->b, "^", "uge");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const GE *op) {
  visit_binop(op->type, op->a, op->b, "", "uge");
}
  */


void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Cast *op) {
  stream << "[cast]";
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

