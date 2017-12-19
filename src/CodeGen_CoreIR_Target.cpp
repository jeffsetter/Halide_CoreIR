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
#include "coreir/libs/commonlib.h"

namespace Halide {
namespace Internal {

using std::ostream;
using std::endl;
using std::string;
using std::vector;
using std::ostringstream;
using std::ofstream;
using std::cout;

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

    // add all generators from coreirprims
    context->getNamespace("coreir");
    std::vector<string> corelib_gen_names = {"mul", "add", "sub", 
                                             "and", "or", "xor",
                                             "eq", "neq",
                                             "ult", "ugt", "ule", "uge",
                                             "slt", "sgt", "sle", "sge", 
                                             "shl", "ashr",
                                             "mux", "const", "wire"};

    for (auto gen_name : corelib_gen_names) {
      gens[gen_name] = "coreir." + gen_name;
      assert(context->hasGenerator(gens[gen_name]));
    }

    // add all modules from corebit
    context->getNamespace("corebit");
    std::vector<string> corebitlib_mod_names = {"bitand", "bitor", "bitxor", "bitnot",
                                                "bitmux", "bitconst"};
    for (auto mod_name : corebitlib_mod_names) {
      gens[mod_name] = "corebit." + mod_name.substr(3);
      assert(context->hasModule(gens[mod_name]));
    }

    // add all generators from commonlib
    CoreIRLoadLibrary_commonlib(context);
    std::vector<string> commonlib_gen_names = {"umin", "smin", "umax", "smax",
                                               "Linebuffer", "Linebuffer_3d", "counter",
                                               "muxn", "absd", "reg_array"}; // neq
    for (auto gen_name : commonlib_gen_names) {
      gens[gen_name] = "commonlib." + gen_name;
      assert(context->hasGenerator(gens[gen_name]));
    }

    gens["passthrough"] = "mantle.wire";
    assert(context->hasGenerator(gens["passthrough"]));

    // add all generators from cgralib
//     CoreIR::Namespace* cgralib = CoreIRLoadLibrary_cgralib(context);
//     std::vector<string> cgralib_gen_names = {};
//     for (auto gen_name : cgralib_gen_names) {
//       gens[gen_name] = cgralib->getGenerator(gen_name);
//       assert(gens[gen_name]);
//     }
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
  if (def != NULL && def->hasInstances()) {
    // check the completed coreir design
    design->setDef(def);
    context->checkerrors();
    design->print();
    
    //bool err = false;
    std::string GREEN = "\033[0;32m";
    std::string RED = "\033[0;31m";
    std::string RESET = "\033[0m";
    
    //cout << "Running Passes: generators and flattening" << endl;    
    //context->runPasses({"rungenerators","flatten"});
    cout << "Saving to json" << endl;
    if (!saveToFile(global_ns, "design_prepass.json", design)) {
      cout << RED << "Could not save to json!!" << RESET << endl;
      context->die();
    }
    context->runPasses({"rungenerators", "removepassthroughs"});
    //FIXME: we should have everything connected
    //    context->runPasses({"rungenerators","removepassthroughs","verifyconnectivity-onlyinputs-noclkrst"});

    //design->print();
    //context->runPasses({"flattentypes"});
    //design->print();
    //context->runPasses({"flatten","verifyfullyconnected-noclkrst"});
    //design->print();

    cout << "Validating json" << endl;
    design->getDef()->validate();

  
    // write out the json
    cout << "Saving json and dot" << endl;
    if (!saveToFile(global_ns, "design_top.json", design)) {
      cout << RED << "Could not save to json!!" << RESET << endl;
      context->die();
    }
//    if (!saveToDot(design, "design_top.txt")) {
//      cout << RED << "Could not save to dot file :(" << RESET << endl;
//      context->die();
//    }
  
    CoreIR::Module* m = nullptr;
    cout << "Loading json" << endl;
    if (!loadFromFile(context, "design_top.json", &m)) {
      cout << RED << "Could not load from json!!" << RESET << endl;
      context->die();
    }
    if (!saveToDot(m, "design_top.txt")) {
      cout << RED << "Could not save to dot file :(" << RESET << endl;
      context->die();
    }

    ASSERT(m, "Could not load top: design");
    //m->print();

    cout << GREEN << "Created CoreIR design!!!" << RESET << endl;
    
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

uint num_bits(uint N) {
  if (N==0) { return 1; }

  uint num_shifts = 0;
  uint temp_value = N;
  while (temp_value > 0) {
    temp_value  = temp_value >> 1;
    num_shifts++;
  }
  return num_shifts;
}


void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::add_kernel(Stmt stmt,
                                                   const string &name,
                                                   const vector<CoreIR_Argument> &args) {

    // Emit the function prototype
    uint num_inouts = 0;
    //std::unordered_map<string,CoreIR::Type*> input_types;
    //CoreIR::RecordType input_types = CoreIR::RecordType(context, CoreIR::RecordParams({{"reset", context->BitIn()}}));
    std::vector<std::pair<string, CoreIR::Type*>> input_types;
    CoreIR::Type* output_type = context->Bit();
    //CodeGen_CoreIR_Base::Stencil_Type stype_first; // keeps track of the first stencil (output)
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

	    //if (args[i].stencil_type.type == Stencil_Type::StencilContainerType::AxiStream) {
              vector<uint> indices;
              for(const auto &range : stype.bounds) {
                assert(is_const(range.extent));
                indices.push_back(id_const_value(range.extent));
              }


              if (args[i].is_output) {
                //cout << "output: " << arg_name << " added with type " << CodeGen_C::print_type(stype.elemType) << " and bitwidth " << stype.elemType.bits() << endl;
                //stream << "\n// output: " << arg_name << " added with type " << CodeGen_C::print_type(stype.elemType) << " and bitwidth " << stype.elemType.bits() << endl;
                uint out_bitwidth = stype.elemType.bits() > 1 ? bitwidth : 1;
                if (out_bitwidth > 1) { output_type = output_type->Arr(out_bitwidth); }
                for (uint i=0; i<indices.size(); ++i) {
                  output_type = output_type->Arr(indices[i]);
                }

                hw_output_set.insert(arg_name);
              } else {
                //cout << "input: " << arg_name << " added with type " << CodeGen_C::print_type(stype.elemType) << " and bitwidth " << stype.elemType.bits() << endl;
                //stream << "\n// input: " << arg_name << " added with type " << CodeGen_C::print_type(stype.elemType) << " and bitwidth " << stype.elemType.bits() << endl;

                uint in_bitwidth = stype.elemType.bits() > 1 ? bitwidth : 1;
                CoreIR::Type* input_type = context->BitIn()->Arr(in_bitwidth);
                for (uint i=0; i<indices.size(); ++i) {
                  input_type = input_type->Arr(indices[i]);
                }
                //input_types.appendField(arg_name, input_type);
                input_types.push_back({arg_name, input_type});
                //cout << "  and its type is " << input_type->toString() << endl;

                hw_input_set.insert(arg_name);
              }

              num_inouts++;

              //        }
        } else {
            stream << print_type(args[i].scalar_type) << " " << arg_name;
            uint in_bitwidth = args[i].scalar_type.bits() > 1 ? bitwidth : 1;
            CoreIR::Type* input_type = context->BitIn()->Arr(in_bitwidth);
            input_types.push_back({arg_name, input_type});
            hw_input_set.insert(arg_name);
        }

        if (i < args.size()-1) stream << ",\n";
    }

    // Emit prototype to coreir
    create_json = (num_inouts > 0);

    //cout << "design has " << num_inputs << " inputs with bitwidth " << to_string(bitwidth) << " " <<endl;
    // FIXME: can't distinguish bw output/input easily (assuming single output first)

    CoreIR::Type* design_type = context->Record({
	{"in", context->Record(input_types)},
        {"out", output_type}
    });
    design = global_ns->newModuleDecl("DesignTop", design_type);
    def = design->newModuleDef();
    self = def->sel("self");

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

