#include "Halide.h"
#include <stdio.h>

using namespace Halide;

Var x("x"), y("y"), c("c");
Var xo("xo"), yo("yo"), xi("xi"), yi("yi"), tile_index("ti");
Var xio("xio"), yio("yio"), xv("xv"), yp("yp");

int blockSize = 3;
int Ksize = 3;

// k should vary from 0.04 to 0.15
float k = 0.04;
int shiftk = 4; // equiv to k = 0.0625
int threshold = 10;

class MyPipeline {

public:
  ImageParam input;
  //Param<float> k,  threshold;
  std::vector<Argument> args;

  Func padded;
  Func grad_x, grad_y, grad_x_unclamp, grad_y_unclamp;
  Func grad_xx, grad_yy, grad_xy, lxx, lyy, lxy;
  Func lgxx, lgyy, lgxy;
  Func cim;
  Func output, hw_output;
  RDom box, maxWin;

  MyPipeline()
    : input(UInt(8), 2), padded("padded"),
      grad_x("grad_x"), grad_y("grad_y"),
      grad_xx("grad_xx"), grad_yy("grad_yy"), grad_xy("grad_xy"),
      output("output"), hw_output("hw_output"),
      box(-blockSize/2, blockSize, -blockSize/2, blockSize),
      maxWin(-1, 3, -1, 3) {

    //padded = BoundaryConditions::repeat_edge(input);
    padded(x, y) = input(x+3, y+3);

    // sobel filter
    Func padded16;
    padded16(x,y) = cast<int16_t>(padded(x,y));
    grad_x_unclamp(x, y) = cast<int16_t>(-padded16(x-1,y-1) + padded16(x+1,y-1)
                                         -2*padded16(x-1,y) + 2*padded16(x+1,y)
                                         -padded16(x-1,y+1) + padded16(x+1,y+1));
    grad_y_unclamp(x, y) = cast<int16_t>(padded16(x-1,y+1) - padded16(x-1,y-1) +
                                         2*padded16(x,y+1) - 2*padded16(x,y-1) +
                                         padded16(x+1,y+1) - padded16(x+1,y-1));

    grad_x(x, y) = clamp(grad_x_unclamp(x,y), -255, 255);
    grad_y(x, y) = clamp(grad_y_unclamp(x,y), -255, 255);

    // product of gradients
    grad_xx(x, y) = cast<int16_t>(grad_x(x,y)) * cast<int16_t>(grad_x(x,y));
    grad_yy(x, y) = cast<int16_t>(grad_y(x,y)) * cast<int16_t>(grad_y(x,y));
    grad_xy(x, y) = cast<int16_t>(grad_x(x,y)) * cast<int16_t>(grad_y(x,y));

    // shift gradients
    lxx(x, y) = grad_xx(x, y) >> 7;
    lyy(x, y) = grad_yy(x, y) >> 7;
    lxy(x, y) = grad_xy(x, y) >> 7;

    // box filter (i.e. windowed sum)
    lgxx(x, y) += lxx(x+box.x, y+box.y);
    lgyy(x, y) += lyy(x+box.x, y+box.y);
    lgxy(x, y) += lxy(x+box.x, y+box.y);

    Expr lgxx8 = lgxx(x,y) >> 6;
    Expr lgyy8 = lgyy(x,y) >> 6;
    Expr lgxy8 = lgxy(x,y) >> 6;

    // calculate Cim
//        int scale = (1 << (Ksize-1)) * blockSize;
//        Expr lgx = cast<float>(grad_gx(x, y) / scale / scale);
//        Expr lgy = cast<float>(grad_gy(x, y) / scale / scale);
//        Expr lgxy = cast<float>(grad_gxy(x, y) / scale / scale);

    // scale==12, so dividing by 144
    // approx~ 1>>7==divide by 128
    Expr det = lgxx8*lgyy8 - lgxy8*lgxy8;
    Expr trace = lgxx8 + lgyy8;
    cim(x, y) = det - (trace*trace >> shiftk);

    // Perform non-maximal suppression
    Expr is_max = cim(x, y) > cim(x-1, y-1) && cim(x, y) > cim(x, y-1) &&
      cim(x, y) > cim(x+1, y-1) && cim(x, y) > cim(x-1, y) &&
      cim(x, y) > cim(x+1, y) && cim(x, y) > cim(x-1, y+1) &&
      cim(x, y) > cim(x, y+1) && cim(x, y) > cim(x+1, y+1);
    //hw_output(x, y) = select( is_max && (cim(x, y) >= threshold), cast<uint8_t>(255), 0);
    hw_output(x, y) = select( is_max, cast<uint8_t>(cim(x,y)), 0);
    //hw_output(x, y) = cast<int8_t>(cim(x, y) >> 8);
    //hw_output(x, y) = cast<int8_t>(lgxx(x,y) >> 8);
    output(x, y) = hw_output(x, y);

    // Arguments
    //args = {input, k, threshold};
    args = {input};
  }

