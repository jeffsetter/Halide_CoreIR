#include <cstdio>
#include <cstdlib>
#include <cassert>
#include <math.h>

#include "pipeline_hls.h"
#include "pipeline_native.h"
#include "halide_image.h"
#include "halide_image_io.h"

#include "coreir.h"
#include "coreir/passes/transform/rungenerators.h"
#include "coreir/simulator/interpreter.h"
#include "coreir/libs/commonlib.h"

using namespace Halide::Tools;
using namespace CoreIR;

int main(int argc, char **argv) {
  Image<uint8_t> input = load_image(argv[1]);
  Image<uint8_t> out_native(55,55, 3);
  Image<uint8_t> out_hls(55,55, 3);
  Image<uint8_t> out_coreir(64, 64, 3);

  printf("start.\n");

  pipeline_native(input, out_native);
  save_image(out_native, "out.png");

  printf("finished running native code\n");

  pipeline_hls(input, out_hls);

  printf("finished running HLS code\n");

  bool success = true;
  for (int y = 0; y < out_hls.height(); y++) {
    for (int x = 0; x < out_hls.width(); x++) {
      for (int c = 0; c < out_hls.channels(); c++) {
        if (out_native(x, y, c) != out_hls(x, y, c)) {
          printf("out_native(%d, %d, %d) = %d, but out_c(%d, %d, %d) = %d\n",
                 x, y, c, out_native(x, y, c),
                 x, y, c, out_hls(x, y, c));
          success = false;
        }
      }
    }
  }

    // New context for coreir test
  Context* c = newContext();
  Namespace* g = c->getGlobal();

  CoreIRLoadLibrary_commonlib(c);
  if (!loadFromFile(c,"./design_prepass.json")) {
    std::cout << "Could not Load from json!!" << std::endl;
    c->die();
  }

  c->runPasses({"rungenerators", "flattentypes", "flatten", "wireclocks-coreir"});

  std::cout << "finished passes" << std::endl;
  Module* m = g->getModule("DesignTop");
  assert(m != nullptr);
  SimulatorState state(m);

  state.setValue("self.in_arg_3_0_0", BitVector(16));
  state.setValue("self.reset", BitVector(1));
  std::cout << "starting reset" << std::endl;
  state.resetCircuit();
  state.setClock("self.clk", 0, 1);

  std::cout << "Starting coreir simulation" << std::endl;

  for (int y = 0; y < out_coreir.height(); y+=1) {
    for (int x = 0; x < out_coreir.width(); x+=1) {
      for (int c = 0; c < 1; c++) {
        // set input value
        state.setValue("self.in_arg_3_0_0", BitVector(16, input(x,y,c)));
        // propogate to all wires
        state.exeCombinational();
        state.exeCombinational();

            
        // read output wire
        out_coreir(x,y,2) = state.getBitVec("self.out_2_0_0").to_type<uint8_t>();
        out_coreir(x,y,1) = state.getBitVec("self.out_1_0_0").to_type<uint8_t>();
        out_coreir(x,y,0) = state.getBitVec("self.out_0_0_0").to_type<uint8_t>();
        state.getBitVec("self.valid").to_type<bool>();

        //uint16_t coreir_value = state.getBitVec("self.out_0_0").to_type<uint16_t>();
        if (x>=2 && y>=2 && out_native(x-2, y-2, c) != out_coreir(x,y,c)) {
          printf("out_native(%d, %d, %d) = %x, but out_coreir(%d, %d, %d) = %x\n",
                 x-2, y-2, c, out_native(x-2, y-2, c),
                 x, y, c, out_coreir(x,y,c));
          success = false;
                 
        }

        // give another rising edge (execute seq)
        state.exeSequential();
      }
    }
  }

  std::cout << "CoreIR image comparison complete!" << std::endl;


  
  if (success)
    return 0;
  else return 1;
}
