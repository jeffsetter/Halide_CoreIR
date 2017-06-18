#include "Halide.h"
#include <stdio.h>

using namespace Halide;

Var x("x"), y("y");
Var xo("xo"), yo("yo"), xi("xi"), yi("yi");

class MyPipeline {
public:
    ImageParam in;
    Func modified;
    Func output, hw_output;
    std::vector<Argument> args;

    MyPipeline()
      : in(UInt(8), 2),
	output("output"), hw_output("hw_output")
    {
        // Pointwise operations
      modified(x, y) = in(x, y) *2;

        hw_output(x, y) = modified(x, y);

        output(x, y) = hw_output(x, y);

        // Arguments
        args = {in};
    }

    void compile_cpu() {
        std::cout << "\ncompiling cpu code..." << std::endl;
        //kernel.compute_root();

        output.tile(x, y, xo, yo, xi, yi, 64, 64)
            .vectorize(xi, 8)
            .fuse(xo, yo, xo).parallel(xo);
        //blur_y.compute_at(output, xo).vectorize(x, 8).unroll(c);

        //output.print_loop_nest();

        output.compile_to_lowered_stmt("pipeline_native.ir.html", args, HTML);
        output.compile_to_header("pipeline_native.h", args, "pipeline_native");
        output.compile_to_object("pipeline_native.o", args, "pipeline_native");
    }

    void compile_gpu() {
        std::cout << "\ncompiling gpu code..." << std::endl;

        output.gpu_tile(x, y, 32, 16);

        //output.print_loop_nest();

        Target target = get_target_from_environment();
        target.set_feature(Target::CUDA);
        output.compile_to_lowered_stmt("pipeline_cuda.ir.html", args, HTML, target);
        output.compile_to_header("pipeline_cuda.h", args, "pipeline_cuda", target);
        output.compile_to_object("pipeline_cuda.o", args, "pipeline_cuda", target);
    }

    void compile_hls() {
        std::cout << "\ncompiling HLS code..." << std::endl;
        //kernel.compute_root();
	output.tile(x, y, xo, yo, xi, yi, 64, 64);

	//        hw_output.compute_at(output, xo)
	//                 .tile(x, y, xo, yo, xi, yi, 640, 480);
	//        hw_output.unroll(xi, 8);

        hw_output.accelerate({in}, xi, xo);

        //blur_y.linebuffer().unroll(x).unroll(y);

        //output.print_loop_nest();
        // Create the target for HLS simulation
        Target hls_target = get_target_from_environment();
        hls_target.set_feature(Target::CPlusPlusMangling);
        output.compile_to_lowered_stmt("pipeline_hls.ir.html", args, HTML, hls_target);
        output.compile_to_hls("pipeline_hls.cpp", args, "pipeline_hls", hls_target);
        output.compile_to_header("pipeline_hls.h", args, "pipeline_hls", hls_target);

        std::vector<Target::Feature> features({Target::Zynq});
        Target target(Target::Linux, Target::ARM, 32, features);
        output.compile_to_zynq_c("pipeline_zynq.c", args, "pipeline_zynq", target);
        output.compile_to_header("pipeline_zynq.h", args, "pipeline_zynq", target);

        output.vectorize(xi, 16);
        output.fuse(xo, yo, xo).parallel(xo);

        output.compile_to_object("pipeline_zynq.o", args, "pipeline_zynq", target);
        output.compile_to_lowered_stmt("pipeline_zynq.ir.html", args, HTML, target);
    }

  void compile_coreir() {
        std::cout << "\ncompiling CoreIR code..." << std::endl;
        //kernel.compute_root();
	output.tile(x, y, xo, yo, xi, yi, 64, 64);
	hw_output.accelerate({in}, xi, xo);

        Target coreir_target = get_target_from_environment();
        coreir_target.set_feature(Target::CPlusPlusMangling);
        output.compile_to_lowered_stmt("pipeline_coreir.ir.html", args, HTML, coreir_target);
        output.compile_to_coreir("pipeline_coreir.cpp", args, "pipeline_coreir", coreir_target);
    }
};

int main(int argc, char **argv) {
    MyPipeline p1;
    p1.compile_cpu();

    MyPipeline p4;
    p4.compile_coreir();

    MyPipeline p2;
    p2.compile_hls();
// 
//     MyPipeline p3;
//     p3.compile_gpu();
//     return 0;
}
