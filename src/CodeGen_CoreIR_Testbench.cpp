#include <iostream>
#include <limits>

#include "CodeGen_CoreIR_Testbench.h"
#include "CodeGen_Internal.h"
#include "Substitute.h"
#include "IROperator.h"
#include "Param.h"
#include "Var.h"
#include "Lerp.h"
#include "Simplify.h"

#include "context.hpp"
#include "stdlib.hpp"
#include "passes.hpp" 

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
      cg_target("rigel_target") {
    cg_target.init_module();

    stream << hls_headers;

    // set up coreir generation
    n = 16;
    c = CoreIR::newContext();
    g = c->getGlobal();
    stdlib = getStdlib(c);

    // add all generators from stdlib
    std::vector<string> gen_names = {"add2_16", "mult2_16", "const_16"};
    for (auto gen_name : gen_names) {
      gens[gen_name] = stdlib->getModule(gen_name);
      assert(gens[gen_name]);
    }

    // TODO: fix static module definition
    CoreIR::Type* design_type = c->Record({
	{"in",c->Array(n,c->BitIn())},
	{"out",c->Array(n,c->BitOut())}
    });
    design_top = g->newModuleDecl("DesignTop", design_type);
    def = design_top->newModuleDef();
    self = def->sel("self");
}

CodeGen_CoreIR_Testbench::~CodeGen_CoreIR_Testbench() {
  design_top->addDef(def);
  c->checkerrors();
  design_top->print();

  bool err = false;

  CoreIR::typecheck(c,design_top,&err);
  if (err) {
    cout << "failed typecheck" << endl;
  }

  CoreIR::saveModule(design_top, "design_top.json", &err);
  if (err) {
    cout << "Could not save json :(" << endl;
  } else {
    cout << "We passed!!! (GREEN PASS) Yay!" << endl;
  }

  CoreIR::Module* mod = CoreIR::loadModule(c,"design_top.json", &err);
  if (err) {
    cout << "failed to reload json" << endl;
  }
  mod->print();

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
        stream << ip_name << "("; // avoid starting with '_'
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


bool id_hw_input(const Expr e) {
  if (e.as<Load>()) {
    return true;
  } else {
    return false;
  }
}

bool id_cnst(const Expr e) {
  if (e.as<IntImm>() || e.as<UIntImm>()) {
    return true;
  } else {
    return false;
  }
}

int id_cnst_value(const Expr e) {
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

string CodeGen_CoreIR_Testbench::id_hw_section(Expr a, Expr b, Type t, char op_symbol) {
  bool is_input = id_hw_input(a) || id_hw_input(b);
  bool in_hw_section = hw_input_set.count(print_expr(a))>0 || hw_input_set.count(print_expr(b))>0;

  //  if (hw_input_set.size()>0) { stream << "a:" << print_expr(a) << " b:" << print_expr(b) << endl; }
  if (is_input || in_hw_section) {
    string out_var = print_assignment(t, print_expr(a) + " " + op_symbol + " " + print_expr(b));
    return out_var;
    //    if (is_input) {stream << "input mult with output: " << out_var << endl; }
    //    if (in_hw_section) {stream << "hw_section mult with output: " << out_var <<endl; }
  } else {
    return "";
  }
}

CoreIR::Wireable* CodeGen_CoreIR_Testbench::get_wire(Expr e) {
  if (id_hw_input(e)) {
    return self->sel("in");
  } else if (id_cnst(e)) {
    int cnst_value = id_cnst_value(e);
    CoreIR::Wireable* cnst = def->addInstance("const",  gens["const_16"], Args({{"value",c->int2Arg(cnst_value)}}));
    return cnst;
  } else  {
    CoreIR::Wireable* wire = hw_input_set[print_expr(e)];

    if (wire) { }
    else { cout << "invalid wire in tb: " << print_expr(e) << endl; return self->sel("in"); }
    return wire;
  }
}

void CodeGen_CoreIR_Testbench::visit(const Mul *op) {
  //  stream << "tb-saw a mult!!!!!!!!!!!!!!!!" << endl;
  CodeGen_C::visit(op);
  
  string out_var = id_hw_section(op->a, op->b, op->type, '*');
  if (out_var.compare("") != 0) {

    //    stream << "tb-performed a mult!!! which has a load... " << endl;
    string mult_name = "mult" + print_expr(op->a) + print_expr(op->b);
    CoreIR::Wireable* mul = def->addInstance(mult_name,gens["mult2_16"]);
    if (id_hw_input(op->a)) { stream << "mula: self.in" <<endl; } else { stream << "mula: " << print_expr(op->a) << endl; }
    if (id_hw_input(op->b)) { stream << "mulb: self.in" <<endl; } else { stream << "mulb: " << print_expr(op->b) << endl; }
    def->wire(get_wire(op->a), mul->sel("in0"));
    def->wire(get_wire(op->b), mul->sel("in1"));
    hw_input_set[out_var] = mul->sel("out");
    out_var = id_hw_section(op->a, op->b, op->type, '*'); // must access output var last
    stream << "mulo: " << out_var << endl;
    
  } else {
    //    stream << "tb-performed a mult!!! " <<endl;//<< print_type(op->a.type()) << " " << print_type(op->b.type()) << endl;
  }
  
}

void CodeGen_CoreIR_Testbench::visit(const Add *op) {
  //  stream << "tb-saw a mult!!!!!!!!!!!!!!!!" << endl;
  CodeGen_C::visit(op);
  
  string out_var = id_hw_section(op->a, op->b, op->type, '+');
  if (out_var.compare("") != 0) {

    //    stream << "tb-performed a mult!!! which has a load... " << endl;
    string adder_name = "adder" + print_expr(op->a) + print_expr(op->b);
    CoreIR::Wireable* add = def->addInstance(adder_name,gens["add2_16"]);
    if (id_hw_input(op->a)) { stream << "adda: self.in" <<endl; } else { stream << "adda: " << print_expr(op->a) << endl; }
    if (id_hw_input(op->b)) { stream << "addb: self.in" <<endl; } else { stream << "addb: " << print_expr(op->b) << endl; }
    def->wire(get_wire(op->a), add->sel("in0"));
    def->wire(get_wire(op->b), add->sel("in1"));
    hw_input_set[out_var] = add->sel("out");
    out_var = id_hw_section(op->a, op->b, op->type, '+'); // must access output var last
    stream << "addo: " << out_var << endl;
    
  } else {
    //    stream << "tb-performed a add!!! " <<endl;//<< print_type(op->a.type()) << " " << print_type(op->b.type()) << endl;
  }
  
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
  stream << "out: " << id_value << endl;
  if (in_hw_section){
    stream << "to out: " << id_value << endl;
    def->wire(hw_input_set[id_value], self->sel("out"));
  }
  //  CodeGen_C::visit(op);
}

  // TODO: add more operators
  // TODO: add better set of nodes in path (print_assignment/print_expr involves many operations under the hood)

}
}
