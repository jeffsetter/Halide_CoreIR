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
      bool is_output;

      Type scalar_type;

      CodeGen_CoreIR_Base::Stencil_Type stencil_type;
    };

    struct CoreIR_Inst_Args {
      std::string ref_name = "";
      std::string name;
      std::string gen;
      CoreIR::Values args;
      CoreIR::Values genargs;
      std::string wirename;
      std::string selname;

    CoreIR_Inst_Args(std::string name, std::string wirename, std::string selname,
                     std::string gen, CoreIR::Values args, CoreIR::Values genargs) :
      name(name), gen(gen), args(args), genargs(genargs), wirename(wirename), selname(selname) {}

    };

    struct Storage_Def {
      CoreIR::Type* ptype;
      CoreIR::Wireable* wire;
      CoreIR::Wireable* reg = NULL;
      bool was_written = false;
      bool was_read = false;

    Storage_Def(CoreIR::Type* ptype, CoreIR::Wireable* wire) :
      ptype(ptype), wire(wire) {}

      bool is_reg() {return (reg != NULL); };
    };

    typedef std::map<std::string,int> VarValues;

/** This class emits Xilinx Vivado HLS compatible C++ code.
 */
    class CodeGen_CoreIR_Target {
      public:
      /** Initialize a C code generator pointing at a particular output
       * stream (e.g. a file, or std::cout) */
      CodeGen_CoreIR_Target(const std::string &name, bool has_valid);
      virtual ~CodeGen_CoreIR_Target();

      void init_module();

      void add_kernel(Stmt stmt,
                      const std::string &name,
                      const std::vector<CoreIR_Argument> &args);

      void dump();

      protected:
      class CodeGen_CoreIR_C : public CodeGen_CoreIR_Base {
        public:
        CodeGen_CoreIR_C(std::ostream &s, OutputKind output_kind, bool has_valid);
        ~CodeGen_CoreIR_C();

        void add_kernel(Stmt stmt,
                        const std::string &name,
                        const std::vector<CoreIR_Argument> &args);
        protected:
        std::string print_stencil_pragma(const std::string &name);

        using CodeGen_CoreIR_Base::visit;

        // for coreir generation
        bool create_json = false;
        bool has_valid = false;
        uint8_t bitwidth;
        CoreIR::Context* context = NULL;
        CoreIR::Namespace* global_ns = NULL;
        std::map<std::string,std::string> gens;
        CoreIR::ModuleDef* def = NULL;
        CoreIR::Module* design = NULL;
        CoreIR::Wireable* self = NULL;
        const IfThenElse* predicate  = NULL;

        // keep track of coreir dag
        std::map<std::string,CoreIR::Wireable*> hw_wire_set;
        std::map<std::string,std::shared_ptr<Storage_Def>> hw_store_set;
        std::map<std::string,std::shared_ptr<CoreIR_Inst_Args>> hw_def_set;
        std::map<std::string,CoreIR::Wireable*> hw_input_set;
        std::unordered_set<std::string> hw_output_set;

        // keep track for valid network
				std::map<std::string, std::vector<std::string> > hw_dispatch_set;
        std::map<std::string, CoreIR::Wireable*> lb_valid_map;
        void record_dispatch(std::string producer_name, std::string consumer_name);
        void record_linebuffer_valid(std::string producer_name, CoreIR::Wireable* wire);
        bool connect_linebuffer(std::string consumer_name, CoreIR::Wireable* consumer_wen_wire);

        // coreir methods to wire things together
        bool is_const(const Expr e);
        bool is_input(std::string var_name);
        bool is_output(std::string var_name);
        bool is_defined(std::string var_name);
        bool is_wire(std::string var_name);
        bool is_storage(std::string var_name);

        int id_const_value(const Expr e);
        CoreIR::Wireable* get_wire(std::string name, Expr e, std::vector<uint> indices={});
        void rename_wire(std::string new_name, std::string in_name, Expr in_expr, std::vector<uint> indices={});
        void add_wire(std::string name, CoreIR::Wireable* wire, std::vector<uint> indices={});

        // coreir operators
        void visit_unaryop(Type t, Expr a, const char* op_sym, std::string op_name);
        void visit(const Not *op);
        void visit_binop(Type t, Expr a, Expr b, const char* op_sym, std::string op_name);
        void visit(const Mul *op);
        void visit(const Div *op);
        void visit(const Mod *op);
        void visit(const Add *op);
        void visit(const Sub *op);
        void visit(const And *op);
        void visit(const Or *op);
        void visit(const EQ *op);
        void visit(const NE *op);
        void visit(const LT *op);
        void visit(const LE *op);
        void visit(const GT *op);
        void visit(const GE *op);
        void visit(const Max *op);
        void visit(const Min *op);
        void visit(const Cast *op);
        void visit_ternop(Type t, Expr a, Expr b, Expr c, const char*  op_sym1, const char* op_sym2, std::string op_name);
        void visit(const Select *op);

        void visit(const For *op); // create counter
        void visit(const Realize *op); // create passthrough for indirection
        void visit(const Allocate *op);
        void visit(const Call *op); // bitwise, streams, etc
        void visit(const Provide *op);
        void visit(const Load *op); // variable load -> mux
        void visit(const Store *op);
        void visit(const IfThenElse *op); // wire up enable,reset for conditional


        // analysis functions of Halide IR
        std::vector<const Variable*> find_dep_vars(Expr e);
        std::vector<int> eval_expr_with_vars(Expr e, std::vector<VarValues> pts);

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
