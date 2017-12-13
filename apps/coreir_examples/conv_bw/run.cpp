#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "halide_image.h"
#include "halide_image_io.h"
#include "pipeline_native.h"
#include "pipeline_hls.h"

#include "coreir.h"
#include "coreir/passes/transform/rungenerators.h"
#include "coreir/simulator/interpreter.h"
#include "coreir/libs/commonlib.h"

using namespace Halide::Tools;
using namespace CoreIR;

const unsigned char gaussian2d[5][5] = {
    {1,     3,     6,     3,     1},
    {3,    15,    25,    15,     3},
    {6,    25,    44,    25,     6},
    {3,    15,    25,    15,     3},
    {1,     3,     6,     3,     1}
};


int main(int argc, char **argv) {
    Image<uint8_t> in(62, 62, 1);
    Image<uint8_t> weight(5,5);

    Image<uint8_t> out_native(in.width(), in.height(), in.channels());
    Image<uint8_t> out_hls(in.width(), in.height(), in.channels());
    Image<uint8_t> out_coreir(in.width(), in.height(), in.channels());

    int l = 0;
    for (int y = 0; y < in.height(); y++) {
        for (int x = 0; x < in.width(); x++) {
	    for (int c = 0; c < in.channels(); c++) {
              //in(x, y, c) = (uint8_t) x+y;   //rand();
              in(x,y,c) = l;
              l++;
	    }
        }
    }
    //save_image(in, "input_unique.pgm");
    in = load_image(argv[1]);

    for (int y = 0; y < weight.height(); y++)
      for (int x = 0; x < weight.width(); x++)
            weight(x, y) = gaussian2d[y][x];

    printf("start.\n");

    //    pipeline_native(in, weight, 0, out_native);
    pipeline_native(in, 0, out_native);
    save_image(out_native, "out.png");

    printf("finish running native code\n");

    //    pipeline_hls(in, weight, 0, out_hls);
    pipeline_hls(in, 0, out_hls);

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

    state.setValue("self.in_arg_1_0_0", BitVector(16));
    state.resetCircuit();
    state.setClock("self.clk", 0, 1);

    for (int y = 0; y < in.height(); y++) {
      for (int x = 0; x < in.width(); x++) {
        for (int c = 0; c < in.channels(); c++) {
          // set input value
          state.setValue("self.in_arg_1_0_0", BitVector(16, in(x,y,c)));
          // propogate to all wires
          state.exeCombinational();
            
          // read output wire
          out_coreir(x,y,c) = state.getBitVec("self.out_0_0").to_type<uint16_t>();
          if (x>=2 && y>=2 && out_native(x-2, y-2, c) != out_coreir(x, y, c)) {
            printf("out_native(%d, %d, %d) = %d, but out_coreir(%d, %d, %d) = %d\n",
                   x, y, c, out_native(x, y, c),
                   x, y, c, out_coreir(x, y, c));
            success = false;
          }

          // give another rising edge (execute seq)
          state.exeSequential();

        }
      }
    }

    deleteContext(c);

    if (success) {
        printf("Succeeded!\n");
        return 0;
    } else {
        printf("Failed!\n");
        return 1;
    }

}
