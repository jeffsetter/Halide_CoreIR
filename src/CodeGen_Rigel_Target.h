#ifndef HALIDE_CODEGEN_RIGEL_TARGET_H
#define HALIDE_CODEGEN_RIGEL_TARGET_H

/** \file
 *
 * Defines an IRPrinter that emits HLS C++ code.
 */

#include "CodeGen_Rigel_Base.h"
#include "Module.h"
#include "Scope.h"

namespace Halide {

namespace Internal {

struct Rigel_Argument {
    std::string name;

    bool is_stencil;

    Type scalar_type;

    CodeGen_Rigel_Base::Stencil_Type stencil_type;
};

/** This class emits Xilinx Vivado HLS compatible C++ code.
 */
class CodeGen_Rigel_Target {
public:
    /** Initialize a C code generator pointing at a particular output
     * stream (e.g. a file, or std::cout) */
    CodeGen_Rigel_Target(const std::string &name);
    virtual ~CodeGen_Rigel_Target();

    void init_module();

    void add_kernel(Stmt stmt,
                    const std::string &name,
                    const std::vector<Rigel_Argument> &args);

    void dump();

protected:
    class CodeGen_Rigel_C : public CodeGen_Rigel_Base {
    public:
        CodeGen_Rigel_C(std::ostream &s, OutputKind output_kind) : CodeGen_Rigel_Base(s, output_kind) {}

        void add_kernel(Stmt stmt,
                        const std::string &name,
                        const std::vector<Rigel_Argument> &args);
    protected:
        std::string print_stencil_pragma(const std::string &name);

        using CodeGen_Rigel_Base::visit;

        void visit(const For *op);
        void visit(const Allocate *op);
    };

    /** A name for the Rigel target */
    std::string target_name;

    /** String streams for building header and source files. */
    // @{
    std::ostringstream hdr_stream;
    std::ostringstream src_stream;
    // @}

    /** Code generators for Rigel target header and the source. */
    // @{
    CodeGen_Rigel_C hdrc;
    CodeGen_Rigel_C srcc;
    // @}
};

}
}

#endif