                // add alias to coreir
                if (is_input(arg_name)) {
                  rename_wire(print_name(args[i].name), arg_name, Expr());
                  //hw_input_set.insert(print_name(args[i].name));
                }
                if (is_output(arg_name) ) {
                  hw_output_set.insert(print_name(args[i].name));
                }                
		
            } else {
                stream << print_type(args[i].scalar_type) << " &"
                       << print_name(args[i].name) << " = " << arg_name << ";\n";
                
                // configurable taps are generated as constant registers
                string const_name = print_name(args[i].name);
                string tap_name = "tap" + const_name;
                int const_bitwidth = args[i].scalar_type.bits();
                int const_value = 0;
                CoreIR::Wireable* const_inst;

                if (const_bitwidth == 1) {
                  //cout << "bitwidth 1 args are not supported yet" << endl;
                  CoreIR::Values mod_args = {{"value",CoreIR::Const::make(context,(bool)const_value)}};
                  //CoreIR_Inst_Args tap_args(const_name, arg_name, "out", gens["bitconst"], gen_args, CoreIR::Values());
                  const_inst = def->addInstance(tap_name, gens["bitconst"], mod_args);
                } else {
                  CoreIR::Values gen_args = {{"width", CoreIR::Const::make(context,bitwidth)}};
                  CoreIR::Values mod_args = {{"value",CoreIR::Const::make(context,BitVector(bitwidth,const_value))}};
                  //CoreIR_Inst_Args tap_args(const_name, arg_name, "out", gens["const"], gen_args, mod_params);
                  const_inst = def->addInstance(tap_name, gens["const"], gen_args, mod_args);
                }
                const_inst->getMetaData()["tap"] = "This constant is expected to be changed as a tap value.";
                add_wire(const_name, const_inst->sel("out"));
          
            }


        }
	stream << "\n// hw_input_set contains: ";
	for (const std::string& x : hw_input_set) {
	  stream << " " << x;
	}
        stream << "\n";
	stream << "\n// hw_output_set contains: ";
	for (const std::string& x : hw_output_set) {
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

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Provide *op) {
    if (ends_with(op->name, ".stencil") ||
        ends_with(op->name, ".stencil_update")) {
        // IR: buffered.stencil_update(1, 2, 3) =
        // C: buffered_stencil_update(1, 2, 3) =
        vector<string> args_indices(op->args.size());
        vector<uint> indices;
        for(size_t i = 0; i < op->args.size(); i++) {
          args_indices[i] = print_expr(op->args[i]);
          internal_assert(is_const(op->args[i])) << "variable store used. FIXME: Demux not yet implemented\n";
          indices.push_back(id_const_value(op->args[i]));
          stream << id_const_value(op->args[i]) << " ";
        }

        internal_assert(op->values.size() == 1);
        string id_value = print_expr(op->values[0]);

        do_indent();

	stream << "[provide]" << " ";
        stream << print_name(op->name) << "(";
	string new_name = print_name(op->name);

        for(size_t i = 0; i < op->args.size(); i++) {
            stream << args_indices[i];
            if (i != op->args.size() - 1)
              {stream << ", "; }
        }
        stream << ") = " << id_value << ";\n";
        //cout << "doing a provide\n ";
        // FIXME: can we avoid clearing the cache? just ones where the end matches (for regs used multiple times)?
        cache.clear();
        
	// generate coreir: add to wire_set
        if (predicate) {
          // produce a register for accumulation
          stream << "// provide with a predicate\n";
          // FIXME: support value that is not constant
          //internal_assert(is_const(op->values[0])) << "FIXME: Only constant inits are suppported";
          int const_value;
          if (is_const(op->values[0])) {
            const_value = id_const_value(op->values[0]);
          } else {
            const_value = 0;
            stream << "// " << id_value << " is not a constant. Not yet supported for provides." << endl;
            cout << id_value << " is not a constant. Not yet supported for provides." << endl;
          }
          internal_assert(const_value == 0) << "FIXME: we only supported arrays init at 0\n";

          // hook up reset
          // FIXME: shouldn't print out again
          string cond_id = print_expr(predicate->condition);
          auto pt_struct = hw_store_set[new_name];
          if (is_storage(new_name) && !pt_struct->is_reg()) {
            // add reg_array
            CoreIR::Type* ptype = pt_struct->ptype;
            string regs_name = "regs" + new_name;
            //FIXME: clr or rst?
            CoreIR::Wireable* regs = def->addInstance(regs_name, gens["reg_array"], {{"type",CoreIR::Const::make(context,ptype)}, {"has_clr", CoreIR::Const::make(context,true)}});
            pt_struct->reg = regs;
          }
          internal_assert(is_storage(new_name) && hw_store_set[new_name]->is_reg());
          auto reg_struct = hw_store_set[new_name];
          def->connect(get_wire(cond_id, predicate->condition), reg_struct->reg->sel("clr"));

          stream << "// reg rst added to: " << new_name << endl;
        } else {
          string in_name = id_value;
          CoreIR::Wireable* wire = get_wire(in_name, op->values[0]);
          //cout << "where " << new_name << " = " << in_name << " with " << indices.size() << " indices" << endl;
          add_wire(new_name, wire, indices);
        }

    } else {
        CodeGen_CoreIR_Base::visit(op);
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
        stream << "#pragma CoreIR PIPELINE II=1\n";
    }

    // generate coreir: add counter module
    internal_assert(is_const(op->min));
    internal_assert(is_const(op->extent));
    int min_value = id_const_value(op->min);
    int max_value = min_value + id_const_value(op->extent);
    int inc_value = 1;
    string counter_name = "count_" + print_name(op->name);
    /*
    CoreIR::Wireable* counter_inst = def->addInstance(counter_name, gens["counter"], 
                                                      {{"width",CoreIR::Const::make(context,bitwidth)},
                                                          {"min",CoreIR::Const::make(context,min_value)},
                                                            {"max",CoreIR::Const::make(context,max_value)},
                                                              {"inc",CoreIR::Const::make(context,inc_value)}}
                                                      );
    hw_wire_set[print_name(op->name)] = counter_inst->sel("out");
    */
    string wirename = print_name(op->name);
    string selname = "out";
    CoreIR::Values args = {{"width",CoreIR::Const::make(context,bitwidth)},
                         {"min",CoreIR::Const::make(context,min_value)},
                         {"max",CoreIR::Const::make(context,max_value)},
                         {"inc",CoreIR::Const::make(context,inc_value)}};
    CoreIR_Inst_Args counter_args(counter_name, wirename, selname, gens["counter"], args, CoreIR::Values()
                                  );
    hw_def_set[print_name(op->name)] = std::make_shared<CoreIR_Inst_Args>(counter_args);
    //cout << "// counter created with name " << print_name(op->name) << endl;
    stream << "// counter created with name " << print_name(op->name) << endl;


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
    string alloc_name = print_name(op->name + unique_name('a'));
    /*
    if (allocations.contains(alloc_name)) {
      return;
    } 
    stream << "// couldn't find allocation " << alloc_name << endl;*/
    Stmt new_body = RenameAllocation(op->name, alloc_name).mutate(op->body);

    Allocation alloc;
    alloc.type = op->type;
    allocations.push(alloc_name, alloc);

    do_indent();
    stream << print_type(op->type) << ' '
           << print_name(alloc_name)
           << "[" << constant_size << "]; [alloc]\n";

  //  CoreIR::Type* type_input = context->Bit()->Arr(bitwidth)->Arr(constant_size);
  //  CoreIR::Wireable* wire_array = def->addInstance("array", gens["passthrough"], {{"type", CoreIR::Const::make(context,type_input)}});
  //  hw_wire_set[print_name(alloc_name)] = wire_array;

    // add a 'ARRAY_PARTITION" pragma
    //stream << "#pragma CoreIR ARRAY_PARTITION variable=" << print_name(op->name) << " complete dim=0\n\n";

    new_body.accept(this);

    // Should have been freed internally
    internal_assert(!allocations.contains(alloc_name))
        << "allocation " << alloc_name << " is not freed.\n";
    stream << "// ending this allocation" << endl;
    allocations.push(alloc_name, alloc);

    //close_scope("alloc " + print_name(op->name));

}


