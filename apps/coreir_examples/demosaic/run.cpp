#include <cstdio>
#include <cstdlib>
#include <cassert>
#include <math.h>

//#include "Halide.h"

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

template <typename elem_t>
class ImageWriter {
public:
  ImageWriter(Image<elem_t> &image) :
    width(image.width()), height(image.height()), channels(image.channels()),
    current_x(0), current_y(0), current_z(0), image(image) { }

  void write(elem_t data) {
    if (!(current_x < width &&
          current_y < height &&
          current_z < channels)) {
      std::cout << "wrote too many: " 
                << current_x << "," << current_y << "," << current_z << std::endl;      
    }
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
    if (!(x < width &&
          y < height &&
          z < channels)) {
      std::cout << "read out of bounds: " << x << "," << y << "," << z << std::endl;      
    }

    return image(x,y,z);
  }

  void save_image(std::string image_name) {
    Halide::Tools::save_image(image, image_name);
  }

  void print_coords() {
    std::cout << "x=" << current_x << ",y=" << current_y << ",z=" << current_z << std::endl;
  }

private:
  const uint32_t width, height, channels;
  uint32_t current_x, current_y, current_z;
  Image<elem_t> &image;
};


int main(int argc, char **argv) {
  /*
    Halide::Func mosaic;
    Halide::Image<uint8_t> input = load_image("../tutorial/images/rgb.png");
    Halide::Var x, y;

    // Create an RG/GB mosaic
    mosaic(x, y) = Halide::cast<uint8_t>(Halide::select((y % 2) == 0,
    Halide::select((x % 2) == 0, input(x, y, 0), input(x, y, 1)), // First row, RG
    Halide::select((x % 2) == 0, input(x, y, 1), input(x, y, 2)))); // GB

    Halide::Image<uint8_t> mosaic_image = mosaic.realize(input.width(), input.height());
    save_image(mosaic_image, "mosaic.png");

  Halide::Image<uint8_t> in = load_image(argv[1]);
  Halide::Func input_cropped;
  Halide::Var x, y;
  input_cropped(x,y) = Halide::select(x < 0, in(x+300,y+200), in(x+300,y+200));
  
  Halide::Image<uint8_t> in_crop = input_cropped.realize(64, 64);
  save_image(in_crop, "input.png");
  */
  Image<uint8_t> in(64,64,3);
  in = load_image(argv[1]);
  Image<uint8_t> out_native(62, 62, 3);
  Image<uint8_t> out_hls(62, 62, 3);
  Image<uint8_t> out_coreir(64, 64, 3);
  //ImageWriter<uint8_t> *coreir_writer = new ImageWriter<uint8_t>(out_coreir);
  Image<uint8_t> coreir_image(64, 64, 3);

  printf("start.\n");

  pipeline_native(in, out_native);
  save_image(out_native, "out.png");

  printf("finished running native code\n");

  pipeline_hls(in, out_hls);

  printf("finished running HLS code\n");

  bool success = true;
  for (int y = 0; y < out_native.height(); y++) {
    for (int x = 0; x < out_native.width(); x++) {
      if (fabs(out_native(x, y, 0) - out_hls(x, y, 0)) > 1e-4) {
        printf("out_native(%d, %d, 0) = %d, but out_c(%d, %d, 0) = %d\n",
               x, y, out_native(x, y, 0),
               x, y, out_hls(x, y, 0));
        success = false;
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
        state.setValue("self.in_arg_3_0_0", BitVector(16, in(x,y,c)));
        // propogate to all wires
        state.exeCombinational();
        state.exeCombinational();

            
        // read output wire
        coreir_image(x,y,2) = state.getBitVec("self.out_2_0_0").to_type<uint8_t>();
        coreir_image(x,y,1) = state.getBitVec("self.out_1_0_0").to_type<uint8_t>();
        coreir_image(x,y,0) = state.getBitVec("self.out_0_0_0").to_type<uint8_t>();
        state.getBitVec("self.valid").to_type<bool>();

        //uint16_t input= state.getBitVec("self.in_arg_3_0_0").to_type<uint16_t>();
        //uint16_t lb00 = state.getBitVec("add_934_936_937.in0").to_type<uint16_t>();
        //uint16_t lb01 = state.getBitVec("add_910_912_913.in1").to_type<uint16_t>();
        //uint16_t lb02 = state.getBitVec("add_934_936_937.in1").to_type<uint16_t>();
        //uint16_t lb10 = state.getBitVec("add_907_909_910.in0").to_type<uint16_t>();
        //uint16_t lb11 = state.getBitVec("mux_864_868_876.in1").to_type<uint16_t>();
        //uint16_t lb12 = state.getBitVec("add_870_872_873.in1").to_type<uint16_t>();
        //uint16_t lb20 = state.getBitVec("add_889_891_892.in1").to_type<uint16_t>();
        //uint16_t lb21 = state.getBitVec("add_913_915_916.in1").to_type<uint16_t>();
        //uint16_t lb22 = state.getBitVec("add_940_942_943.in1").to_type<uint16_t>();
        //printf("y=%d,x=%d  in=%x  lb00=%x,lb01=%x,lb02=%x lb10=%x,lb11=%x,lb12=%x lb20=%x,lb21=%x,lb22=%x\n",
        //       y,x,input,
        //       lb00,lb01,lb02,
        //       lb10,lb11,lb12,
        //       lb20,lb21,lb22);
        
        //uint16_t coreir_value = state.getBitVec("self.out_0_0").to_type<uint16_t>();
        if (x>=2 && y>=2 && out_native(x-2, y-2, c) != coreir_image(x,y,c)) {
          printf("out_native(%d, %d, %d) = %x, but coreir_image(%d, %d, %d) = %x\n",
                 x-2, y-2, c, out_native(x-2, y-2, c),
                 x, y, c, coreir_image(x,y,c));
          success = false;
                 
        }

//        if (x>=4 && y>=4 && !valid) {
//          printf("out_native(%d, %d, %d) = %d and coreir_image(%d, %d, %d) = %d, but valid = %d\n",
//                 x-4, y-4, c, out_native(x-4, y-4, c),
//                 x, y, c, coreir_image(x,y,c), valid);
//        }
        //printf("out_coreir(%d, %d, %d) = %d,  valid=%d\n",x,y,c,out_coreir(x,y,c), valid);

        //printf("out_coreir(%d,%d,%d) = %d\n",  x,y,c,out_coreir(x,y,c));

        // printout state
        /*
          printf("cycle%d:  in=%d, mid=%d, out=%d\n", 
          c + x*in.channels() + y*in.width()*in.channels(),
          in(x,y,c),
          state.getBitVec("add_495_526_527.out").to_type<uint16_t>(),
          out_coreir(x,y,c));

          std::cout << "cycle" << c + x*in.channels() + y*in.width()*in.channels()
          << ":  in=" << in(x,y,c) 
          << ", mid=" << state.getBitVec("add_519_523_524.out").to_type<uint16_t>()
          << ", out=" << out_coreir(x,y,c) << std::endl;
        */

        // give another rising edge (execute seq)
        state.exeSequential();
      }
    }
  }

  std::cout << "CoreIR image comparison complete!" << std::endl;

  
  if (success)
    return 0;
  else return 1;

  /*
    FILE *ptr;
    ptr = fopen("raw", "wb");
    uint8_t in_pixel[1];
    for (int y = 0; y < 480; y++) {
    for (int x = 0; x < 640; x++) {
    in_pixel[0] = input(x, y);
    fwrite(in_pixel, sizeof(in_pixel), 1, ptr);
    }
    }
    fclose(ptr);

    ptr = fopen("dump_ref", "wb");
    uint8_t out_pixel[4];
    for (int y = 1; y < 1 + 480; y++) {
    for (int x = 1; x < 1 + 640; x++) {
    out_pixel[0] = out_native(x, y, 0);
    out_pixel[1] = out_native(x, y, 1);
    out_pixel[2] = out_native(x, y, 2);
    out_pixel[3] = 0;
    fwrite(out_pixel, sizeof(out_pixel), 1, ptr);
    }
    }
    fclose(ptr);
  */
}
