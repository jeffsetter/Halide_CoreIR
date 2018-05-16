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

template <typename elem_t>
class ImageWriter {
public:
  ImageWriter(uint width, uint height, uint channels=1) :
    width(width), height(height), channels(channels),
    image(width, height, channels),
    current_x(0), current_y(0), current_z(0) { }

  void write(elem_t data) {
    assert(current_x < width &&
           current_y < height &&
           current_z < depth);
    image(current_x, current_y, current_z) = data;

    // increment coords
    current_x++;
    if (current_x == width) {
      current_y++;
      current_x = 0;
    }
    if (current_y == height) {
      current_z++;
      current_y = 0;
    }
  }

  elem_t read(uint x, uint y, uint z) {
    return image(x,y,z);
  }

private:
  const uint width, height, channels;
  Image<elem_t> image;
  uint current_x, current_y, current_z;
};


int main(int argc, char **argv) {
    Image<uint8_t> in(62, 62, 1);
    Image<uint8_t> weight(5,5);

    Image<uint8_t> out_native(in.width(), in.height(), in.channels());
    Image<uint8_t> out_hls(in.width(), in.height(), in.channels());
    Image<uint8_t> out_coreir(in.width(), in.height(), in.channels());
    ImageWriter<uint16_t> coreir_writer(in.width(), in.height(), in.channels());

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
    if (!saveToFile(g, "design_postpass.json", g->getModule("DesignTop"))) {
      c->die();
    }

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
                   x-2, y-2, c, out_native(x-2, y-2, c),
                   x, y, c, out_coreir(x, y, c));
            success = false;
          }

          bool valid = state.getBitVec("self.valid").to_type<bool>();
          if (valid) {
            coreir_writer.write(out_coreir(x,y,c));
            //std::cout << "wrote on cycle " << cycle << " for x=" << x << " y=" << y << " with ";
          }
          //printf("out_coreir(%d, %d, %d) = %d,  valid=%d\n",x,y,c,out_coreir(x,y,c), valid);

          // give another rising edge (execute seq)
          state.exeSequential();

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
    printf("finished running CoreIR code\n");

    if (success) {
      printf("Succeeded!\n");
      return 0;
    } else {
      printf("Failed!\n");
      return 1;
    }

}
