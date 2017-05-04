#ifndef HALIDE_CODEGEN_COREIR_BASE_H
#define HALIDE_CODEGEN_COREIR_BASE_H

/** \file
 *
 * Defines an base class of the CoreIR C code-generator
 */
#include "CodeGen_C.h"
#include "Module.h"
#include "Scope.h"

#include "coreir.h"

namespace Halide {

namespace Internal {

/** This class emits C++ code from given Halide stmt that contains
 * stream and stencil types.
 */
class CodeGen_CoreIR_Base : public CodeGen_C {
public:
    /** Initialize a C code generator pointing at a particular output
     * stream (e.g. a file, or std::cout) */
    CodeGen_CoreIR_Base(std::ostream &dest, OutputKind output_kind = CPlusPlusImplementation,
                     const std::string &include_guard = "")
        : CodeGen_C(dest, output_kind, include_guard) {}

    struct Stencil_Type {
        typedef enum {Stencil, Stream, AxiStream} StencilContainerType;
        StencilContainerType type;
        Type elemType;  // type of the element
        Region bounds;  // extent of each dimension
        int depth;      // FIFO depth if it is a Stream type
    };

    std::ostringstream require_global_ostream;
    std::ostringstream submethod_ostream;

protected:
    Scope<Stencil_Type> stencils;  // scope of stencils and streams of stencils

    virtual std::string print_stencil_type(Stencil_Type s);
    virtual std::string print_name(const std::string &name);
    virtual std::string print_stencil_pragma(const std::string &name);

    using CodeGen_C::visit;

    void visit(const Call *);
    void visit(const Provide *);
    void visit(const Realize *);

	void visit_binop(Type t, Expr a, Expr b, char op_sym, std::string coreir_name, std::string op_name);
	void visit(const Mul *op);
	void visit(const Add *op);
	void visit(const Sub *op);
	void visit(const Cast *op);


    // for coreir generation
    bool create_json = false;
    uint8_t bitwidth;
    CoreIR::Context* context;
    CoreIR::Namespace* global_ns;
    CoreIR::Namespace* stdlib;
    std::map<std::string,CoreIR::Module*> gens;
    CoreIR::ModuleDef* def;
    CoreIR::Module* design;
    CoreIR::Wireable* self;

    // keep track of coreir dag
    int input_idx = 0; // tracks how many inputs have been defined so far
    std::map<std::string,CoreIR::Wireable*> hw_wire_set;
    std::unordered_set<std::string> hw_inout_set;

    // coreir methods to wire things together
    virtual bool id_hw_input(const Expr e);
    bool id_cnst(const Expr e);
    int id_cnst_value(const Expr e);
    string id_hw_section(Expr a, Expr b, Type t, char op_symbol, string a_name, string b_name);
    CoreIR::Wireable* get_wire(Expr e, std::string name);

};

}
}

#endif
