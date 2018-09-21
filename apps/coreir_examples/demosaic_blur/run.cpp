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
  Image<uint8_t> in = load_image(argv[1]);
  Image<uint8_t> out_native(61, 61, 3);
  Image<uint8_t> out_hls(61, 61, 3);
  Image<uint8_t> out_coreir(64, 64, 3);
  ImageWriter<uint8_t> *coreir_writer = new ImageWriter<uint8_t>(out_coreir);
  Image<uint8_t> coreir_image(64, 64, 3);

  printf("start.\n");

  pipeline_native(in, out_native);
  save_image(out_native, "out.png");

  printf("finish running native code\n");

  pipeline_hls(in, out_hls);

  printf("finish running HLS code\n");

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

        // outputs for red demosaic lb
        uint16_t r00 = state.getBitVec("add_1141_1143_1144.in0").to_type<uint16_t>();
        uint16_t r10 = state.getBitVec("add_1150_1152_1153.in0").to_type<uint16_t>();
        uint16_t r01 = state.getBitVec("add_1141_1143_1144.in1").to_type<uint16_t>();
        uint16_t r11 = state.getBitVec("add_1150_1152_1153.in1").to_type<uint16_t>();
        
        // outputs for green demosaic lb
        uint16_t g00 = state.getBitVec("add_1161_1163_1164.in0").to_type<uint16_t>();
        uint16_t g01 = state.getBitVec("add_1161_1163_1164.in1").to_type<uint16_t>();
        uint16_t g10 = state.getBitVec("add_1170_1172_1173.in0").to_type<uint16_t>();
        uint16_t g11 = state.getBitVec("add_1170_1172_1173.in1").to_type<uint16_t>();
        
        // outputs for blue demosaic lb
        uint16_t b00 = state.getBitVec("add_1181_1183_1184.in0").to_type<uint16_t>();
        uint16_t b01 = state.getBitVec("add_1181_1183_1184.in1").to_type<uint16_t>();
        uint16_t b10 = state.getBitVec("add_1190_1192_1193.in0").to_type<uint16_t>();
        uint16_t b11 = state.getBitVec("add_1190_1192_1193.in1").to_type<uint16_t>();
        
        // inputs coming out of lb
        uint16_t in00 = state.getBitVec("add_1060_1062_1063.in0").to_type<uint16_t>();
        uint16_t in01 = state.getBitVec("add_1053_1055_1056.in0").to_type<uint16_t>();
        uint16_t in02 = state.getBitVec("add_1060_1062_1063.in1").to_type<uint16_t>();
        uint16_t in10 = state.getBitVec("add_1044_1046_1047.in0").to_type<uint16_t>();
        uint16_t in11 = state.getBitVec("mux_1038_1042_1050.in1").to_type<uint16_t>();
        uint16_t in12 = state.getBitVec("add_1081_1083_1084.in1").to_type<uint16_t>();
        uint16_t in20 = state.getBitVec("add_1063_1065_1066.in1").to_type<uint16_t>();
        uint16_t in21 = state.getBitVec("add_1053_1055_1056.in1").to_type<uint16_t>();
        uint16_t in22 = state.getBitVec("add_1066_1068_1069.in1").to_type<uint16_t>();
        
        // rgb values going into demosaic lb
        uint16_t lb0 = state.getBitVec("mux_1041_1051_1073.out").to_type<uint16_t>();
        uint16_t lb1 = state.getBitVec("mux_1093_1097_1098.out").to_type<uint16_t>();
        uint16_t lb2 = state.getBitVec("mux_1106_1129_1138.out").to_type<uint16_t>();
        bool lb_valid= state.getBitVec("lb_padded_2_stencil_update_stream$lb_recurse$valid_andr$_join.out").to_type<bool>();

        bool valid = state.getBitVec("self.valid").to_type<bool>();
        //uint16_t coreir_value = state.getBitVec("self.out_0_0").to_type<uint16_t>();
        if (x>=3 && y>=3 && out_native(x-3, y-3, c) != coreir_image(x,y,c)) {
          printf("out_native(%d, %d, %d) = {%x,%x,%x}, but coreir_image(%d, %d, %d) = {%x,%x,%x}\n",
                 x-3, y-3, c,
                 out_native(x-3, y-3, 0),out_native(x-3, y-3, 1),out_native(x-3, y-3, 2),
                 x, y, c,
                 coreir_image(x,y,0),coreir_image(x,y,1),coreir_image(x,y,2));
          success = false;
        }
        printf("x=%d,y=%d inlb={%x,%x,%x, %x,%x,%x, %x,%x,%x}  din={%x,%x,%x},v=%x  dout: r={%x,%x,%x,%x} g={%x,%x,%x,%x} b={%x,%x,%x,%x}  valid=%x\n",
               x,y,
               in00,in01,in02, in10,in11,in12, in20,in21,in22,
               lb0,lb1,lb2,lb_valid,
               r00,r01,r10,r11,
               g00,g01,g10,g11,
               b00,b01,b10,b11,
               valid);


//        if (x>=4 && y>=4 && !valid) {
//          printf("out_native(%d, %d, %d) = %d and coreir_image(%d, %d, %d) = %d, but valid = %d\n",
//                 x-4, y-4, c, out_native(x-4, y-4, c),
//                 x, y, c, coreir_image(x,y,c), valid);
//        }
        if (valid) {
          coreir_writer->write(coreir_image(x,y,c));
        }
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

  coreir_writer->save_image("out_coreir.png");
  coreir_writer->print_coords();


  //for (int y = 0; y < out_coreir.height(); y++) {
  //  for (int x = 0; x < out_coreir.width(); x++) {
  //    if (fabs(out_native(x, y) - out_coreir(x, y)) > 1e-4) {
  //      printf("out_native(%d, %d) = %d, but out_coreir(%d, %d) = %d\n",
  //             x, y, out_native(x, y),
  //             x, y, out_coreir(x, y));
  //      success = false;
  //    }
  //  }
  //}
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
