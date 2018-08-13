#include "Halide.h"
#include <string.h>

using namespace Halide;
using std::string;

Var x("x"), y("y");
Var xo("xo"), xi("xi"), yi("yi"), yo("yo");

class MyPipeline {
public:
  ImageParam input;
  Func clamped;
  Func logic, threshold, ceiling, big;
  Func modified, modified16, output;
  Func hw_output;
  std::vector<Argument> args;

  MyPipeline() : input(UInt(8), 2, "input"),
                 output("output"), hw_output("hw_output") {

    // define the algorithm
    //clamped = BoundaryConditions::repeat_edge(input);
    clamped(x,y) = input(x, y);
    threshold(x, y) = clamped(x, y) > 10;
    ceiling(x, y) = clamped(x, y) < 20;
    big(x,y) = clamped(x,y) >= 50;
    logic(x,y) = !((threshold(x,y) & ceiling(x,y)) | (big(x,y) ^ ceiling(x,y)));
    modified(x,y) = select(logic(x,y), logic(x,y), big(x,y));
    modified16(x,y) = select(modified(x,y), cast<uint8_t>(1), 0);

    hw_output(x,y) = modified16(x,y);
    output(x, y) = hw_output(x, y);

    args.push_back(input);
  }

  void compile_cpu() {
    std::cout << "\ncompiling cpu code..." << std::endl;

    output.tile(x, y, xo, yo, xi, yi, 10,10);
    output.vectorize(xi, 8);

    //output.print_loop_nest();
    output.compile_to_lowered_stmt("pipeline_native.ir.html", args, HTML);
    output.compile_to_header("pipeline_native.h", args, "pipeline_native");
    output.compile_to_object("pipeline_native.o", args, "pipeline_native");
  }

  void compile_hls() {
    std::cout << "\ncompiling HLS code..." << std::endl;

    clamped.compute_root();
    hw_output.compute_root();

    hw_output.tile(x,y, xo, yo, xi,yi, 10,10);
    //hw_output.unroll(xi, 2);
    hw_output.accelerate({clamped}, xi, xo);  // define the inputs and the output
    //        conv1.unroll(x).unroll(y);

    //output.print_loop_nest();
    Target hls_target = get_target_from_environment();
    hls_target.set_feature(Target::CPlusPlusMangling);
    output.compile_to_lowered_stmt("pipeline_hls.ir.html", args, HTML, hls_target);
    output.compile_to_hls("pipeline_hls.cpp", args, "pipeline_hls", hls_target);
    output.compile_to_header("pipeline_hls.h", args, "pipeline_hls", hls_target);
  }

};

class CoreIRPipeline {
public:
  ImageParam input;
  Func clamped;
  Func logic, threshold, ceiling, big;
  Func modified, output;
  Func hw_output;
  std::vector<Argument> args;

  CoreIRPipeline() : input(UInt(8), 2, "input"),
                 output("output"), hw_output("hw_output") {

    // define the algorithm
    //clamped = BoundaryConditions::repeat_edge(input);
    clamped(x,y) = input(x, y);
    threshold(x, y) = clamped(x, y) > 10;
    ceiling(x, y) = clamped(x, y) < 20;
    big(x,y) = clamped(x,y) >= 50;
    logic(x,y) = !((threshold(x,y) & ceiling(x,y)) | (big(x,y) ^ ceiling(x,y)));
    modified(x,y) = select(logic(x,y), logic(x,y), big(x,y));

    hw_output(x,y) = modified(x,y);
    output(x, y) = hw_output(x, y);

    args.push_back(input);
  }

  void compile_coreir() {
    std::cout << "\ncompiling CoreIR code..." << std::endl;
    clamped.compute_root();
    hw_output.compute_root();
    hw_output.tile(x, y, xo, yo, xi, yi, 10,10);
    hw_output.accelerate({clamped}, xi, xo);


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

  CoreIRPipeline p4;
  p4.compile_coreir();

  //    MyPipeline p3;
  //p3.compile_gpu();
  return 0;
}