void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Call *op) {
  // add bitand, bitor, bitxor, bitnot
    if (op->is_intrinsic(Call::bitwise_and)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        if (op->type.bits() == 1) {
          // use a special op for bitwidth 1
          visit_binop(op->type, a, b, "&&", "bitand");
        } else {
          visit_binop(op->type, a, b, "&", "and");
        }
    } else if (op->is_intrinsic(Call::bitwise_or)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        if (op->type.bits() == 1) {
          // use a special op for bitwidth 1
          visit_binop(op->type, a, b, "||", "bitor");
        } else {
          visit_binop(op->type, a, b, "|", "or");
        }
    } else if (op->is_intrinsic(Call::bitwise_xor)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        if (op->type.bits() == 1) {
          // use a special op for bitwidth 1
          visit_binop(op->type, a, b, "^", "bitxor");
        } else {
          visit_binop(op->type, a, b, "^", "xor");
        }
    } else if (op->is_intrinsic(Call::bitwise_not)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        if (op->type.bits() == 1) {
          // use a special op for bitwidth 1
          visit_binop(op->type, a, b, "!", "bitnot");
        } else {
          visit_binop(op->type, a, b, "~", "not");
        }

    } else if (op->is_intrinsic(Call::shift_left)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        stream << "[shift left] ";
        visit_binop(op->type, a, b, "<<", "shl");
    } else if (op->is_intrinsic(Call::shift_right)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        stream << "[shift right] ";
        visit_binop(op->type, a, b, ">>", "ashr");
    } else if (op->is_intrinsic(Call::absd)) {
        internal_assert(op->args.size() == 2);
        Expr a = op->args[0];
        Expr b = op->args[1];
        stream << "[absd] ";
        visit_binop(op->type, a, b, "|-|", "absd");

    } else if (op->is_intrinsic(Call::reinterpret)) {
        string in_var = print_expr(op->args[0]);
        print_reinterpret(op->type, op->args[0]);

        stream << "// reinterpreting " << op->args[0] << " as " << in_var << endl;

        // generate coreir: expecting to find the expr is a constant
        rename_wire(in_var, in_var, op->args[0]);

    } else if (op->is_intrinsic(Call::address_of)) {
      user_warning << "ignoring address_of\n";
      stream       << "ignoring address_of" << endl;

    } else if (op->name == "linebuffer") {
        //IR: linebuffer(buffered.stencil_update.stream, buffered.stencil.stream, extent_0[, extent_1, ...])
        //C: linebuffer<extent_0[, extent_1, ...]>(buffered.stencil_update.stream, buffered.stencil.stream)
        internal_assert(op->args.size() >= 3);
        string a0 = print_expr(op->args[0]);
        string a1 = print_expr(op->args[1]);
	const Variable *stencil_var = op->args[1].as<Variable>();
	Stencil_Type stencil_type = stencils.get(stencil_var->name);

        do_indent();
        stream << "linebuffer<";
        for(size_t i = 2; i < op->args.size(); i++) {
            stream << print_expr(op->args[i]);
            if (i != op->args.size() -1)
                stream << ", ";
        }
        stream << ">(" << a0 << ", " << a1 << ");\n";
        id = "0"; // skip evaluation
	
	// generate coreir: wire up to linebuffer
	string lb_in_name = print_name(a0);
	string lb_out_name = print_name(a1);

	// add linebuffer to coreir
        uint num_dims = op->args.size() - 2;
        uint lb_dims [num_dims];
        for (uint i=0; i<num_dims; ++i) {
          lb_dims[i] = id_const_value(stencil_type.bounds[i].extent);
        }

	string lb_name = "lb" + lb_in_name;

        CoreIR::Wireable* coreir_lb = NULL;

        if (num_dims == 2) {
          int stencil_width = lb_dims[0];
          int stencil_height = lb_dims[1];
          int image_width = id_const_value(op->args[2]);
          int fifo_depth = image_width;
          internal_assert(fifo_depth > 0);
          
          stream << "// stencil size: " << stencil_width << " " << stencil_height << " and image width " << image_width << std::endl
                 << "//  using fifo_depth " << fifo_depth << std::endl;

          CoreIR::Values lb_args = {{"bitwidth",CoreIR::Const::make(context,bitwidth)}, 
                          {"stencil_width", CoreIR::Const::make(context,stencil_width)},
                          {"stencil_height", CoreIR::Const::make(context,stencil_height)},
                          {"image_width", CoreIR::Const::make(context,fifo_depth)}};
          coreir_lb = def->addInstance(lb_name, gens["Linebuffer"], lb_args);
        } else if (num_dims == 3) {
          //cout << "created a 3d linebuffer!" << endl;
          int stencil_depth = lb_dims[0];
          int stencil_width = lb_dims[1];
          int stencil_height = lb_dims[2];
          int image_depth = id_const_value(op->args[2]);
          int image_width = id_const_value(op->args[3]);
          internal_assert(image_width > 0);
          internal_assert(image_depth > 0);

          
          stream << "// stencil size: " << stencil_depth << " " << stencil_width << " " << stencil_height
                 << " and image size " << image_depth << "x" << image_width << std::endl;
          //cout << "// stencil size: " << stencil_depth << " " << stencil_width << " " << stencil_height
          //<< " and image size " << image_depth << "x" << image_width << std::endl;

          CoreIR::Values lb3_args = {{"bitwidth",CoreIR::Const::make(context,bitwidth)},
                           {"stencil_d0", CoreIR::Const::make(context,stencil_depth)},
                           {"stencil_d1", CoreIR::Const::make(context,stencil_width)},
                           {"stencil_d2", CoreIR::Const::make(context,stencil_height)},
                           {"image_d0", CoreIR::Const::make(context,image_depth)}, 
                           {"image_d1", CoreIR::Const::make(context,image_width)}};

          coreir_lb = def->addInstance(lb_name, gens["Linebuffer_3d"], lb3_args);

        }

          /*
	int stencil_width = id_const_value(lb_dim0);
	int stencil_height = id_const_value(lb_dim1);
	int image_width = id_const_value(op->args[2]);
        int fifo_depth = image_width;
        internal_assert(fifo_depth > 0);

	stream << "// stencil size: " << stencil_width << " " << stencil_height << " and image width " << image_width << std::endl
               << "//  using fifo_depth " << fifo_depth << std::endl;
        
	CoreIR::Wireable* coreir_lb = def->addInstance(lb_name, gens["Linebuffer"],
  			         {{"bitwidth",CoreIR::Const::make(context,bitwidth)}, {"stencil_width", CoreIR::Const::make(context,stencil_width)},
				  {"stencil_height", CoreIR::Const::make(context,stencil_height)}, {"image_width", CoreIR::Const::make(context,fifo_depth)}}
						       );
          */

        // connect linebuffer
        //CoreIR::Module* bc_gen = static_cast<CoreIR::Module*>(gens["bitconst"]);
        CoreIR::Wireable* lb_wen = def->addInstance(lb_name+"_wen", gens["bitconst"], {{"value",CoreIR::Const::make(context,true)}});
        CoreIR::Wireable* lb_in_wire = get_wire(lb_in_name, op->args[0]);
        for (uint i=0; i<num_dims; ++i) {
          // FIXME: assumes a single element for linebuffer input
          /*
          CoreIR::Type* wire_type = lb_in_wire->getType();
          uint array_len = wire_type->getKind() == CoreIR::Type::TypeKind::TK_Array ?
            static_cast<CoreIR::ArrayType*>(wire_type)->getLen() : 0;
          internal_assert(array_len == 1) << "FIXME: we don't support multi-precision linebuffer inputs yet (" << array_len << ")\n";
          */
          lb_in_wire = lb_in_wire->sel(0);

        }

	def->connect(lb_in_wire, coreir_lb->sel("in"));
	add_wire(lb_out_name, coreir_lb->sel("out"));
        def->connect(lb_wen->sel("out"), coreir_lb->sel("wen"));
	//hw_wire_set[lb_out_name] = coreir_lb->sel("out");


    } else if (op->name == "write_stream") {
        string printed_stream_name;
	string input_name;
        if (op->args.size() == 2) {
            // normal case
            // IR: write_stream(buffered.stencil_update.stream, buffered.stencil_update)
            // C: buffered_stencil_update_stream.write(buffered_stencil_update);
            string a0 = print_expr(op->args[0]);
            string a1 = print_expr(op->args[1]);
            do_indent();

            stream << a0 << ".write(" << a1 << ");\n";
            id = "0"; // skip evaluation 
	    printed_stream_name = a0;
	    input_name = a1;
        } else {
            // write stream call for the dag output kernel
            // IR: write_stream(output.stencil.stream, output.stencil, loop_var_1, loop_max_1, ...)
            // C:  AxiPackedStencil<uint8_t, 1, 1, 1> _output_stencil_packed = _output_stencil;
            //     if (_loop_var_1 == loop_max_1 && ...)
            //       _output_stencil_packed.last = 1;
            //     else
            //       _output_stencil_packed.last = 0;
            //     _output_stencil_stream.write(_output_stencil_packed);
            internal_assert(op->args.size() > 2 && op->args.size() % 2 == 0);
            const Variable *stream_var = op->args[0].as<Variable>();
            const Variable *stencil_var = op->args[1].as<Variable>();
            internal_assert(stream_var && stencil_var);
            string stream_name = stream_var->name;
            string stencil_name = stencil_var->name;
            string packed_stencil_name = stencil_name + "_packed";

            internal_assert(stencils.contains(stencil_name));
            Stencil_Type stencil_type = stencils.get(stencil_name);
            internal_assert(stencil_type.type == Stencil_Type::StencilContainerType::Stencil);

            // emit code declaring the packed stencil
            do_indent();
            stream << "AxiPacked" << print_stencil_type(stencil_type) << " "
                   << print_name(packed_stencil_name) << " = "
                   << print_name(stencil_name) << ";\n";

            // emit code asserting TLAST
            vector<string> loop_vars, loop_maxes;
            for (size_t i = 2; i < op->args.size(); i += 2) {
                loop_vars.push_back(print_expr(op->args[i]));
                loop_maxes.push_back(print_expr(op->args[i+1]));
            }
            do_indent();
            stream << "if (";
            for (size_t i = 0; i < loop_vars.size(); i++) {
                stream << loop_vars[i] << " == " << loop_maxes[i];
                if (i < loop_vars.size() - 1)
                    stream << " && ";
            }
            stream << ") {\n";
            do_indent();
            stream << ' ' << print_name(packed_stencil_name) << ".last = 1;\n";
            do_indent();
            stream << "} else {\n";
            do_indent();
            stream << ' ' << print_name(packed_stencil_name) << ".last = 0;\n";
            do_indent();
            stream << "}\n";

            // emit code writing stream
            do_indent();
            stream << print_name(stream_name) << ".write("
                   << print_name(packed_stencil_name) << ");\n";
            id = "0"; // skip evaluation
	    printed_stream_name = print_name(stream_name);
	    input_name = print_name(stencil_name);
        }

	// generate coreir: wire with indices maybe
        if (predicate) {
          // FIXME: implement predicate
          stream << "// writing stream with a predicate\n";
        }

        rename_wire(printed_stream_name, input_name, op->args[1]);

    } else if (op->name == "read_stream") {
        internal_assert(op->args.size() == 2 || op->args.size() == 3);
        string a1 = print_expr(op->args[1]);

        const Variable *stream_name_var = op->args[0].as<Variable>();
        internal_assert(stream_name_var);
        string stream_name = stream_name_var->name;
        if (op->args.size() == 3) {
            // stream name is maggled with the consumer name
            const StringImm *consumer_imm = op->args[2].as<StringImm>();
            internal_assert(consumer_imm);
            stream_name += ".to." + consumer_imm->value;
        }
        do_indent();
        stream << a1 << " = " << print_name(stream_name) << ".read();\n";
        id = "0"; // skip evaluation

	// generate coreir: add as coreir input
	string stream_print_name = print_name(stream_name);
        rename_wire(a1, stream_print_name, op->args[0]);

        if (predicate) {
          stream << "// reading stream with a predicate\n";
          // hook up the enable
          CoreIR::Wireable* stencil_wire = get_wire(stream_print_name, op->args[0]);
          CoreIR::Wireable* lb_wire = stencil_wire->getTopParent();
          // FIXME: assert that this is a linebuffer
          // FIXME: shouldn't print out again
          string cond_id = print_expr(predicate->condition);
          def->disconnect(lb_wire->sel("wen"));
          def->connect(lb_wire->sel("wen"), get_wire(cond_id, predicate->condition));
        }

    } else if (ends_with(op->name, ".stencil") ||
               ends_with(op->name, ".stencil_update")) {
        ostringstream rhs;
        // IR: out.stencil_update(0, 0, 0)
        // C: out_stencil_update(0, 0, 0)
        vector<string> args_indices(op->args.size());
        vector<uint> stencil_indices;
        bool constant_indices = true;
        for(size_t i = 0; i < op->args.size(); i++) {
            args_indices[i] = print_expr(op->args[i]);
            constant_indices = constant_indices && is_const(op->args[i]);
            if (constant_indices) {
              stencil_indices.push_back(id_const_value(op->args[i]));
            }
        }

        rhs << print_name(op->name) << "(";
	string stencil_print_name = print_name(op->name);
        for(size_t i = 0; i < op->args.size(); i++) {
            rhs << args_indices[i];
	    //stencil_print_name += "_" + args_indices[i];
            if (i != op->args.size() - 1)
                rhs << ", ";
        }
        rhs << ")";
	rhs << "[stencil]";

        string out_var = print_assignment(op->type, rhs.str());
        if (is_wire(out_var)) { return; }

	// generate coreir

        if (constant_indices) {// && (is_wire(stencil_print_name) || is_defined(stencil_print_name))) {
	  //cout << "// added to set: " << out_var << " using stencil+idx\n";
          rename_wire(out_var, stencil_print_name, op, stencil_indices);
	  stream << "// added to set: " << out_var << " using stencil+idx\n";

	} else if (is_wire(stencil_print_name) || is_defined(stencil_print_name) || is_storage(stencil_print_name)) {
          stream << "// trying to hook up " << print_name(op->name) << endl;
          //cout << "trying to hook up " << print_name(op->name) << endl;
          /*
        if (hw_wire_set.count(stencil_print_name)) {
	  hw_wire_set[out_var] = hw_wire_set[stencil_print_name];
	  stream << "// added to wire_set: " << out_var << " using stencil+idx\n";
	} else if (hw_wire_set.count(print_name(op->name)) > 0) {
          //stream << "// trying to hook up " << print_name(op->name) << endl;
          */

	  //CoreIR::Wireable* stencil_wire = hw_wire_set[print_name(op->name)]; // one example wire
          CoreIR::Wireable* stencil_wire = get_wire(print_name(op->name), op);
          CoreIR::Wireable* orig_stencil_wire = stencil_wire;
          vector<std::pair<CoreIR::Wireable*, CoreIR::Wireable*>> stencil_mux_pairs;

          CoreIR::Type* ptype;
          if (op->type.bits() == 1) {
            ptype = context->Bit();
          } else {
            ptype = context->Bit()->Arr(bitwidth);
          }

          string pt_name = unique_name("pt" + out_var);
          stream << "// created passthrough with name " << pt_name << endl;

          CoreIR::Wireable* pt = def->addInstance(pt_name, gens["passthrough"], {{"type",CoreIR::Const::make(context,ptype)}});
          stencil_mux_pairs.push_back(std::make_pair(stencil_wire, pt->sel("in")));

          // for every dim in the stencil, keep track of correct index and create muxes
          for (size_t i = op->args.size(); i-- > 0 ;) { // count down from args-1 to 0
            vector<std::pair<CoreIR::Wireable*, CoreIR::Wireable*>> new_pairs;
            
            CoreIR::Type* wire_type = stencil_wire->getType();
            uint array_len = wire_type->getKind() == CoreIR::Type::TypeKind::TK_Array ?
              //FIXME: CoreIR::isa<CoreIR::ArrayType>(wire_type) ? 
              static_cast<CoreIR::ArrayType*>(wire_type)->getLen() : 0;
            // cast<ArrayType>

            // OR_ : dyn_cast<ArrayType>

            if (is_const(op->args[i])) {
              // constant index

              //uint index = stoi(args_indices[i]);
              uint index = id_const_value(op->args[i]);
              //cout << "type is " << wire_type->getKind() << " and has length " << static_cast<CoreIR::ArrayType*>(wire_type)->getLen() << endl;

              if (index < array_len) {
                stream << "// using constant index " << std::to_string(index) << endl;
                stencil_wire = stencil_wire->sel(index);

                // keep track of corresponding stencil and mux inputs
                for (auto sm_pair : stencil_mux_pairs) {
                  CoreIR::Wireable* stencil_i = sm_pair.first;
                  CoreIR::Wireable* mux_i = sm_pair.second;
                  new_pairs.push_back(std::make_pair(stencil_i->sel(index), mux_i));
                }
                stencil_mux_pairs = new_pairs;

              } else {
                stream << "// couldn't find selectStr " << std::to_string(index) << endl;
                //cout << "couldn't find selectStr " << to_string(index) << endl;
                
                stencil_mux_pairs.clear();
                stencil_mux_pairs.push_back(std::make_pair(orig_stencil_wire, pt->sel("in")));
                break;
              }

            } else {
              // non-constant, variable index
              // create muxes 
              uint num_muxes = stencil_mux_pairs.size();
              //cout << "  variable index creating " << num_muxes << " mux(es)" << endl;

              stream << "// variable index creating " << num_muxes << " mux(es)" << endl;

              // create mux for every input from previous layer
              for (uint j = 0; j < num_muxes; j++) {
                CoreIR::Wireable* stencil_i = stencil_mux_pairs[j].first;
                CoreIR::Wireable* mux_i = stencil_mux_pairs[j].second;

                string mux_name = unique_name(print_name(op->name) + std::to_string(i) + 
                                              "_mux" + std::to_string(array_len) + "_" + std::to_string(j));

                CoreIR::Values sliceArgs = {{"width", CoreIR::Const::make(context,bitwidth)},
                                            {"lo", CoreIR::Const::make(context,0)},
                                            {"hi", CoreIR::Const::make(context,num_bits(array_len-1))}};
                CoreIR::Wireable* slice_inst = def->addInstance("selslice" + mux_name, "coreir.slice", sliceArgs); 


                CoreIR::Wireable* mux_inst = def->addInstance(mux_name, gens["muxn"], 
                                                              {{"width",CoreIR::Const::make(context,bitwidth)},{"N",CoreIR::Const::make(context,array_len)}});
                
                def->connect(mux_inst->sel("out"), mux_i);
                stream << "// created mux called " << mux_name << endl;

                // wire up select
                def->connect(get_wire(args_indices[i], op->args[i]), slice_inst->sel("in"));
                def->connect(slice_inst->sel("out"), mux_inst->sel("in")->sel("sel"));

                // add each corresponding stencil and mux input to list
                for (uint mux_i = 0; mux_i < array_len; ++mux_i) {
                  CoreIR::Wireable* stencil_new = stencil_i->sel(mux_i);
                  CoreIR::Wireable* mux_new = mux_inst->sel("in")->sel("data")->sel(mux_i);
                  new_pairs.push_back(std::make_pair(stencil_new, mux_new));
                } // for every mux input
              } // for every mux
              
              //cout << "all muxes created" << endl;
              stencil_wire = stencil_wire->sel(0);
              stencil_mux_pairs = new_pairs;
            }
          } // for every dimension in stencil

          // connect the passthrough output
          add_wire(out_var, pt->sel("out"));
          
          // wire up stencil to generated muxes
          for (auto sm_pair : stencil_mux_pairs) {
            CoreIR::Wireable* stencil_i = sm_pair.first;
            CoreIR::Wireable* mux_i = sm_pair.second;
            def->connect(stencil_i, mux_i);
          }


	  stream << "// added to wire_set: " << out_var << " using stencil\n";
	  //cout << "// added to wire_set: " << out_var << " using stencil\n";
	} else {
          stream       << "// " << stencil_print_name << " not found so it's not going to work" << endl;
          user_warning << "// " << stencil_print_name << " not found so it's not going to work\n";
	}

        
    } else if (op->name == "dispatch_stream") {
        // emits the calling arguments in comment
        vector<string> args(op->args.size());
        for(size_t i = 0; i < op->args.size(); i++)
            args[i] = print_expr(op->args[i]);

        do_indent();
        stream << "// dispatch_stream(";
        for(size_t i = 0; i < args.size(); i++) {
            stream << args[i];

            if (i != args.size() - 1)
                stream << ", ";
        }
        stream << ");\n";
        // syntax:
        //   dispatch_stream(stream_name, num_of_dimensions,
        //                   stencil_size_dim_0, stencil_step_dim_0, store_extent_dim_0,
        //                   [stencil_size_dim_1, stencil_step_dim_1, store_extent_dim_1, ...]
        //                   num_of_consumers,
        //                   consumer_0_name, fifo_0_depth,
        //                   consumer_0_offset_dim_0, consumer_0_extent_dim_0,
        //                   [consumer_0_offset_dim_1, consumer_0_extent_dim_1, ...]
        //                   [consumer_1_name, ...])

        // recover the structed data from op->args
        internal_assert(op->args.size() >= 2);
        const Variable *stream_name_var = op->args[0].as<Variable>();
        internal_assert(stream_name_var);
        string stream_name = stream_name_var->name;
        size_t num_of_demensions = *as_const_int(op->args[1]);
        vector<int> stencil_sizes(num_of_demensions);
        vector<int> stencil_steps(num_of_demensions);
        vector<int> store_extents(num_of_demensions);

        internal_assert(op->args.size() >= num_of_demensions*3 + 2);
        for (size_t i = 0; i < num_of_demensions; i++) {
            stencil_sizes[i] = *as_const_int(op->args[i*3 + 2]);
            stencil_steps[i] = *as_const_int(op->args[i*3 + 3]);
            store_extents[i] = *as_const_int(op->args[i*3 + 4]);
        }

        internal_assert(op->args.size() >= num_of_demensions*3 + 3);
        size_t num_of_consumers = *as_const_int(op->args[num_of_demensions*3 + 2]);
        vector<string> consumer_names(num_of_consumers);
        vector<int> consumer_fifo_depth(num_of_consumers);
        vector<vector<int> > consumer_offsets(num_of_consumers);
        vector<vector<int> > consumer_extents(num_of_consumers);

        internal_assert(op->args.size() >= num_of_demensions*3 + 3 + num_of_consumers*(2 + 2*num_of_demensions));
        for (size_t i = 0; i < num_of_consumers; i++) {
            const StringImm *string_imm = op->args[num_of_demensions*3 + 3 + (2 + 2*num_of_demensions)*i].as<StringImm>();
            internal_assert(string_imm);
            consumer_names[i] = string_imm->value;
            const IntImm *int_imm = op->args[num_of_demensions*3 + 4 + (2 + 2*num_of_demensions)*i].as<IntImm>();
            internal_assert(int_imm);
            consumer_fifo_depth[i] = int_imm->value;
            vector<int> offsets(num_of_demensions);
            vector<int > extents(num_of_demensions);
            for (size_t j = 0; j < num_of_demensions; j++) {
                offsets[j] = *as_const_int(op->args[num_of_demensions*3 + 5 + (2 + 2*num_of_demensions)*i + 2*j]);
                extents[j] = *as_const_int(op->args[num_of_demensions*3 + 6 + (2 + 2*num_of_demensions)*i + 2*j]);
            }
            consumer_offsets[i] = offsets;
            consumer_extents[i] = extents;
        }

        // emits declarations of streams for each consumer
        internal_assert(stencils.contains(stream_name));
        Stencil_Type stream_type = stencils.get(stream_name);

        // Optimization. if there is only one consumer and its fifo depth is zero
        // , use C++ reference for the consumer stream
        if (num_of_consumers == 1 && consumer_fifo_depth[0] == 0) {
            string consumer_stream_name = stream_name + ".to." + consumer_names[0];
            do_indent();
            stream << print_stencil_type(stream_type) << " &"
                   << print_name(consumer_stream_name) << " = "
                   << print_name(stream_name) << ";\n";
            id = "0"; // skip evaluation

	    // generate coreir: update coreir structure
	    string stream_in_name = print_name(stream_name);
	    string stream_out_name = print_name(consumer_stream_name);
            rename_wire(stream_out_name, stream_in_name, op->args[0]);
            return;
        }

        for (size_t i = 0; i < num_of_consumers; i++) {
            string consumer_stream_name = stream_name + ".to." + consumer_names[i];
            Stencil_Type consumer_stream_type = stream_type;
            consumer_stream_type.depth = std::max(consumer_fifo_depth[i], 1); // HLS tool doesn't support zero-depth FIFO yet
            do_indent();
            stream << print_stencil_type(consumer_stream_type) << ' '
                   << print_name(consumer_stream_name) << ";\n";
            // pragma
            stencils.push(consumer_stream_name, consumer_stream_type);
            stream << print_stencil_pragma(consumer_stream_name);
            stencils.pop(consumer_stream_name);
        }

        // emits for a loop for each dimensions (larger dimension number, outer the loop)
        for (int i = num_of_demensions - 1; i >= 0; i--) {
            string dim_name = "_dim_" + std::to_string(i);
            do_indent();
            // HLS C: for(int dim = 0; dim <= store_extent - stencil.size; dim += stencil.step)
            stream << "for (int " << dim_name <<" = 0; "
                   << dim_name << " <= " << store_extents[i] - stencil_sizes[i] << "; "
                   << dim_name << " += " << stencil_steps[i] << ")\n";

            // generate coreir: counter
            /*
            internal_assert(is_const(op->min));
            internal_assert(is_const(op->extent));
            int min_value = id_const_value(op->min);
            int max_value = min_value + id_const_value(op->extent);
            int inc_value = 1;
            string counter_name = "count_" + print_name(op->name);
            CoreIR::Wireable* counter_inst = def->addInstance(counter_name, gens["counter"], 
                                                              {{"width",CoreIR::Const::make(context,bitwidth)},
                                                                  {"min",CoreIR::Const::make(context,min_value)},
                                                                    {"max",CoreIR::Const::make(context,max_value)},
                                                                      {"inc",CoreIR::Const::make(context,inc_value)}}
                                                              );
            hw_wire_set[print_name(op->name)] = counter_inst->sel("out");
            cout << "counter added with name " << print_name(op->name) << endl;
            */
        }


        open_scope();
        // pragma
        stream << "#pragma HLS PIPELINE\n";
        // read stencil from stream
        Stencil_Type stencil_type = stream_type;
        stencil_type.type = Stencil_Type::StencilContainerType::Stencil;
        string stencil_name = "tmp_stencil";
        do_indent();
        stream << "Packed" << print_stencil_type(stencil_type) << ' '
               << print_name(stencil_name) << " = "
               << print_name(stream_name) << ".read();\n";

        // dispatch the stencil to each consumer stream
        for (size_t i = 0; i < num_of_consumers; i++) {
            string consumer_stream_name = stream_name + ".to." + consumer_names[i];
            // emits the predicate for dispatching stencils
            // HLS C: if(dim_0 >= consumer_offset_0 && dim_0 <= consumer_offset_0 + consumer_extent_0 - stencil_size_0
            //           [&& dim_1 >= consumer_offset_1 && dim_1 <= consumer_offset_1 + consumer_extent_1 - stencil_size_1...])
            do_indent();
            stream << "if (";
            for (size_t j = 0; j < num_of_demensions; j++) {
                string dim_name = "_dim_" + std::to_string(j);
                stream << dim_name << " >= " << consumer_offsets[i][j] << " && "
                       << dim_name << " <= " << consumer_offsets[i][j] + consumer_extents[i][j] - stencil_sizes[j];
                if (j != num_of_demensions - 1)
                    stream << " && ";
            }
            stream << ")\n";

            // emits the write call in the if body
            open_scope();
            do_indent();
            stream << print_name(consumer_stream_name) << ".write("
                   << print_name(stencil_name) << ");\n";
            close_scope("");

            // generate coreir
            string stencil_print_name = print_name(stream_name);
            string out_var = print_name(consumer_stream_name);
            rename_wire(out_var, stencil_print_name, op->args[0]);
        }

        close_scope("");
        id = "0"; // skip evaluation

    } else {
      stream << "couldn't find " << op->name << endl;
      CodeGen_CoreIR_Base::visit(op);
    }
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Realize *op) {
    if (ends_with(op->name, ".stream")) {

        // create a stream type
        internal_assert(op->types.size() == 1);
        allocations.push(op->name, {op->types[0], "null"});
        Stencil_Type stream_type({Stencil_Type::StencilContainerType::Stream,
                    op->types[0], op->bounds, 1});
        stencils.push(op->name, stream_type);

        // emits the declaration for the stream
        do_indent();
        stream << "[realize stream] ";
        stream << print_stencil_type(stream_type) << ' ' << print_name(op->name) << ";\n";
        stream << print_stencil_pragma(op->name);

        // generate coreir: add passthrough
        vector<uint> indices;
        for(const auto &range : stream_type.bounds) {
          assert(is_const(range.extent));
          indices.push_back(id_const_value(range.extent));
        }

        CoreIR::Type* ptype;
        if (stream_type.elemType.bits() == 1) {
          ptype = context->Bit();
        } else {
          ptype = context->Bit()->Arr(bitwidth);
        }

        for (uint i=0; i<indices.size(); ++i) {
          ptype = ptype->Arr(indices[i]);
        }
        if (indices.size() > 4) {
          internal_error << "provide stencil is too large=" << indices.size()
                         << ". Sizes up to 4 are supported.\n";
        }

        stream << "// created a passthrough for " << print_name(op->name) << endl;
        string pt_name = unique_name("pt" + print_name(op->name));

        CoreIR::Wireable* pt = def->addInstance(pt_name, gens["passthrough"], {{"type",CoreIR::Const::make(context,ptype)}});
        hw_store_set[print_name(op->name)] = std::make_shared<Storage_Def>(Storage_Def(ptype, pt));
        stream << "created storage called " << op->name << endl;
        //cout << "created storage called " << op->name << endl;

        // traverse down
        op->body.accept(this);

        // We didn't generate free stmt inside for stream type
        allocations.pop(op->name);
        stencils.pop(op->name);

    } else if (ends_with(op->name, ".stencil") ||
               ends_with(op->name, ".stencil_update")) {
        // create a stencil type
        internal_assert(op->types.size() == 1);
        allocations.push(op->name, {op->types[0], "null"});
        Stencil_Type stype({Stencil_Type::StencilContainerType::Stencil, op->types[0], op->bounds, 1});
        stencils.push(op->name, stype);

        do_indent();
        stream << "[realize stencil] ";
        // Stencil<uint16_t, 1, 1, 1> conv1_stencil_update;
        stream << print_stencil_type(stype) << ' ' << print_name(op->name) << ";\n";
        stream << print_stencil_pragma(op->name);

        // generate coreir: add passthrough
        vector<uint> indices;
        for(const auto &range : stype.bounds) {
          internal_assert(is_const(range.extent));
          indices.push_back(id_const_value(range.extent));
        }

        CoreIR::Type* ptype;
        if (stype.elemType.bits() == 1) {
          ptype = context->Bit();
        } else {
          ptype = context->Bit()->Arr(bitwidth);
        }

        for (uint i=0; i<indices.size(); ++i) {
          ptype = ptype->Arr(indices[i]);
        }
        if (indices.size() > 4) {
          internal_error << "provide stencil is too large=" << indices.size()
                         << ". Sizes up to 4 are supported.\n";
        }

        stream << "// created a passthrough for " << print_name(op->name) << endl;
        string pt_name = unique_name("pt" + print_name(op->name));

        CoreIR::Wireable* pt = def->addInstance(pt_name, gens["passthrough"], {{"type",CoreIR::Const::make(context,ptype)}});
        hw_store_set[print_name(op->name)] = std::make_shared<Storage_Def>(Storage_Def(ptype, pt));
        stream << "created storage called " << print_name(op->name) << endl;
        //cout << "created storage called " << print_name(op->name) << endl;
        
        op->body.accept(this);

        // We didn't generate free stmt inside for stream type
        allocations.pop(op->name);
        stencils.pop(op->name);
    } else {
        CodeGen_C::visit(op);
    }
}


bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::is_const(const Expr e) {
  if (e.as<IntImm>() || e.as<UIntImm>()) {
    return true;
  } else {
    return false;
  }
}

int CodeGen_CoreIR_Target::CodeGen_CoreIR_C::id_const_value(const Expr e) {
  if (const IntImm* e_int = e.as<IntImm>()) {
    return e_int->value;

  } else if (const UIntImm* e_uint = e.as<UIntImm>()) {
    return e_uint->value;

  } else {
    //internal_error << "invalid constant expr\n";
    return -1;
  }
}

int get_const_bitwidth(const Expr e) {
  if (const IntImm* e_int = e.as<IntImm>()) {
    return e_int->type.bits();

  } else if (const UIntImm* e_uint = e.as<UIntImm>()) {
    return e_uint->type.bits();

  } else {
    internal_error << "invalid constant expr\n";
    return -1;
  }
}

bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::is_wire(string var_name) {
  bool wire_exists = hw_wire_set.count(var_name) > 0;
  return wire_exists;
}

bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::is_input(string var_name) {
  bool input_exists = hw_input_set.count(var_name) > 0;
  return input_exists;
}

bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::is_storage(string var_name) {
  bool storage_exists = hw_store_set.count(var_name) > 0;
  return storage_exists;
}

bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::is_defined(string var_name) {
  bool hardware_defined = hw_def_set.count(var_name) > 0;
  for (auto ele : hw_def_set) {
    assert(ele.second);
    //    cout << ele.first << ", ";
  }
  //  cout << endl;
  //cout << "result of search for " << var_name << ": " << hardware_defined << endl;

  return hardware_defined;
}

