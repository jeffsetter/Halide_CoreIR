#include "Halide.h"
#include <string.h>

using namespace Halide;
using std::string;

Var x("x"), y("y");
Var xo("xo"), xi("xi"), yi("yi"), yo("yo");

class MyPipeline {
public:
  ImageParam input;
  Func clamped, kernel;
  Func conv, blur, pixel, is_max;
  Func output, hw_output;
  std::vector<Argument> args;

  RDom win;

  MyPipeline() : input(UInt(8), 2, "input"),
                 kernel("kernel"), conv("conv"),
                 output("output"), hw_output("hw_output"),
                 win(0, 4){
    // Define a 1x4 Blur
    kernel(x) = select(x==0, 3,
                       x==1, 5,
                       x==2, 5,
                       x==3, 3, 0
                       );
    //kernel(0) = 3; kernel(1) = 5;
    //kernel(2) = 5; kernel(3) = 3;

    // define the algorithm
    clamped(x,y) = input(x, y);
    conv(x, y) += clamped(x+win.x, y) * kernel(win.x);

    // unroll the reduction
    conv.update(0).unroll(win.x);

    // normalize and clamp the output to 8 bits
    blur(x,y) = conv(x,y) / 16;
    pixel(x,y) = select(blur(x,y) > (2^8)-1, (2^8)-1, blur(x,y));

    // set top bit if leftmost blur pixel is the maximum
    Expr is_max = blur(x,y)>blur(x+1,y) && blur(x,y)>blur(x+2,y) && blur(x,y)>blur(x+3,y);

    //hw_output(x,y) = select(is_max, cast<uint8_t>(blur(x,y)), 0);
    hw_output(x,y) = cast<uint8_t>(pixel(x,y));

    output(x, y) = hw_output(x, y);

    args.push_back(input);

  }

  void compile_cpu() {
    std::cout << "\ncompiling cpu code..." << std::endl;

    output.tile(x, y, xo, yo, xi, yi, 13,16);
    output.fuse(xo, yo, xo).parallel(xo);

    output.vectorize(xi, 4);
    conv.compute_at(output, xo).vectorize(x, 4);

    //output.print_loop_nest();
    output.compile_to_lowered_stmt("pipeline_native.ir.html", args, HTML);
    output.compile_to_header("pipeline_native.h", args, "pipeline_native");
    output.compile_to_object("pipeline_native.o", args, "pipeline_native");
  }

  void compile_hls() {
    std::cout << "\ncompiling HLS code..." << std::endl;

    clamped.compute_root(); // prepare the input for the whole image

    // HLS schedule: make a hw pipeline producing 'hw_output', taking
    // inputs of 'clamped', buffering intermediates at (output, xo) loop
    // level
    hw_output.compute_root();
    hw_output.tile(x, y, xo, yo, xi, yi, 13,16).reorder(xi, yi, xo, yo);
    hw_output.accelerate({clamped}, xi, xo, {});  // define the inputs and the output
    conv.linebuffer();

    //output.print_loop_nest();
    Target hls_target = get_target_from_environment();
    hls_target.set_feature(Target::CPlusPlusMangling);
    output.compile_to_lowered_stmt("pipeline_hls.ir.html", args, HTML, hls_target);
    output.compile_to_hls("pipeline_hls.cpp", args, "pipeline_hls", hls_target);
    output.compile_to_header("pipeline_hls.h", args, "pipeline_hls", hls_target);
  }

  void compile_coreir() {
    std::cout << "\ncompiling CoreIR code..." << std::endl;
    clamped.compute_root();
    hw_output.compute_root();
    conv.linebuffer();
    hw_output.tile(x, y, xo, yo, xi, yi, 13,16).reorder(xi,yi,xo,yo);
    hw_output.accelerate({clamped}, xi, xo, {});

    Target coreir_target = get_target_from_environment();
    coreir_target.set_feature(Target::CPlusPlusMangling);
    output.compile_to_lowered_stmt("pipeline_coreir.ir.html", args, HTML, coreir_target);
    output.compile_to_coreir("pipeline_coreir.cpp", args, "pipeline_coreir", coreir_target);
  }


};


int main(int argc, char **argv) {
  MyPipeline p1;
  p1.compile_cpu();

  MyPipeline p2;
  p2.compile_hls();

  MyPipeline p3;
  p3.compile_coreir();

  return 0;
}
