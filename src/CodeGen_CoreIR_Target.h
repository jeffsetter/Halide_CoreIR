#ifndef HALIDE_CODEGEN_COREIR_TARGET_H
#define HALIDE_CODEGEN_COREIR_TARGET_H

/** \file
 *
 * Defines an IRPrinter that emits HLS C++ code.
 */

#include "CodeGen_CoreIR_Base.h"
#include "Module.h"
#include "Scope.h"

#include "coreir.h"

namespace Halide {

namespace Internal {

struct CoreIR_Argument {
    std::string name;

    bool is_stencil;

    Type scalar_type;

    CodeGen_CoreIR_Base::Stencil_Type stencil_type;
};

/** This class emits Xilinx Vivado HLS compatible C++ code.
 */
class CodeGen_CoreIR_Target {
public:
    /** Initialize a C code generator pointing at a particular output
     * stream (e.g. a file, or std::cout) */
    CodeGen_CoreIR_Target(const std::string &name);
    virtual ~CodeGen_CoreIR_Target();

    void init_module();

    void add_kernel(Stmt stmt,
                    const std::string &name,
                    const std::vector<CoreIR_Argument> &args);

    void dump();

protected:
    class CodeGen_CoreIR_C : public CodeGen_CoreIR_Base {
    public:
  CodeGen_CoreIR_C(std::ostream &s, OutputKind output_kind);
  ~CodeGen_CoreIR_C();

        void add_kernel(Stmt stmt,
                        const std::string &name,
                        const std::vector<CoreIR_Argument> &args);
    protected:
        std::string print_stencil_pragma(const std::string &name);

        using CodeGen_CoreIR_Base::visit;

        void visit(const For *op);
        void visit(const Allocate *op);

	void visit(const Mul *op);
	void visit(const Add *op);
	void visit(const Sub *op);
	//	void visit(const Load *op);
	void visit(const Store *op);
	void visit(const Call *op);

	bool id_hw_input(const Expr e);
	bool id_cnst(const Expr e);
	int id_cnst_value(const Expr e);
	void visit_binop(Type t, Expr a, Expr b, char op_sym, std::string coreir_name, std::string op_name);
	std::map<std::string,CoreIR::Wireable*> hw_input_set;
	std::string id_hw_section(Expr a, Expr b, Type t, char op_symbol, std::string a_name, std::string b_name);
	CoreIR::Wireable* get_wire(Expr e, std::string name);

    };

    /** A name for the CoreIR target */
    std::string target_name;

    /** String streams for building header and source files. */
    // @{
    std::ostringstream hdr_stream;
    std::ostringstream src_stream;
    // @}

    /** Code generators for CoreIR target header and the source. */
    // @{
    CodeGen_CoreIR_C hdrc;
    CodeGen_CoreIR_C srcc;
    // @}    


};

}
}

#endif