bool CodeGen_CoreIR_Target::CodeGen_CoreIR_C::is_output(string var_name) {
  bool output_name_matches = hw_output_set.count(var_name) > 0;
  return output_name_matches;
}


  // This function is used when the output is going to be connected to a useable wire
  CoreIR::Wireable* CodeGen_CoreIR_Target::CodeGen_CoreIR_C::get_wire(string name, Expr e, std::vector<uint> indices) {
  if (is_const(e)) {
    int const_value = id_const_value(e);
    string const_name = unique_name("const" + std::to_string(const_value) + "_" + name);
    CoreIR::Wireable* const_inst;

    uint const_bitwidth = get_const_bitwidth(e);
    if (const_bitwidth == 1) {
      const_inst = def->addInstance(const_name, gens["bitconst"], {{"value",CoreIR::Const::make(context,(bool)const_value)}});
    } else {
      const_inst = def->addInstance(const_name, gens["const"], {{"width", CoreIR::Const::make(context,bitwidth)}},
                              {{"value",CoreIR::Const::make(context,BitVector(bitwidth,const_value))}});
    }

    stream << "// created const: " << const_name << " with name " << name << "\n";
    return const_inst->sel("out");

  } else if (is_input(name)) {
    //cout << "trying to get input " << name << " from " << self->sel("in")->getType()->toString() << endl;
    CoreIR::Wireable* input_wire = self->sel("in")->sel(name);
    internal_assert(input_wire);
    stream << "// " << name << " added as input " << name << endl;
    //cout << "// " << name << " added as input " << name << endl;
    return input_wire;

  } else if (is_storage(name)) {
    auto pt_struct = hw_store_set[name];
    CoreIR::Wireable* current_wire;
    if (!pt_struct->was_written) {
      internal_assert(pt_struct->is_reg());
      current_wire = pt_struct->reg->sel("out");
    } else {
      current_wire = pt_struct->wire->sel("out");
    }

    for (int i=indices.size()-1; i >= 0; --i) {
      //cout << "selecting storage in get_wire" << endl;
      current_wire = current_wire->sel(indices[i]);
    }
    pt_struct->was_read = true;
    //cout << "finished with get_wire" << endl;
    return current_wire;

  } else if (is_wire(name)) {
    //internal_assert(indices.empty()) << "wire named " << name << " was accessed with indices\n";
    //cout << "creating a wire named " << name << endl;

    CoreIR::Wireable* wire = hw_wire_set[name];
    if (wire==NULL) { 
      user_warning << "wire was not defined: " << name << "\n";
      stream       << "// wire was not defined: " << name << endl;
      return self->sel("in"); 
    }
    CoreIR::Wireable* current_wire = wire;
    for (int i=indices.size()-1; i >= 0; --i) {
      //cout << i << endl;
      //cout << "selecting wire index " << indices[i] << " for wire " << name << " in get_wire" << endl;
      current_wire = current_wire->sel(indices[i]);
    }
    //cout << "finished with get_wire" << endl;

    return current_wire;

  } else if (is_defined(name)) {
    // hardware element defined, but not added yet
    std::shared_ptr<CoreIR_Inst_Args> inst_args = hw_def_set[name];
    assert(inst_args);
    stream << "// creating element called: " << name << endl;
    //cout << "named " << inst_args->gen <<endl;
    CoreIR::Wireable* inst = def->addInstance(unique_name(inst_args->name), inst_args->gen, inst_args->args, inst_args->genargs);
    add_wire(name, inst->sel(inst_args->selname));


    auto ref_name = inst_args->ref_name;
    string prev_name = name;
    return inst->sel(inst_args->selname);

  } else {
    user_warning << "ERROR- invalid wire: " << name << "\n"; 
    stream << "// invalid wire: couldn't find " << name
           << "\n// hw_wire_set contains: ";
    for (auto x : hw_wire_set) {
      stream << " " << x.first;
    }
    stream << "\n";

    return self->sel("in");
  }
}

  void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::add_wire(string out_name, CoreIR::Wireable* in_wire, vector<uint> out_indices) {
    if (is_storage(out_name)) {
      auto pt_struct = hw_store_set[out_name];

      if (!pt_struct->was_read && !pt_struct->was_written && out_indices.empty() && !pt_struct->is_reg()) {
        // this passthrough hasn't been used, so remove it
        auto pt_wire = hw_store_set[out_name]->wire;
        internal_assert(CoreIR::Instance::classof(pt_wire));
        CoreIR::Instance* pt_inst = &(cast<CoreIR::Instance>(*pt_wire));
        def->removeInstance(pt_inst);
        hw_store_set.erase(out_name);
        
        hw_wire_set[out_name] = in_wire;

      } else {
        // use the found passthrough
        if (pt_struct->was_written && pt_struct->was_read) {
          // create a new passthrough, since this one is already connected
          string pt_name = unique_name("pt" + out_name);
          CoreIR::Type* ptype = pt_struct->ptype;
          stream << "// created passthrough with name " << pt_name << endl;

          CoreIR::Wireable* pt = def->addInstance(pt_name, gens["passthrough"], {{"type",CoreIR::Const::make(context,ptype)}});
          // FIXME: copy over all stores (since wire might not encompass entire passthrough)
          pt_struct->wire = pt;
        
          pt_struct->was_read = false;
        }

        // disconnect associated wire in reg, and connect new wire
        if (pt_struct->is_reg()) {
          stream << "// disconnecting wire for reg " << out_name << endl;
          CoreIR::Wireable* d_wire = pt_struct->reg->sel("in");
          for (int i=out_indices.size()-1; i >= 0; --i) {
            //cout << "selecting in reg add_wire: " << out_indices[i] << endl;
            d_wire = d_wire->sel(out_indices[i]);
          }
          //cout << "select in add_wire done" << endl;
          def->disconnect(d_wire);
          def->connect(in_wire, d_wire);
        }

        pt_struct->was_written = true;
        stream << "// added passthrough wire to " << out_name << endl;
        //cout << "// added passthrough wire to " << out_name << endl;

        // connect wire to passthrough
        CoreIR::Wireable* current_wire = pt_struct->wire->sel("in");
        for (int i=out_indices.size()-1; i >= 0; --i) {
          //cout << "selecting in add_wire: " << out_indices[i] << endl;
          current_wire = current_wire->sel(out_indices[i]);
        }
        def->connect(in_wire, current_wire);

      }
      
    } else {
      internal_assert(out_indices.empty());
      // wire is being stored for use as an input
      hw_wire_set[out_name] = in_wire;
    }
  }

  void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::rename_wire(string new_name, string in_name, Expr in_expr, vector<uint> indices) {
  // if this is a definition, then just copy the pointer
    //cout << "trying to add/modify: " << new_name << " = " << in_name << "\n";
  if (is_defined(in_name) && !is_wire(in_name)) { 
    assert(indices.empty());
    // wire is only defined but not created yet

    hw_def_set[new_name] = hw_def_set[in_name];
    hw_def_set[new_name]->ref_name = in_name;

    assert(hw_def_set[new_name]);
    stream << "// added/modified in hw_def_set: " << new_name << " = " << in_name << "\n";
    stream << "//   for a module called: " << hw_def_set[new_name]->name << endl;
    //cout << "// added/modified in hw_def_set: " << new_name << " = " << in_name << "\n";
    return;
  } else if (is_const(in_expr)) {
    assert(indices.empty());
    // add hardware definition, but don't create it yet
    int const_value = id_const_value(in_expr);
    string const_name = "const" + std::to_string(const_value) + "_" + in_name;
    string gen_const;
    CoreIR::Values args, genargs;
 
    uint const_bitwidth = get_const_bitwidth(in_expr);
    if (const_bitwidth == 1) {
      gen_const = "coreir.bitconst";
      args = {{"value",CoreIR::Const::make(context,const_value)}};
      genargs = CoreIR::Values();
    } else {
      gen_const = "coreir.const";
      args = {{"width", CoreIR::Const::make(context,bitwidth)}};
      genargs = {{"value",CoreIR::Const::make(context,BitVector(bitwidth,const_value))}};
    }
  
    CoreIR_Inst_Args const_args(const_name, in_name, "out", gen_const, args, genargs);
    hw_def_set[new_name] = std::make_shared<CoreIR_Inst_Args>(const_args);
 
    stream << "// defined const: " << const_name << " with name " << new_name << "\n";
    //cout << "// defined const: " << const_name << " with name " << new_name << "\n";
    return;
  } else if (is_storage(in_name)) {
    // if this is simply another reference (no indexing), just add a new name
    if (indices.empty()) {

      if (is_storage(new_name)) {
        stream << "// removing another passthrough: " << new_name << " = " << in_name << endl;
        //def->connect(hw_store_set[in_name]->wire->sel("out"), hw_store_set[new_name]->wire->sel("in"));

        auto pt_wire = hw_store_set[new_name]->wire;
        internal_assert(CoreIR::Instance::classof(pt_wire));
        CoreIR::Instance* pt_inst = &(cast<CoreIR::Instance>(*pt_wire));
        def->removeInstance(pt_inst);
        hw_store_set[new_name] = hw_store_set[in_name];
        

        hw_store_set[in_name]->was_read = true;
      } else {
        stream << "// creating another passthrough reference: " << new_name << " = " << in_name << endl;
        hw_store_set[new_name] = hw_store_set[in_name];
      }

      if (is_output(new_name)) {
        def->connect(hw_store_set[new_name]->wire->sel("out"), self->sel("out"));
        stream << "// connecting passthrough to output " << new_name << endl;
      }
      return;
    } 
  }

  // the wire is defined, so store the pointer with its new name
  CoreIR::Wireable* temp_wire = get_wire(in_name, in_expr, indices);
  if (indices.size() > 0) {
    stream << "//   connecting with " << indices.size() << " indices: ";
  }
  for (auto index : indices) {
    stream << index << " ";
  }
  stream << endl;

  CoreIR::Wireable* in_wire = temp_wire;

  if (in_wire!=NULL && is_output(new_name)) {
    internal_assert(indices.empty()) << "output had indices selected\n";
    stream << "// " << new_name << " added as an output from " << in_name << "\n";
    def->connect(in_wire, self->sel("out"));

  } else if (in_wire) {
    //cout << "added wire" << endl;
    add_wire(new_name, in_wire);
    stream << "// added/modified in wire_set: " << new_name << " = " << in_name << "\n";

  } else {
    //cout << "not found" << endl;
    stream << "// " << in_name << " not found (prob going to fail)\n";
  }
}
  
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit_unaryop(Type t, Expr a, const char*  op_sym, string op_name) {
  string a_name = print_expr(a);
  string print_sym = op_sym;

  string out_var = print_assignment(t, print_sym + "(" + a_name + ")");
  // return if this variable is cached
  if (is_wire(out_var)) { return; }

  CoreIR::Wireable* a_wire = get_wire(a_name, a);
  if (a_wire != NULL) {
    string unaryop_name = op_name + a_name;
    CoreIR::Wireable* coreir_inst;

    // properly cast to generator or module
    if (context->hasGenerator(gens[op_name])) {
      internal_assert(context->getGenerator(gens[op_name]));    
      uint inst_bitwidth = a.type().bits() == 1 ? 1 : bitwidth;
      coreir_inst = def->addInstance(unaryop_name, gens[op_name], {{"width", CoreIR::Const::make(context,inst_bitwidth)}});
    } else {
      internal_assert(context->getModule(gens[op_name]));
      coreir_inst = def->addInstance(unaryop_name, gens[op_name]);
    }

    def->connect(a_wire, coreir_inst->sel("in"));
    add_wire(out_var, coreir_inst->sel("out"));
  } else {
    out_var = "";
    print_assignment(t, print_sym + "(" + a_name + ")");
    if (a_wire == NULL) { stream << "// input 'a' was invalid!!" << endl; }
    //    stream << "tb-performed a << op_name<< :!!! " <<endl;//<< print_type(a.type()) << " " << print_type(b.type()) << endl;
  }

  if (is_input(a_name)) { stream << "// " << op_name <<"a: self.in "; } else { stream << "// " << op_name << "a: " << a_name << " "; }
  stream << "o: " << out_var << " with bitwidth:" << t.bits() << endl;
}


