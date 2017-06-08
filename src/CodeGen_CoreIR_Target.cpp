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
<<<<<<< HEAD
    std::vector<string> std_gen_names = {"add", "mul", "const"};
    for (auto gen_name : std_gen_names) {
=======
    std::vector<string> gen_names = {"add", "mul", "const"};
    for (auto gen_name : gen_names) {
>>>>>>> 6676d8366af0acb4cd1fedb28f6fd39c704eabb8
      gens[gen_name] = stdlib->getGenerator(gen_name);
      assert(gens[gen_name]);
    }

<<<<<<< HEAD
    // add all generators from cgralib
    std::vector<string> cgra_gen_names = {"Linebuffer", "IO"};
    for (auto gen_name : cgra_gen_names) {
      gens[gen_name] = cgralib->getGenerator(gen_name);
      assert(gens[gen_name]);
    }
=======
    // TODO: fix static module definition
    CoreIR::Type* design_type = c->Record({
	{"in",c->Array(n,c->BitIn())},
	{"out",c->Array(n,c->Bit())}
    });
    design = g->newModuleDecl("DesignTarget", design_type);
    def = design->newModuleDef();
    self = def->sel("self");
>>>>>>> 6676d8366af0acb4cd1fedb28f6fd39c704eabb8
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
<<<<<<< HEAD
  if (def != NULL && def->hasInstances()) {
    // print coreir to stdout
=======
    // typecheck and print coreir to stdout
>>>>>>> 6676d8366af0acb4cd1fedb28f6fd39c704eabb8
    design->setDef(def);
    context->checkerrors();
    design->print();
    
    bool err = false;
<<<<<<< HEAD
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
    design->print();
    //CoreIR::Instance* i = cast<CoreIR::Instance>(design->getDef()->sel("DesignTop"));
    //i->getModuleRef()->print();

    cout << "Flattening everything" << endl;
    flatten(context,design,&err);
    design->print();
    design->getDef()->validate();

=======
>>>>>>> 6676d8366af0acb4cd1fedb28f6fd39c704eabb8
  
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
	      num_inouts++;
	    }
        } else {
            stream << print_type(args[i].scalar_type) << " " << arg_name;
        }

        if (i < args.size()-1) stream << ",\n";
    }

    // Emit prototype to coreir
    create_json = (num_inouts > 0);
    int num_inputs = num_inouts ? num_inouts-1 : 1;
    // FIXME: can't create input and output for coreir dag, bc can't distinguish
    CoreIR::Type* design_type = context->Record({
	{"in",context->Array(num_inputs, context->Array(bitwidth,context->BitIn()))},
	{"out",context->Array(bitwidth,context->Bit())}
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

<<<<<<< HEAD
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Call *op) {
=======
bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::id_hw_input(const Expr e) {
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

string CodeGen_CoreIR_Target::CodeGen_CoreIR_C::id_hw_section(Expr a, Expr b, Type t, char op_symbol, string a_name, string b_name) {
  bool is_input = id_hw_input(a) || id_hw_input(b);
  bool in_hw_section = hw_input_set.count(a_name)>0 || hw_input_set.count(b_name)>0;
  string out_var = print_assignment(t, a_name + " " + op_symbol + " " + b_name);

  //  if (hw_input_set.size()>0) { stream << "a:" << print_expr(a) << " b:" << print_expr(b) << endl; }
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
    return self->sel("in");
  } else if (id_cnst(e)) {
    int cnst_value = id_cnst_value(e);
    string cnst_name = "const" + name;
    CoreIR::Wireable* cnst = def->addInstance(cnst_name,  gens["const"], {{"width",c->argInt(n)}}, {{"value",c->argInt(cnst_value)}});
    return cnst->sel("out");
  } else  {
    CoreIR::Wireable* wire = hw_input_set[name];

    if (wire) { }
    else { cout << "invalid wire in tb: " << name << endl; return self->sel("in"); }
    return wire;
  }
}

  void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit_binop(Type t, Expr a, Expr b, char op_sym, string coreir_name, string op_name) {
    //  stream << "tb-saw a " << op_name << "!!!!!!!!!!!!!!!!" << endl;
  string a_name = print_expr(a);
  string b_name = print_expr(b);

  string out_var = id_hw_section(a, b, t, op_sym, a_name, b_name);
  if (out_var.compare("") != 0) {
    string binop_name = op_name + a_name + b_name;
    CoreIR::Wireable* coreir_inst = def->addInstance(binop_name,gens[coreir_name], {{"width",c->argInt(n)}});
    def->connect(get_wire(a, a_name), coreir_inst->sel("in")->sel(0));
    def->connect(get_wire(b, b_name), coreir_inst->sel("in")->sel(1));
    hw_input_set[out_var] = coreir_inst->sel("out");

    if (id_hw_input(a)) { stream << op_name <<"a: self.in "; } else { stream << op_name << "a: " << a_name << " "; }
    if (id_hw_input(b)) { stream << op_name <<"b: self.in" <<endl; } else { stream << op_name << "b: " << b_name << endl; }
    stream << op_name<<"o: " << out_var << endl;
    
  } else {
    //    stream << "tb-performed a << op_name<< :!!! " <<endl;//<< print_type(a.type()) << " " << print_type(b.type()) << endl;
  }

  }

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Mul *op) {
  visit_binop(op->type, op->a, op->b, '*', "mul", "mul");
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Add *op) {
  visit_binop(op->type, op->a, op->b, '+', "add", "add");
}
  
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Sub *op) {
  visit_binop(op->type, op->a, op->b, '-', "mul", "sub");
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Store *op) {
    Type t = op->value.type();

    bool type_cast_needed =
        t.is_handle() ||
        !allocations.contains(op->name) ||
        allocations.get(op->name).type != t;

    string id_index = print_expr(op->index);
    string id_value = print_expr(op->value);
    do_indent();

    if (type_cast_needed) {
        stream << "((const "
               << print_type(t)
               << " *)"
               << print_name(op->name)
               << ")";
    } else {
        stream << print_name(op->name);
    }
    stream << "["
           << id_index
           << "] = "
           << id_value
           << ";\n";

  bool in_hw_section = hw_input_set.count(id_value)>0;

  if (in_hw_section){
    stream << "to out: " << id_value << endl;
    def->connect(hw_input_set[id_value], self->sel("out"));
  } else {
    stream << "out: " << id_value << endl;
  }
  //  CodeGen_C::visit(op);
}

  void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Call *op) {
>>>>>>> 6676d8366af0acb4cd1fedb28f6fd39c704eabb8
    if (op->is_intrinsic(Call::rewrite_buffer)) {
      stream << "[rewrite_buffer]";
    }
    CodeGen_CoreIR_Base::visit(op);

}

}


}

