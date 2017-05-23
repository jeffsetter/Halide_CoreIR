#include <iostream>
#include <limits>

#include "CodeGen_Internal.h"
#include "CodeGen_CoreIR_Testbench.h"
#include "Substitute.h"
#include "IROperator.h"
#include "Param.h"
#include "Var.h"
#include "Lerp.h"
#include "Simplify.h"

#include "coreir.h"
#include "coreir-lib/stdlib.h"
#include "coreir-pass/passes.h"

namespace Halide {

namespace Internal {

using std::ostream;
using std::endl;
using std::string;
using std::vector;
using std::pair;
using std::map;

class CoreIR_Closure : public Closure {
public:
    CoreIR_Closure(Stmt s)  {
        s.accept(this);
    }

    vector<CoreIR_Argument> arguments(const Scope<CodeGen_CoreIR_Base::Stencil_Type> &scope);

protected:
    using Closure::visit;

};


vector<CoreIR_Argument> CoreIR_Closure::arguments(const Scope<CodeGen_CoreIR_Base::Stencil_Type> &streams_scope) {
    vector<CoreIR_Argument> res;
    for (const pair<string, Closure::BufferRef> &i : buffers) {
        debug(3) << "buffer: " << i.first << " " << i.second.size;
        if (i.second.read) debug(3) << " (read)";

        if (i.second.write) debug(3) << " (write)";
        debug(3) << "\n";
    }
    internal_assert(buffers.empty()) << "we expect no references to buffers in a hw pipeline.\n";
    for (const pair<string, Type> &i : vars) {
        debug(3) << "var: " << i.first << "\n";
        if(ends_with(i.first, ".stream") ||
           ends_with(i.first, ".stencil") ) {
            CodeGen_CoreIR_Base::Stencil_Type stype = streams_scope.get(i.first);
            res.push_back({i.first, true, Type(), stype});
        } else if (ends_with(i.first, ".stencil_update")) {
            internal_error << "we don't expect to see a stencil_update type in CoreIR_Closure.\n";
        } else {
            // it is a scalar variable
            res.push_back({i.first, false, i.second, CodeGen_CoreIR_Base::Stencil_Type()});
        }
    }
    return res;
}

namespace {
const string hls_headers =
    "#include <hls_stream.h>\n"
    "#include \"Stencil.h\"\n"
    "#include \"hls_target.h\"\n";
}

CodeGen_CoreIR_Testbench::CodeGen_CoreIR_Testbench(ostream &tb_stream)
    : CodeGen_CoreIR_Base(tb_stream, CPlusPlusImplementation, ""),
      cg_target("coreir_target") {
    cg_target.init_module();

    stream << hls_headers;

    // set up coreir generation
    n = 16;
    c = CoreIR::newContext();
    g = c->getGlobal();
    stdlib = CoreIRLoadLibrary_stdlib(c);

    // add all generators from stdlib
    std::vector<string> gen_names = {"add", "mul", "const"};
    for (auto gen_name : gen_names) {
      gens[gen_name] = stdlib->getGenerator(gen_name);
      assert(gens[gen_name]);
    }

    // TODO: fix static module definition
    CoreIR::Type* design_type = c->Record({
	{"in",c->Array(n,c->BitIn())},
	{"out",c->Array(n,c->Bit())}
    });
    design = g->newModuleDecl("DesignTop", design_type);
    def = design->newModuleDef();
    self = def->sel("self");
}

CodeGen_CoreIR_Testbench::~CodeGen_CoreIR_Testbench() {
  // typecheck and write coreir json
  design->setDef(def);
  c->checkerrors();
  design->print();

  bool err = false;

  CoreIR::saveModule(design, "design_top.json", &err);
  if (err) {
    cout << "Could not save json :(" << endl;
    exit(1);
  } else {
    cout << "We passed!!! (GREEN PASS) Yay!" << endl;
  }

  CoreIR::loadModule(c,"design_top.json", &err);
  if (err) {
    cout << "failed to reload json" << endl;
    exit(1);
  }

  CoreIR::deleteContext(c);
}

void CodeGen_CoreIR_Testbench::visit(const ProducerConsumer *op) {
    if (starts_with(op->name, "_hls_target.")) {
        Stmt hw_body = op->produce;

        debug(1) << "compute the closure for " << op->name << '\n';
        CoreIR_Closure c(hw_body);
        vector<CoreIR_Argument> args = c.arguments(stencils);

        // generate CoreIR target code using the child code generator
        string ip_name = unique_name("hls_target");
        cg_target.add_kernel(hw_body, ip_name, args);

        // emits the target function call
        do_indent();
        stream << print_name(ip_name) << "("; // avoid starting with '_'
        for(size_t i = 0; i < args.size(); i++) {
            stream << print_name(args[i].name);
            if(i != args.size() - 1)
                stream << ", ";
        }
        stream <<");\n";

        print_stmt(op->consume);
    } else {
        CodeGen_CoreIR_Base::visit(op);
    }
}


void CodeGen_CoreIR_Testbench::visit(const Call *op) {
    if (op->name == "stream_subimage") {
        std::ostringstream rhs;
        // add intrinsic functions to convert memory buffers to streams
        // syntax:
        //   stream_subimage(direction, buffer_var, stream_var, address_of_subimage_origin,
        //                   dim_0_stride, dim_0_extent, ...)
        internal_assert(op->args.size() >= 6 && op->args.size() <= 12);
        const StringImm *direction = op->args[0].as<StringImm>();
        string a1 = print_expr(op->args[1]);
        string a2 = print_expr(op->args[2]);
        string a3 = print_expr(op->args[3]);
        if (direction->value == "buffer_to_stream") {
            rhs << "subimage_to_stream(";
        } else if (direction->value == "stream_to_buffer") {
            rhs << "stream_to_subimage(";
        } else {
            internal_error;
        }
        rhs << a1 << ", " << a2 << ", " << a3;
        for (size_t i = 4; i < op->args.size(); i++) {
            rhs << ", " << print_expr(op->args[i]);
        }
        rhs <<");\n";

        do_indent();
        stream << rhs.str();

        id = "0"; // skip evaluation
    } else if (op->name == "buffer_to_stencil") {
        internal_assert(op->args.size() == 2);
        // add a suffix to buffer var, in order to be compatible with CodeGen_C
        string a0 = print_expr(op->args[0]);
        string a1 = print_expr(op->args[1]);
        do_indent();
        stream << "buffer_to_stencil(" << a0 << ", " << a1 << ");\n";
        id = "0"; // skip evaluation
    } else {
        CodeGen_CoreIR_Base::visit(op);
    }
}

void CodeGen_CoreIR_Testbench::visit(const Realize *op) {
    if (ends_with(op->name, ".stream")) {
        // create a AXI stream type
        internal_assert(op->types.size() == 1);
        allocations.push(op->name, {op->types[0], "null"});
        Stencil_Type stream_type({Stencil_Type::StencilContainerType::AxiStream,
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
    } else {
        CodeGen_CoreIR_Base::visit(op);
    }
}

void CodeGen_CoreIR_Testbench::visit(const Block *op) {
    // emit stream_to_buffer call after the bulk of IR containing hardware pipeline
    // This is ugly right now, as the HLS simulation model and DMA programming model
    // are different on the order of pipeline IR and stream_to_buffer call..
    const Evaluate *eval = op->first.as<Evaluate>();
    if (!eval) {
        CodeGen_CoreIR_Base::visit(op);
        return;
    }
    const Call *call = eval->value.as<Call>();
    if (!call) {
        CodeGen_CoreIR_Base::visit(op);
        return;
    }
    if (call->name == "stream_subimage") {
        const StringImm *direction = call->args[0].as<StringImm>();
        if (direction->value == "stream_to_buffer") {
            internal_assert(op->rest.defined());
            op->rest.accept(this);
            op->first.accept(this);
            return;
        }
    }
    CodeGen_CoreIR_Base::visit(op);
    return;
}


bool CodeGen_CoreIR_Testbench::id_hw_input(const Expr e) {
  if (e.as<Load>()) {
    return true;
  } else {
    return false;
  }
}

bool CodeGen_CoreIR_Testbench::id_cnst(const Expr e) {
  if (e.as<IntImm>() || e.as<UIntImm>()) {
    return true;
  } else {
    return false;
  }
}

int CodeGen_CoreIR_Testbench::id_cnst_value(const Expr e) {
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
  
string CodeGen_CoreIR_Testbench::id_hw_section(Expr a, Expr b, Type t, char op_symbol, string a_name, string b_name) {
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

  CoreIR::Wireable* CodeGen_CoreIR_Testbench::get_wire(Expr e, string name) {
  if (id_hw_input(e)) {
    return self->sel("in");
  } else if (id_cnst(e)) {
    int cnst_value = id_cnst_value(e);
    string cnst_name = "const" + name;
    CoreIR::Wireable* cnst = def->addInstance(cnst_name,  gens["const"],{{"width",c->argInt(n)}},{{"value",c->argInt(cnst_value)}});
    return cnst->sel("out");
  } else  {
    CoreIR::Wireable* wire = hw_input_set[name];

    if (wire) { }
    else { cout << "invalid wire in tb: " << name << endl; return self->sel("in"); }
    return wire;
  }
}

  void CodeGen_CoreIR_Testbench::visit_binop(Type t, Expr a, Expr b, char op_sym, string coreir_name, string op_name) {
    //  stream << "tb-saw a " << op_name << "!!!!!!!!!!!!!!!!" << endl;
  string a_name = print_expr(a);
  string b_name = print_expr(b);

  string out_var = id_hw_section(a, b, t, op_sym, a_name, b_name);
  if (out_var.compare("") != 0) {
    string binop_name = op_name + a_name + b_name;
    CoreIR::Wireable* coreir_inst = def->addInstance(binop_name,gens[coreir_name],{{"width",c->argInt(n)}});
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

void CodeGen_CoreIR_Testbench::visit(const Mul *op) {
  visit_binop(op->type, op->a, op->b, '*', "mul", "mul");
}

void CodeGen_CoreIR_Testbench::visit(const Add *op) {
  visit_binop(op->type, op->a, op->b, '+', "add", "add");
}
  
void CodeGen_CoreIR_Testbench::visit(const Sub *op) {
  visit_binop(op->type, op->a, op->b, '-', "mul", "sub");
}

void CodeGen_CoreIR_Testbench::visit(const Store *op) {
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

  // TODO: add more operators

}
}
