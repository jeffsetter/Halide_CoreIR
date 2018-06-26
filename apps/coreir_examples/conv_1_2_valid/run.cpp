#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "halide_image.h"
#include "halide_image_io.h"
#include "pipeline_native.h"
#include "pipeline_hls.h"

#include "coreir_simulation.h"

using namespace Halide::Tools;
using namespace CoreIR;

int main(int argc, char **argv) {
  Image<uint8_t> in(9,10, 1);

  Image<uint8_t> out_native(in.width(), in.height(), in.channels());
  Image<uint8_t> out_hls(in.width(), in.height(), in.channels());
  Image<uint8_t> out_coreir(in.width(), in.height(), in.channels());
  ImageWriter<uint16_t> coreir_writer(in.width(), in.height(), in.channels());
  in = load_image(argv[1]);

  printf("start.\n");

  pipeline_native(in, out_native);
  save_image(out_native, "out.png");
  save_image(out_native, "out.pgm");

  printf("finish running native code\n");

  pipeline_hls(in, out_hls);

  printf("finish running HLS code\n");

  bool success = true;
  for (int y = 0; y < out_native.height(); y++) {
    for (int x = 0; x < out_native.width(); x++) {
	    for (int c = 0; c < out_native.channels(); c++) {
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
  Module* m = g->getModule("DesignTop");
  assert(m != nullptr);
  SimulatorState state(m);

  if (!saveToFile(c->getGlobal(), "design_flat.json", m)) {
    std::cout << "Could not save to json!!" << std::endl;
    c->die();
  }

  state.setValue("self.in_arg_1_0_0", BitVector(16));
  state.resetCircuit();
  state.setClock("self.clk", 0, 1);

  uint cycle = 0;
  for (int y = 0; y < in.height(); y++) {
    for (int x = 0; x < in.width(); x++) {
      for (int c = 0; c < in.channels(); c++) {
        // set input value
        state.setValue("self.in_arg_1_0_0", BitVector(16, in(x,y,c)));
        // propogate to all wires
        state.exeCombinational();
            
        // read output wire
        out_coreir(x,y,c) = state.getBitVec("self.out_0_0").to_type<uint16_t>();
        if (x>=1 && y>=0 && out_native(x-1, y, c) != out_coreir(x, y, c)) {
          printf("out_native(%d, %d, %d) = %d, but out_coreir(%d, %d, %d) = %d\n",
                 x-1, y, c, out_native(x-1, y, c),
                 x, y, c, out_coreir(x, y, c));
          success = false;
        }

        bool valid = state.getBitVec("self.valid").to_type<bool>();
        //uint16_t count = state.getBitVec("lb_p4_clamped_stencil_update_stream$valcompare_0.in1").to_type<uint16_t>();
        //uint16_t constant = state.getBitVec("lb_p4_clamped_stencil_update_stream$valcompare_0.in0").to_type<uint16_t>();
        //bool valid_comp = state.getBitVec("lb_p4_clamped_stencil_update_stream$valcompare_0.out").to_type<bool>();
        if (valid) {
          coreir_writer.write(out_coreir(x,y,c));
          //std::cout << "wrote on cycle " << cycle << " for x=" << x << " y=" << y << " with ";
        }
        //printf("out_coreir(%d, %d, %d) = %d,  valid=%d\n",x,y,c,out_coreir(x,y,c), valid);
        //std::cout << "count=" << count << " const=" << constant << " valid=" << valid_comp << std::endl;

        // give another rising edge (execute seq)
        state.exeSequential();
        cycle++;
      }
    }
  }

  deleteContext(c);

  for (int y = 0; y < out_native.height(); y++) {
    for (int x = 0; x < out_native.width(); x++) {
	    for (int c = 0; c < out_native.channels(); c++) {
        if (out_native(x, y, c) != coreir_writer.read(x, y, c)) {
          printf("out_native(%d, %d, %d) = %d, but out_coreir(%d, %d, %d) = %d\n",
                 x, y, c, out_native(x, y, c),
                 x, y, c, coreir_writer.read(x, y, c));
          success = false;
        }
      }
    }
  }


  if (success) {
    printf("Succeeded!\n");
    return 0;
  } else {
    printf("Failed!\n");
    return 1;
  }

}