void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit_binop(Type t, Expr a, Expr b, const char*  op_sym, string op_name) {
  string a_name = print_expr(a);
  string b_name = print_expr(b);
  string out_var = print_assignment(t, a_name + " " + op_sym + " " + b_name);
  //cout << out_var << " is the output for unit " << op_name << a_name << b_name << endl;
  // return if this variable is cached
  if (is_wire(out_var)) { return; }

  CoreIR::Wireable* a_wire = get_wire(a_name, a);
  CoreIR::Wireable* b_wire = get_wire(b_name, b);

  if (a_wire != NULL && b_wire != NULL) {
    internal_assert(a.type().bits() == b.type().bits()) << "function " << op_name << " with " << a_name << " and " << b_name;
    uint inst_bitwidth = a.type().bits() == 1 ? 1 : bitwidth;
    string binop_name = op_name + a_name + b_name + out_var;
    CoreIR::Wireable* coreir_inst;

    // properly cast to generator or module
    //context->runPasses({"printer"},{"global","coreir"});

    //cout << "creating a hardware binop: " << op_name << endl;
    if (context->hasGenerator(gens[op_name])) {
      coreir_inst = def->addInstance(binop_name, gens[op_name], {{"width", CoreIR::Const::make(context,inst_bitwidth)}});
    } else {
      coreir_inst = def->addInstance(binop_name, gens[op_name]);
    }

    def->connect(a_wire, coreir_inst->sel("in0"));
    def->connect(b_wire, coreir_inst->sel("in1"));
    add_wire(out_var, coreir_inst->sel("out"));

  } else {
    out_var = "";
    if (a_wire == NULL) { stream << "// input 'a' was invalid!!" << endl; }
    if (b_wire == NULL) { stream << "// input 'b' was invalid!!" << endl; }

    //    stream << "tb-performed a << op_name<< :!!! " <<endl;//<< print_type(a.type()) << " " << print_type(b.type()) << endl;
  }

  if (is_input(a_name)) { stream << "// " << op_name <<"a: self.in "; } else { stream << "// " << op_name << "a: " << a_name << " "; }
  if (is_input(b_name)) { stream << "// " << op_name <<"b: self.in "; } else { stream << "// " << op_name << "b: " << b_name << " "; }
  stream << "o: " << out_var << " with obitwidth:" << t.bits() << endl;//<< " and ibitwidth " << a.type.bits() << endl;
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit_ternop(Type t, Expr a, Expr b, Expr c, const char*  op_sym1, const char* op_sym2, string op_name) {
  string a_name = print_expr(a);
  string b_name = print_expr(b);
  string c_name = print_expr(c);

  string out_var = print_assignment(t, a_name + " " + op_sym1 + " " + b_name + " " + op_sym2 + " " + c_name);
  // return if this variable is cached
  if (is_wire(out_var)) { return; }

  CoreIR::Wireable* a_wire = get_wire(a_name, a);
  CoreIR::Wireable* b_wire = get_wire(b_name, b);
  CoreIR::Wireable* c_wire = get_wire(c_name, c);

  if (a_wire != NULL && b_wire != NULL && c_wire != NULL) {
    internal_assert(b.type().bits() == c.type().bits());
    uint inst_bitwidth = b.type().bits() == 1 ? 1 : bitwidth;
    string ternop_name = op_name + a_name + b_name + c_name;
    CoreIR::Wireable* coreir_inst;

    // properly cast to generator or module
    if (context->hasGenerator(gens[op_name])) {
      coreir_inst = def->addInstance(ternop_name, gens[op_name], {{"width", CoreIR::Const::make(context,inst_bitwidth)}});
    } else {
      coreir_inst = def->addInstance(ternop_name, gens[op_name]);
    }

    // wiring names are different for each operator
    if (op_name.compare("bitmux")==0 || op_name.compare("mux")==0) {
      def->connect(a_wire, coreir_inst->sel("sel"));
      def->connect(b_wire, coreir_inst->sel("in0"));
      def->connect(c_wire, coreir_inst->sel("in1"));
    } else {
      def->connect(a_wire, coreir_inst->sel("in0"));
      def->connect(b_wire, coreir_inst->sel("in1"));
      def->connect(c_wire, coreir_inst->sel("in2"));
    }
    add_wire(out_var, coreir_inst->sel("out"));

  } else {
    out_var = "";

    if (a_wire == NULL) { stream << "// input 'a' was invalid!!" << endl; }
    if (b_wire == NULL) { stream << "// input 'b' was invalid!!" << endl; }
    if (c_wire == NULL) { stream << "// input 'c' was invalid!!" << endl; }
  }

  if (is_input(a_name)) { stream << "// " << op_name <<"a: self.in "; } else { stream << "// " << op_name << "a: " << a_name << " "; }
  if (is_input(b_name)) { stream << "// " << op_name <<"b: self.in "; } else { stream << "// " << op_name << "b: " << b_name << " "; }
  if (is_input(c_name)) { stream << "// " << op_name <<"c: self.in "; } else { stream << "// " << op_name << "c: " << c_name << " "; }
  stream << "o: " << out_var << endl;

}  

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Mul *op) {
  visit_binop(op->type, op->a, op->b, "*", "mul");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Add *op) {
  visit_binop(op->type, op->a, op->b, "+", "add");
  // check if we can instantiate a MAD instead
  /*
  if (const Mul* mul = op->a.as<Mul>()) {
    visit_ternop(op->type, mul->a, mul->b, op->b, "*", "+", "MAD");
  } else if (const Mul* mul = op->b.as<Mul>()) {
    visit_ternop(op->type, mul->a, mul->b, op->a, "*", "+", "MAD");
  } else {
    visit_binop(op->type, op->a, op->b, "+", "add");
  }
  */

}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Sub *op) {
  visit_binop(op->type, op->a, op->b, "-", "sub");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Div *op) {
    int shift_amt;
    if (is_const_power_of_two_integer(op->b, &shift_amt)) {
      uint param_bitwidth = op->a.type().bits();
      Expr shift_expr = UIntImm::make(UInt(param_bitwidth), shift_amt);
      visit_binop(op->type, op->a, shift_expr, ">>", "ashr");
    } else {
      stream << "// divide is not fully supported" << endl;
      user_warning << "divide is not fully supported\n";
    }
}
  void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Mod *op) {
    int num_bits;
    if (is_const_power_of_two_integer(op->b, &num_bits)) {
      // equivalent to masking the bottom bits
      uint param_bitwidth = op->a.type().bits();
      uint mask = (1<<num_bits) - 1;
      Expr mask_expr = UIntImm::make(UInt(param_bitwidth), mask);
      visit_binop(op->type, op->a, mask_expr, "&", "and");

//        ostringstream oss;
//        oss << print_expr(op->a) << " & " << ((1 << bits)-1);
//        print_assignment(op->type, oss.str());
    } else if (op->type.is_int()) {
      stream << "// mod is not fully supported" << endl;
      //print_expr(lower_euclidean_mod(op->a, op->b));
    } else {
      stream << "// mod is not fully supported" << endl;
      //visit_binop(op->type, op->a, op->b, "%", "mod");
    }

  }

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const And *op) {
  if (op->a.type().bits() == 1) {
    internal_assert(op->b.type().bits() == 1);
    visit_binop(op->type, op->a, op->b, "&&", "bitand");
  } else {
    visit_binop(op->type, op->a, op->b, "&&", "and");
  }
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Or *op) {
  if (op->a.type().bits() == 1) {
    internal_assert(op->b.type().bits() == 1);
    visit_binop(op->type, op->a, op->b, "||", "bitor");
  } else {
    visit_binop(op->type, op->a, op->b, "||", "or");
  }
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const EQ *op) {
  visit_binop(op->type, op->a, op->b, "==", "eq");
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const NE *op) {
  visit_binop(op->type, op->a, op->b, "!=", "neq");
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const LT *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, "<",  "ult");
  } else {
    visit_binop(op->type, op->a, op->b, "s<", "slt");
  }
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const LE *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, "<=",  "ule");
  } else {
    visit_binop(op->type, op->a, op->b, "s<=", "sle");
  }
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const GT *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, ">",  "ugt");
  } else {
    visit_binop(op->type, op->a, op->b, "s>", "sgt");
  }
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const GE *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, ">=",  "uge");
  } else {
    visit_binop(op->type, op->a, op->b, "s>=", "sge");
  }
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Max *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, "<max>",  "umax");
  } else {
    visit_binop(op->type, op->a, op->b, "<smax>", "smax");
  }
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Min *op) {
  if (op->type.is_uint()) {
    visit_binop(op->type, op->a, op->b, "<min>",  "umin");
  } else {
    visit_binop(op->type, op->a, op->b, "<smin>", "smin");
  }
}
void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Not *op) {
  // operator must have a one-bit/bool input
  assert(op->a.type().bits() == 1);
  visit_unaryop(op->type, op->a, "!", "bitnot");
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Select *op) {
  if (op->type.bits() == 1) {
    // use a special op for bitwidth 1
    visit_ternop(op->type, op->condition, op->true_value, op->false_value, "?",":", "bitmux");
  } else {
    visit_ternop(op->type, op->condition, op->true_value, op->false_value, "?",":", "mux");
  }
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Cast *op) {
  stream << "[cast]";
  string in_var = print_expr(op->value);
  string out_var = print_assignment(op->type, "(" + print_type(op->type) + ")(" + in_var + ")");
  if (!is_const(in_var)) {
    // only add to list, don't duplicate constants
    rename_wire(out_var, in_var, op->value);
  }
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Load *op) {
    Type t = op->type;
    bool type_cast_needed =
        !allocations.contains(op->name) ||
        allocations.get(op->name).type != t;

    string id_index = print_expr(op->index);
    string name = print_name(op->name);
    ostringstream rhs;
    if (type_cast_needed) {
        rhs << "(("
            << print_type(op->type)
            << " *)"
            << name
            << ")";
    } else {
      rhs << name;
    }
    rhs << "["
        << id_index
        << "][load]";

    string out_var = print_assignment(op->type, rhs.str());

    // generate coreir
    // FIXME: ugly way to create array of wireables

    //const Variable* index_var = op->index.as<Variable>();
    if (is_const(op->index)) {
      string in_var = name + "_" + id_index;
      rename_wire(out_var, in_var, Expr());      

    } else {
      std::vector<const Variable*> dep_vars = find_dep_vars(op->index);
      stream << "// vars for " << name << ": ";
      //cout << "// vars for " << name << ": ";
      for (auto v : dep_vars) {
        stream << v->name << ", ";
        //cout << v->name << ", ";
      }
      stream << endl;
      //cout << endl;

      std::vector<VarValues> pts;
      for (const Variable* v : dep_vars) {
        string id_var = print_name(v->name);
        internal_assert(is_defined(id_var)) << " didn't work for " << id_var << "\n";

        std::shared_ptr<CoreIR_Inst_Args> counter_args = hw_def_set[id_var];
        uint counter_max = counter_args->args.at("max")->get<int>();
        uint counter_min = counter_args->args.at("min")->get<int>();
        uint counter_inc = counter_args->args.at("inc")->get<int>();
        internal_assert(counter_min == 0);
        internal_assert(counter_inc == 1);

        stream << "// found counter named " << id_var << " with max " << counter_max << endl;
        
        std::vector<VarValues> old_pts = pts;
        pts.clear();
        if (old_pts.empty()) {
          // add all points from counter
          for (uint count=0; count<counter_max; ++count) {
            VarValues vvv;
            vvv[id_var] = count;
            stream << "//     pushed var,count: " << id_var << "," << count << endl;
            pts.push_back(vvv);
          }

          std::vector<int> indices = eval_expr_with_vars(op->index, pts);

          stream << "// found " << indices.size() << " indices for pts size " << pts.size()
                 <<endl << "// ";
          for (auto idx : indices) {
            stream << idx << ", ";
          }
          stream << endl;

          uint mux_size = indices.size();
          string mux_name = unique_name(name + "_mux" + std::to_string(mux_size));

          CoreIR::Values sliceArgs = {{"width", CoreIR::Const::make(context,bitwidth)},
                                      {"lo", CoreIR::Const::make(context,0)},
                                      {"hi", CoreIR::Const::make(context,num_bits(mux_size-1))}};
          CoreIR::Wireable* slice_inst = def->addInstance("selslice" + mux_name, "coreir.slice", sliceArgs); 

          
          CoreIR::Wireable* mux_inst = def->addInstance(mux_name, gens["muxn"], 
                                                        {{"width",CoreIR::Const::make(context,bitwidth)},{"N",CoreIR::Const::make(context,mux_size)}});

          def->connect(get_wire(id_var, Expr()), slice_inst->sel("in"));
          def->connect(mux_inst->sel("in")->sel("sel"), slice_inst->sel("out"));
          for (uint i=0; i<mux_size; ++i) {
            CoreIR::Wireable* wire_in = get_wire(name + "_" + std::to_string(indices[i]), Expr());
            internal_assert(wire_in) << "Allocation " << name << " was not saved yet for index " << indices[i] << "\n";
            def->connect(wire_in, mux_inst->sel("in")->sel("data")->sel(i));
          }
          add_wire(out_var, mux_inst->sel("out"));


        } else {
          for (uint count=0; count<counter_max; ++count) {
            //FIXME: implement this
            internal_error << "Multiple variable indexing into loads isn't implemented yet!\n";
          }
        }
      }



      //hw_wire_set[out_var] = self->sel("in");

//    } else {
//      cout << "we cannot index " << name << " with an expr yet!" << endl;
//      stream << "// we cannot index " << name << " with an expr yet!" << endl;
    } 
}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const Store *op) {
    Type t = op->value.type();

    bool type_cast_needed =
        t.is_handle() ||
        !allocations.contains(op->name) ||
        allocations.get(op->name).type != t;

    string id_index = print_expr(op->index);
    string id_value = print_expr(op->value);
    string name = print_name(op->name);
    do_indent();

    if (type_cast_needed) {
        stream << "((const "
               << print_type(t)
               << " *)"
               << name
               << ")";
    } else {
        stream << name;
    }
    stream << "["
           << id_index
           << "] = "
           << id_value
           << ";\n";

    // generate coreir
    // FIXME: ugly way to create array of wireables

    string out_var = name + "_" + id_index;
    rename_wire(out_var, id_value, op->value);

}

