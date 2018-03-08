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

class my_load_image {
public:
    my_load_image(const std::string &f) : filename(f) {}
    template<typename ImageType>
    inline operator ImageType() {
        ImageType im;
        (void) load<ImageType, Internal::CheckFail>(filename, &im);
        // shuffle data
        ImageType res(im.channels(), im.width(), im.height());
        //ImageType res(3, 256+8, 256+8);
        for(int c = 0; c < res.extent(0); c++)
            for(int x = 0; x < res.extent(1); x++)
                for(int y = 0; y < res.extent(2); y++)
                    res(c, x, y) = im(x, y, c);
        return res;
    }
private:
  const std::string filename;
};


template<typename ImageType>
void my_save_image(ImageType &im, const std::string &filename) {
    int width = im.extent(1);
    int height = im.extent(2);
    int channels = im.extent(0);
    ImageType shuffled(width, height, channels);
    for(int x = 0; x < width; x++)
        for(int y = 0; y < height; y++)
            for(int c = 0; c < channels; c++)
                shuffled(x, y, c) = im(c, x, y);
    (void) save<ImageType, Internal::CheckFail>(shuffled, filename);
}


int main(int argc, char **argv) {
  // input size should be 1920x1080
    Image<uint8_t> input = load_image(argv[1]);
    Image<uint8_t> out_native(input.width(), input.height());
    Image<uint8_t> out_hls(input.width(), input.height());
		Image<uint8_t> out_coreir(input.width(), input.height());

    printf("start.\n");

    pipeline_native(input, out_native);
    save_image(out_native, "out.png");
    //    save_image(out_native, "out.ppm");
    //    save_image(out_native, "out.pgm");

    printf("finish running native code\n");
    pipeline_hls(input, out_hls);

    printf("finish running HLS code\n");

    unsigned fails = 0;
    for (int y = 0; y < out_hls.height(); y++) {
			for (int x = 0; x < out_hls.width(); x++) {
				for (int c = 0; c < out_hls.channels(); c++) {
					if (out_native(x, y, c) != out_hls(x, y, c)) {
						printf("out_native(%d, %d, %d) = %d, but out_c(%d, %d, %d) = %d\n",
									 x, y, c, out_native(x, y, c),
									 x, y, c, out_hls(x, y, c));
						fails++;
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
    //state.setClock("self.clk", 0, 1);

    for (int y = 0; y < input.height(); y++) {
      for (int x = 0; x < input.width(); x++) {
        for (int c = 0; c < input.channels(); c++) {
          // set input value
          state.setValue("self.in_arg_1_0_0", BitVector(16, input(x,y,c)));
          // propogate to all wires
          state.exeCombinational();
            
          // read output wire
          out_coreir(x,y,c) = state.getBitVec("self.out_0_0").to_type<uint16_t>();
					int xd = 0;	int yd = 0;
          if (x>=xd && y>=yd && out_native(x-xd, y-yd, c) != out_coreir(x, y, c)) {
            printf("out_native(%d, %d, %d) = %d, but out_coreir(%d, %d, %d) = %d\n",
                   x-xd, y-yd, c, out_native(x-xd, y-yd, c),
                   x, y, c, out_coreir(x, y, c));
						fails++;
          }

          // give another rising edge (execute seq)
          state.exeSequential();

        }
      }
    }

    deleteContext(c);


    if (!fails) {
			printf("passed.\n");
			return 0;
    } else  {
			printf("%u fails.\n", fails);
			return 1;
    }
    return 0;
}
