#include "Halide.h"
#include <stdio.h>

using namespace Halide;

Var x("x"), y("y"), c("c");
Var xo("xo"), yo("yo"), xi("xi"), yi("yi");

uint8_t phase = 0;

class MyPipeline {
 public:
  ImageParam input;
  std::vector<Argument> args;
  //Param<uint8_t> phase; // One bit each for x and y phase
  Func padded;
  Func red, green, blue;
  Func demosaic, lowpass_x, lowpass_y, downsample;
  Func output, hw_output;
  Func neswNeighbors, diagNeighbors, vNeighbors, hNeighbors;

  MyPipeline()
      : input(UInt(8), 2), padded("padded"),
        demosaic("demosaic"), lowpass_x("lowpass_x"),
        lowpass_y("lowpass_y"), downsample("downsample"),
        output("output"), hw_output("hw_output")
  {
    //padded = BoundaryConditions::constant_exterior(input, 0);
    //padded(x, y) = input(x+240, y+60);
    //padded(x, y) = input(x+200, y+40);
    padded(x,y) = input(x+1,y+1);

    // Now demosaic and try to get RGB back
    Func padded16;
    padded16(x, y) = cast<uint16_t>(padded(x, y));
    neswNeighbors(x, y) = cast<uint8_t>((padded16(x-1, y) + padded16(x+1, y) +
                                         padded16(x, y-1) + padded16(x, y+1))/4);
    diagNeighbors(x, y) = cast<uint8_t>((padded16(x-1, y-1) + padded16(x+1, y-1) +
                                         padded16(x-1, y+1) + padded16(x+1, y+1))/4);

    vNeighbors(x, y) = cast<uint8_t>((padded16(x, y-1) + padded16(x, y+1))/2);
    hNeighbors(x, y) = cast<uint8_t>((padded16(x-1, y) + padded16(x+1, y))/2);

    green(x, y) = select((y % 2) == (phase / 2),
                         select((x % 2) == (phase % 2), neswNeighbors(x, y), padded(x, y)), // First row, RG
                         select((x % 2) == (phase % 2), padded(x, y), neswNeighbors(x, y))); // Second row, GB

    red(x, y) = select((y % 2) == (phase / 2),
                       select((x % 2) == (phase % 2), padded(x, y), hNeighbors(x, y)), // First row, RG
                       select((x % 2) == (phase % 2), vNeighbors(x, y), diagNeighbors(x, y))); // Second row, GB

    blue(x, y) = select((y % 2) == (phase / 2),
                        select((x % 2) == (phase % 2), diagNeighbors(x, y), vNeighbors(x, y)), // First row, RG
                        select((x % 2) == (phase % 2), hNeighbors(x, y), padded(x, y))); // Second row, GB

    demosaic(x,y,c) = cast<uint8_t>(select(c == 0, red(x, y),
                                             c == 1, green(x, y),
                                             blue(x, y)));

    // common constraints
    demosaic.bound(c, 0, 3);
    // We can generate slightly better code if we know the output is a whole number of tiles.
    //hw_output.bound(x, 0, 32).bound(y, 0, 32);

    // Arguments
    args = {input};
  }

  void compile_cpu() {
    std::cout << "\ncompiling cpu code..." << std::endl;

    demosaic.reorder(c,x,y).compute_root();

    //output.print_loop_nest();
    demosaic.compile_to_lowered_stmt("pipeline_native.ir.html", args, HTML);
    demosaic.compile_to_header("pipeline_native.h", args, "pipeline_native");
    demosaic.compile_to_object("pipeline_native.o", args, "pipeline_native");
  }

  void compile_hls() {
    std::cout << "\ncompiling HLS code..." << std::endl;

    padded.compute_root();
    demosaic.compute_root();
    demosaic.tile(x, y, xo, yo, xi, yi, 62,62);
    demosaic.reorder(c, xi, yi, xo, yo);

    demosaic.accelerate({padded}, xi, xo);
    demosaic.unroll(c);

    //output.print_loop_nest();
    // Create the target for HLS simulation
    Target hls_target = get_target_from_environment();
    hls_target.set_feature(Target::CPlusPlusMangling);
    demosaic.compile_to_lowered_stmt("pipeline_hls.ir.html", args, HTML, hls_target);
    demosaic.compile_to_hls("pipeline_hls.cpp", args, "pipeline_hls", hls_target);
    demosaic.compile_to_header("pipeline_hls.h", args, "pipeline_hls", hls_target);

    std::vector<Target::Feature> features({Target::Zynq});
    Target target(Target::Linux, Target::ARM, 32, features);
    demosaic.compile_to_zynq_c("pipeline_zynq.c", args, "pipeline_zynq", target);
    demosaic.compile_to_header("pipeline_zynq.h", args, "pipeline_zynq", target);
    demosaic.compile_to_lowered_stmt("pipeline_zynq.ir.html", args, HTML, target);
  }

  void compile_coreir() {
    std::cout << "\ncompiling COREIR code..." << std::endl;

    padded.compute_root();
    demosaic.compute_root();
    demosaic.tile(x, y, xo, yo, xi, yi, 62,62);
    demosaic.reorder(c, xi, yi, xo, yo);

    demosaic.accelerate({padded}, xi, xo);
    demosaic.unroll(c);

    //output.print_loop_nest();
    // Create the target for COREIR simulation
    Target coreir_target = get_target_from_environment();
    coreir_target.set_feature(Target::CoreIRValid);
    demosaic.compile_to_lowered_stmt("pipeline_coreir.ir.html", args, HTML, coreir_target);
    demosaic.compile_to_coreir("pipeline_coreir.cpp", args, "pipeline_coreir", coreir_target);
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
