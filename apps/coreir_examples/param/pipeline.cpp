#include "Halide.h"
#include <string.h>

using namespace Halide;
using std::string;

Var x("x"), y("y");
Var xo("xo"), xi("xi"), yi("yi"), yo("yo");

class MyPipeline {
public:
  ImageParam input;
  Param<uint8_t> offset;
  Func clamped;
  Func scaled;
  Func output;
  Func hw_output;
  std::vector<Argument> args;

  MyPipeline() : input(UInt(8), 2, "input"), offset("offset"),
                 clamped("clamped"), scaled("scaled"),
                 output("output"), hw_output("hw_output") {

    // define the algorithm
    clamped(x,y) = input(x,y); 
    scaled(x,y) = clamped(x,y) + offset;
    hw_output(x,y) = cast<uint8_t>(scaled(x,y));
    output(x, y) = hw_output(x, y);

    args.push_back(input);
    args.push_back(offset);

  }

  void compile_cpu() {
    std::cout << "\ncompiling cpu code..." << std::endl;

    output.print_loop_nest();
        
    output.compile_to_lowered_stmt("pipeline_native.ir.html", args, HTML);
    output.compile_to_header("pipeline_native.h", args, "pipeline_native");
    output.compile_to_object("pipeline_native.o", args, "pipeline_native");
  }

  void compile_hls() {
    std::cout << "\ncompiling HLS code..." << std::endl;

    clamped.compute_root();
    hw_output.compute_root();
    hw_output.tile(x, y, xo, yo, xi, yi, 4, 4);
    hw_output.accelerate({clamped}, xi, xo, {});

    hw_output.print_loop_nest();
        
    // Create the target for HLS simulation
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
    hw_output.tile(x, y, xo, yo, xi, yi, 4, 4);
    hw_output.accelerate({clamped}, xi, xo, {});

    hw_output.print_loop_nest();

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
