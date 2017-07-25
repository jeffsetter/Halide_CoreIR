#ifndef HALIDE_CODEGEN_COREIR_TESTBENCH_H
#define HALIDE_CODEGEN_COREIR_TESTBENCH_H

/** \file
 *
 * Defines the code-generator for producing HLS testbench code
 */
#include <sstream>

#include "CodeGen_CoreIR_Base.h"
#include "CodeGen_CoreIR_Target.h"
#include "Module.h"
#include "Scope.h"

#include "coreir.h"

namespace Halide {

namespace Internal {

/** A code generator that emits Xilinx Vivado HLS compatible C++ testbench code.
 */
class CodeGen_CoreIR_Testbench : public CodeGen_CoreIR_Base {
public:
    CodeGen_CoreIR_Testbench(std::ostream &tb_stream);
    ~CodeGen_CoreIR_Testbench();

protected:
    using CodeGen_CoreIR_Base::visit;

    void visit(const ProducerConsumer *);
    void visit(const Call *);
    void visit(const Realize *);
    void visit(const Block *);

//     void visit(const Store *);
//     bool id_hw_input(const Expr e);
//     void visit_binop(Type t, Expr a, Expr b, char op_sym, std::string coreir_name, std::string op_name);
//     void visit(const Mul *);
//     void visit(const Add *);
//     void visit(const Sub *);


private:
    CodeGen_CoreIR_Target cg_target;


};

}
}

#endif
