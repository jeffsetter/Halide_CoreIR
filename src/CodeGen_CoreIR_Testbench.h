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

#include "context.hpp"

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
    void visit(const Mul *);
    void visit(const Store *);
private:
    CodeGen_CoreIR_Target cg_target;

    // for coreir generation
    uint8_t n;
    Context* c;
    Namespace* g;
    Namespace* stdlib;
    std::map<std::string,Generator*> gens;
    ModuleDef* def;
    Wireable* self;

    std::set<std::string> hw_input_set;
    bool id_hw_section(Expr a, Expr b, Type t, char op_symbol);

};

}
}

#endif
