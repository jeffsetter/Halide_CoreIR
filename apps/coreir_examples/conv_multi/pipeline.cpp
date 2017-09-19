#include "Halide.h"
#include <string.h>

using namespace Halide;
using std::string;

Var x("x"), y("y");
Var xo("xo"), xi("xi"), yi("yi"), yo("yo");

uint8_t constants[3][3] = {{11,12,13}, {14,15,16}, {17,18,19}};

class MyPipeline {
public:
    ImageParam input;
    Func kernel;
    Func clamped;
    Func conv1;
    Func output;
    Func hw_output;
    std::vector<Argument> args;

    RDom win;

    MyPipeline() : input(UInt(8), 2, "input"), 
                   kernel("kernel"), conv1("conv1"),
                   output("output"), hw_output("hw_output"),
                   win(0, 3, 0, 3) {
        // Define a 3x3 Gaussian Blur with a repeat-edge boundary condition.
        //float sigma = 1.5f;

        //kernel(x, y) = cast<uint16_t>(exp(-(x*x + y*y)/(2*sigma*sigma)) / (float)(2*M_PI*sigma*sigma));
        //kernel(x, y) = cast<uint16_t>(3);
      //kernel(x,y) = select(x==0&&y==0, 11,
      //                     x==0&&y==1, 12,
      //                     x==0&&y==2, 13,
      //                     x==1&&y==0, 14,
      //                     x==1&&y==1, 15,
      //                     x==1&&y==2, 16,
      //                     x==2&&y==0, 17,
      //                     x==2&&y==1, 18,
      //                     x==2&&y==2, 19, 0);
//      kernel(x,y) = select(x==0, select(y==0, 11, y==1, 12, y==2, 13, 0),
//                           x==1, select(y==0, 14, y==1, 15, y==2, 16, 0),
//                           x==2, select(y==0, 17, y==1, 18, y==2, 19, 0), 0);

      kernel(x,y) = 0;
      kernel(0,0) = 11;      kernel(0,1) = 12;      kernel(0,2) = 13;
      kernel(1,0) = 14;      kernel(1,1) = 15;      kernel(1,2) = 16;
      kernel(2,0) = 17;      kernel(2,1) = 18;      kernel(2,2) = 19;

        // define the algorithm
        clamped(x,y) = input(x,y);

        conv1(x, y) += clamped(x+win.x, y+win.y) * kernel(win.x, win.y);
	//conv1(x, y) += clamped(x+win.x, y+win.y) * constants[win.x][win.y];

        // unroll the reduction only in y
	conv1.update(0).unroll(win.y);

	hw_output(x,y) = cast<uint8_t>(conv1(x,y));
        output(x, y) = hw_output(x, y);


        args.push_back(input);

    }

    void compile_cpu() {
        std::cout << "\ncompiling cpu code..." << std::endl;

        output.tile(x, y, xo, yo, xi, yi, 62,62);
        output.fuse(xo, yo, xo).parallel(xo);

        output.vectorize(xi, 8);
        conv1.compute_at(output, xo).vectorize(x, 8);

        //output.print_loop_nest();
        output.compile_to_lowered_stmt("pipeline_native.ir.html", args, HTML);
        output.compile_to_header("pipeline_native.h", args, "pipeline_native");
        output.compile_to_object("pipeline_native.o", args, "pipeline_native");
    }

    void compile_gpu() {
        std::cout << "\ncompiling gpu code..." << std::endl;

        output.compute_root().reorder(x, y).gpu_tile(x, y, 16, 16);
        conv1.compute_root().reorder(x, y).gpu_tile(x, y, 16, 16);
        //conv1.compute_at(output, Var::gpu_blocks()).gpu_threads(x, y);
        //output.print_loop_nest();

        Target target = get_target_from_environment();
        target.set_feature(Target::CUDA);
        output.compile_to_lowered_stmt("pipeline_cuda.ir.html", args, HTML, target);
        output.compile_to_header("pipeline_cuda.h", args, "pipeline_cuda", target);
        output.compile_to_object("pipeline_cuda.o", args, "pipeline_cuda", target);
    }

    void compile_hls() {
        std::cout << "\ncompiling HLS code..." << std::endl;

        clamped.compute_root(); // prepare the input for the whole image

        // HLS schedule: make a hw pipeline producing 'hw_output', taking
        // inputs of 'clamped', buffering intermediates at (output, xo) loop
        // level
        hw_output.compute_root();
        //hw_output.tile(x, y, xo, yo, xi, yi, 1920, 1080).reorder(xi, yi, xo, yo);
        hw_output.tile(x, y, xo, yo, xi, yi, 62,62).reorder(xi, yi, xo, yo);
        //hw_output.unroll(xi, 2);
        hw_output.accelerate({clamped}, xi, xo, {});  // define the inputs and the output
        conv1.linebuffer();
	//        conv1.unroll(x).unroll(y);

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
	conv1.linebuffer();
	hw_output.tile(x, y, xo, yo, xi, yi, 62,62).reorder(xi,yi,xo,yo);
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

    MyPipeline p4;
    p4.compile_coreir();

    //    MyPipeline p3;
    //p3.compile_gpu();
    return 0;
}