void CodeGen_CoreIR_Target::CodeGen_CoreIR_C::visit(const IfThenElse *op) {
  string cond_id = print_expr(op->condition);

  do_indent();
  stream << "if (" << cond_id << ")\n";
  open_scope();

  if (!op) {
    internal_error << "there is already a predicate set\n";
  }
  predicate = op;
  op->then_case.accept(this);
  predicate = NULL;

  close_scope("if " + cond_id);

  if (op->else_case.defined()) {
    user_error << "we don't do else cases\n";
    do_indent();
    stream << "else\n";
    open_scope();
    op->else_case.accept(this);
    close_scope("if " + cond_id + " else");
  }

}

// analysis passes structured in a similar fashion to those in Simplify.cpp const_int_bounds( )
std::vector<const Variable*> CodeGen_CoreIR_Target::CodeGen_CoreIR_C::find_dep_vars(Expr e) {
  std::vector<const Variable*> vars;
  
  if (is_const(e)) {
    // no variable to add
  } else if (const Variable *v = e.as<Variable>()) {
    vars.push_back(v);
  } else if (const Max* max = e.as<Max>()) {
    auto vec_a = find_dep_vars(max->a);
    auto vec_b = find_dep_vars(max->b);
    vars.insert( vars.end(), vec_a.begin(), vec_a.end() );
    vars.insert( vars.end(), vec_b.begin(), vec_b.end() );
  } else if (const Min* min = e.as<Min>()) {
    auto vec_a = find_dep_vars(min->a);
    auto vec_b = find_dep_vars(min->b);
    vars.insert( vars.end(), vec_a.begin(), vec_a.end() );
    vars.insert( vars.end(), vec_b.begin(), vec_b.end() );
  } else if (const Select* sel = e.as<Select>()) {
    auto vec_true = find_dep_vars(sel->true_value);
    auto vec_fals = find_dep_vars(sel->false_value);
    auto vec_cond = find_dep_vars(sel->condition);
    vars.insert( vars.end(), vec_true.begin(), vec_true.end() );
    vars.insert( vars.end(), vec_fals.begin(), vec_fals.end() );
    vars.insert( vars.end(), vec_cond.begin(), vec_cond.end() );
  } else if (const Add* add = e.as<Add>()) {
    auto vec_a = find_dep_vars(add->a);
    auto vec_b = find_dep_vars(add->b);
    vars.insert( vars.end(), vec_a.begin(), vec_a.end() );
    vars.insert( vars.end(), vec_b.begin(), vec_b.end() );
  } else if (const Sub* sub = e.as<Sub>()) {
    auto vec_a = find_dep_vars(sub->a);
    auto vec_b = find_dep_vars(sub->b);
    vars.insert( vars.end(), vec_a.begin(), vec_a.end() );
    vars.insert( vars.end(), vec_b.begin(), vec_b.end() );
  } else if (const Mul* mul = e.as<Mul>()) {
    auto vec_a = find_dep_vars(mul->a);
    auto vec_b = find_dep_vars(mul->b);
    vars.insert( vars.end(), vec_a.begin(), vec_a.end() );
    vars.insert( vars.end(), vec_b.begin(), vec_b.end() );
  } else if (const Mod* mod = e.as<Mod>()) {
    auto vec_a = find_dep_vars(mod->a);
    auto vec_b = find_dep_vars(mod->b);
    vars.insert( vars.end(), vec_a.begin(), vec_a.end() );
    vars.insert( vars.end(), vec_b.begin(), vec_b.end() );
  } else if (const Div* div = e.as<Div>()) {
    auto vec_a = find_dep_vars(div->a);
    auto vec_b = find_dep_vars(div->b);
    vars.insert( vars.end(), vec_a.begin(), vec_a.end() );
    vars.insert( vars.end(), vec_b.begin(), vec_b.end() );
  } else if (const Cast* cast = e.as<Cast>()) {
    auto vec_v = find_dep_vars(cast->value);
    vars.insert( vars.end(), vec_v.begin(), vec_v.end() );
  } else {
    internal_error << "function " << e << " not supported in simplification...\n";
    stream << "// function not supported...";
  }

  // all functions return variable "vars"
  return vars;
}