  void compile_cpu() {
    std::cout << "\ncompiling cpu code..." << std::endl;

//        output.tile(x, y, xo, yo, xi, yi, 52,52);
//        grad_x.compute_at(output, xo).vectorize(x, 8);
//        grad_y.compute_at(output, xo).vectorize(x, 8);
//        grad_xx.compute_at(output, xo).vectorize(x, 4);
//        grad_yy.compute_at(output, xo).vectorize(x, 4);
//        grad_xy.compute_at(output, xo).vectorize(x, 4);
//        grad_gx.compute_at(output, xo).vectorize(x, 4);
//        grad_gy.compute_at(output, xo).vectorize(x, 4);
//        grad_gxy.compute_at(output, xo).vectorize(x, 4);
//        cim.compute_at(output, xo).vectorize(x, 4);
//
//        grad_gx.update(0).unroll(box.x).unroll(box.y);
//        grad_gy.update(0).unroll(box.x).unroll(box.y);
//        grad_gxy.update(0).unroll(box.x).unroll(box.y);
//
//        output.fuse(xo, yo, xo).parallel(xo).vectorize(xi, 4);

    //output.print_loop_nest();
    //output.compile_to_lowered_stmt("pipeline_native.ir.html", args, HTML);
    output.compile_to_header("pipeline_native.h", args, "pipeline_native");
    output.compile_to_object("pipeline_native.o", args, "pipeline_native");
  }

  void compile_gpu() {
    std::cout << "\ncompiling gpu code..." << std::endl;

    //grad_gx.update(0).unroll(box.x).unroll(box.y);
    lgyy.update(0).unroll(box.x).unroll(box.y);
    //grad_gxy.update(0).unroll(box.x).unroll(box.y);
    output.compute_root().gpu_tile(x, y, 32, 16);
    cim.compute_root().gpu_tile(x, y, 32, 16);

    //conv1.compute_at(output, Var::gpu_blocks()).gpu_threads(x, y, c);

    //output.print_loop_nest();

    Target target = get_target_from_environment();
    target.set_feature(Target::CUDA);
    output.compile_to_lowered_stmt("pipeline_cuda.ir.html", args, HTML, target);
    output.compile_to_header("pipeline_cuda.h", args, "pipeline_cuda", target);
    output.compile_to_object("pipeline_cuda.o", args, "pipeline_cuda", target);
  }

  void compile_hls() {
    std::cout << "\ncompiling HLS code..." << std::endl;
//
//        output.tile(x, y, xo, yo, xi, yi, 52,52);
//        padded.compute_at(output, xo);
//        hw_output.compute_at(output, xo);
//
//        hw_output.tile(x, y, xo, yo, xi, yi, 52,52);
//        //hw_output.unroll(xi, 2);
        hw_output.accelerate({padded}, xi, xo);
//
//        grad_x.linebuffer().unroll(x);
//        grad_y.linebuffer().unroll(x);
//        grad_xx.linebuffer().unroll(x);
//        grad_yy.linebuffer().unroll(x);
//        grad_xy.linebuffer().unroll(x);
//        grad_gx.linebuffer().unroll(x);
//        grad_gx.update(0).unroll(x);
//        grad_gy.linebuffer().unroll(x);
//        grad_gy.update(0).unroll(x);
//        grad_gxy.linebuffer().unroll(x);
//        grad_gxy.update(0).unroll(x);
//        cim.linebuffer().unroll(x);
//
//        grad_gx.update(0).unroll(box.x).unroll(box.y);
//        grad_gy.update(0).unroll(box.x).unroll(box.y);
//        grad_gxy.update(0).unroll(box.x).unroll(box.y);

    //output.print_loop_nest();
    // Create the target for HLS simulation
    Target hls_target = get_target_from_environment();
    hls_target.set_feature(Target::CPlusPlusMangling);
    output.compile_to_lowered_stmt("pipeline_hls.ir.html", args, HTML, hls_target);
    output.compile_to_hls("pipeline_hls.cpp", args, "pipeline_hls", hls_target);
    output.compile_to_header("pipeline_hls.h", args, "pipeline_hls", hls_target);
  }


  void compile_coreir() {
    std::cout << "\ncompiling CoreIR code..." << std::endl;

    output.tile(x, y, xo, yo, xi, yi, 58,58);
    padded.compute_at(output, xo);
    hw_output.compute_at(output, xo);

    hw_output.tile(x, y, xo, yo, xi, yi, 58,58);
    //hw_output.unroll(xi, 2);
    hw_output.accelerate({padded}, xi, xo);

    grad_x.linebuffer().unroll(x);
    grad_y.linebuffer().unroll(x);
    lxx.linebuffer().unroll(x);
    lyy.linebuffer().unroll(x);
    lxy.linebuffer().unroll(x);
    //lgxx.linebuffer().unroll(x);
    //      grad_gx.update(0).unroll(x);
    //lgyy.linebuffer().unroll(x);
    //        grad_gy.update(0).unroll(x);
    //lgxy.linebuffer().unroll(x);
    //        grad_gxy.update(0).unroll(x);
    cim.linebuffer().unroll(x);

    lgxx.update(0).unroll(box.x).unroll(box.y).unroll(x);
    lgyy.update(0).unroll(box.x).unroll(box.y).unroll(x);
    lgxy.update(0).unroll(box.x).unroll(box.y).unroll(x);

    //output.print_loop_nest();
    Target coreir_target = get_target_from_environment();
    coreir_target.set_feature(Target::CPlusPlusMangling);
    coreir_target.set_feature(Target::CoreIRValid);
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
