/*
 This test case is meant to create large designs by creating a chain of convolutions.
 The number of convolutions and size of each convolution is controlled by
 NUM_CONV and WIN_SIZE respectively using #define statments.
 In the app directory, running "make clean all" will create from scratch a CoreIR
 design called "design_prepass.json"
 Using "make graph.png" will create a graphviz file to visualize the design.
 */

#include "Halide.h"
#include <string.h>

using namespace Halide;
using std::string;

Var x("x"), y("y");
Var xo("xo"), xi("xi"), yi("yi"), yo("yo");

// Set these to control how large the design will be
#define NUM_CONV 5
#define WIN_SIZE 3

class MyPipeline {
public:
	ImageParam input;
	Func kernel;
	Func clamped;
	Func conv[NUM_CONV];
	Func conv_shift[NUM_CONV];
	Func output;
	Func hw_output;
	std::vector<Argument> args;
	RDom win;

	MyPipeline() : input(UInt(8), 2, "input"), 
								 kernel("kernel"),
								 output("output"), hw_output("hw_output"),
								 win(0, WIN_SIZE, 0, WIN_SIZE) {
		// Define the blur kernel weight values
		kernel(x,y) = select(x==0&&y==0, 1,
												 x==0&&y==1, 2,
												 x==0&&y==2, 1,
												 x==1&&y==0, 2,
												 x==1&&y==1, 4,
												 x==1&&y==2, 2,
												 x==2&&y==0, 1,
												 x==2&&y==1, 2,
												 x==2&&y==2, 1, 7);

		// define the algorithm
		clamped(x,y) = cast<uint16_t>(input(x,y));

		// convolve however many times
		for (uint conv_i = 0; conv_i < NUM_CONV; ++conv_i) {
			if (conv_i > 0) {
				conv[conv_i](x, y) += conv[conv_i-1](x+win.x, y+win.y) * kernel(win.x, win.y);
			} else {
				conv[conv_i](x, y) += clamped(x+win.x, y+win.y) * kernel(win.x, win.y);
			}

			// normalize (works just for 3x3 kernel)
			conv_shift[conv_i](x,y) = conv[conv_i](x,y) >> 4;
		}

		// define output
		hw_output(x,y) = cast<uint8_t>(conv[NUM_CONV-1](x,y));
		output(x, y) = hw_output(x, y);

		args.push_back(input);
	}

	void compile_cpu() {
		std::cout << "\ncompiling cpu code..." << std::endl;

		output.tile(x, y, xo, yo, xi, yi, 15,15);
		output.fuse(xo, yo, xo).parallel(xo);

		output.vectorize(xi, 8);
		//conv.compute_at(output, xo).vectorize(x, 8);

		//output.print_loop_nest();
		output.compile_to_lowered_stmt("pipeline_native.ir.html", args, HTML);
		output.compile_to_header("pipeline_native.h", args, "pipeline_native");
		output.compile_to_object("pipeline_native.o", args, "pipeline_native");
	}

	void compile_gpu() {
		std::cout << "\ncompiling gpu code..." << std::endl;

		output.compute_root().reorder(x, y).gpu_tile(x, y, 16, 16);
		//conv.compute_root().reorder(x, y).gpu_tile(x, y, 16, 16);
		//conv.compute_at(output, Var::gpu_blocks()).gpu_threads(x, y);
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
		hw_output.tile(x, y, xo, yo, xi, yi, 64-(WIN_SIZE-1)*NUM_CONV,64-(WIN_SIZE-1)*NUM_CONV)
      .reorder(xi, yi, xo, yo);

		//hw_output.unroll(xi, 2);
		hw_output.accelerate({clamped}, xi, xo, {});  // define the inputs and the output
		for (uint conv_i=0; conv_i < NUM_CONV; ++conv_i) {
			conv[conv_i].linebuffer();
			conv[conv_i].unroll(x).unroll(y);
		}

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

		// unroll and linebuffer each convolution
		for (uint conv_i = 0; conv_i < NUM_CONV; ++conv_i) {
			conv[conv_i].update(0).unroll(win.x).unroll(win.y);
			conv[conv_i].linebuffer();
		}

		hw_output.tile(x, y, xo, yo, xi, yi, 64-(WIN_SIZE-1)*NUM_CONV,  64-(WIN_SIZE-1)*NUM_CONV)
      .reorder(xi,yi,xo,yo);

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