std::vector<int> CodeGen_CoreIR_Target::CodeGen_CoreIR_C::eval_expr_with_vars(Expr e, std::vector<VarValues> pts) {
  std::vector<int> indices (pts.size());

  if (is_const(e)) {
    int value = id_const_value(e);
    std::fill( indices.begin(), indices.end(), value );
  } else if (const Variable *v = e.as<Variable>()) {
    stream << "// evaling for var " << print_name(v->name) << endl;
    for (uint i=0; i<indices.size(); ++i) {
      indices[i] = pts[i][print_name(v->name)];
      stream << "// pushing " << indices[i] << " for index " << i << endl;
    }
  } else if (const Max* max = e.as<Max>()) {
    auto vec_a = eval_expr_with_vars(max->a, pts);
    auto vec_b = eval_expr_with_vars(max->b, pts);
    for (uint i=0; i<indices.size(); ++i) {
      indices[i] = std::max(vec_a[i], vec_b[i]);
    }
  } else if (const Min* min = e.as<Min>()) {
    auto vec_a = eval_expr_with_vars(min->a, pts);
    auto vec_b = eval_expr_with_vars(min->b, pts);
    for (uint i=0; i<indices.size(); ++i) {
      indices[i] = std::min(vec_a[i], vec_b[i]);
    }
  } else if (const Select* sel = e.as<Select>()) {
    auto vec_true = eval_expr_with_vars(sel->true_value, pts);
    auto vec_fals = eval_expr_with_vars(sel->false_value, pts);
    auto vec_cond = eval_expr_with_vars(sel->condition, pts);
    for (uint i=0; i<indices.size(); ++i) {
      indices[i] = vec_cond[i] ? vec_true[i] : vec_fals[i];
    }
  } else if (const Add* add = e.as<Add>()) {
    auto vec_a = eval_expr_with_vars(add->a, pts);
    auto vec_b = eval_expr_with_vars(add->b, pts);
    for (uint i=0; i<indices.size(); ++i) {
      indices[i] = vec_a[i] + vec_b[i];
    }
  } else if (const Sub* sub = e.as<Sub>()) {
    auto vec_a = eval_expr_with_vars(sub->a, pts);
    auto vec_b = eval_expr_with_vars(sub->b, pts);
    for (uint i=0; i<indices.size(); ++i) {
      indices[i] = vec_a[i] - vec_b[i];
    }
  } else if (const Mul* mul = e.as<Mul>()) {
    auto vec_a = eval_expr_with_vars(mul->a, pts);
    auto vec_b = eval_expr_with_vars(mul->b, pts);
    for (uint i=0; i<indices.size(); ++i) {
      indices[i] = vec_a[i] * vec_b[i];
    }
  } else if (const Mod* mod = e.as<Mod>()) {
    auto vec_a = eval_expr_with_vars(mod->a, pts);
    auto vec_b = eval_expr_with_vars(mod->b, pts);
    for (uint i=0; i<indices.size(); ++i) {
      indices[i] = vec_a[i] % vec_b[i];
    }
  } else if (const Div* div = e.as<Div>()) {
    auto vec_a = eval_expr_with_vars(div->a, pts);
    auto vec_b = eval_expr_with_vars(div->b, pts);
    for (uint i=0; i<indices.size(); ++i) {
      indices[i] = vec_a[i] / vec_b[i];
    }
  } else {
    internal_error << "function not supported...";
    stream << "// function not supported...";
  }

  // all cases return variable "indices"
  return indices;
}

}
}

