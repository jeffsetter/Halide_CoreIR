#ifndef HALIDE_CODEGEN_RIGEL_TESTBENCH_H
#define HALIDE_CODEGEN_RIGEL_TESTBENCH_H

/** \file
 *
 * Defines the code-generator for producing HLS testbench code
 */
#include <sstream>

#include "CodeGen_Rigel_Base.h"
#include "CodeGen_Rigel_Target.h"
#include "Module.h"
#include "Scope.h"

namespace Halide {

namespace Internal {

/** A code generator that emits Xilinx Vivado HLS compatible C++ testbench code.
 */
class CodeGen_Rigel_Testbench : public CodeGen_Rigel_Base {
public:
    CodeGen_Rigel_Testbench(std::ostream &tb_stream);
    ~CodeGen_Rigel_Testbench();

protected:
    using CodeGen_Rigel_Base::visit;

    void visit(const ProducerConsumer *);
    void visit(const Call *);
    void visit(const Realize *);
    void visit(const Block *);

private:
    CodeGen_Rigel_Target cg_target;
};

}
}

#endif
