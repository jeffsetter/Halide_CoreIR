#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "halide_image.h"
#include "halide_image_io.h"
#include "pipeline_native.h"
#include "pipeline_hls.h"

#include "coreir.h"
#include "coreir/passes/transform/rungenerators.h"
#include "coreir/simulator/interpreter.h"
#include "coreir/libs/commonlib.h"

#include <iostream>
#include <fstream>

using namespace Halide::Tools;
using namespace CoreIR;
using namespace std;

int main(int argc, char **argv) {
	Image<uint16_t> in(64, 64, 1);

	Image<int16_t> out_native(in.width(), in.height(), in.channels());
	Image<int16_t> out_hls(in.width(), in.height(), in.channels());
	Image<int16_t> out_coreir(in.width(), in.height(), in.channels());
	in = load_image(argv[1]);

	printf("start.\n");

	pipeline_native(in, out_native);
	save_image(out_native, "out.png");
	save_image(out_native, "out.pgm");

	printf("finished running native code\n");

	pipeline_hls(in, out_hls);

	printf("finished running HLS code\n");

	bool success = true;
	for (int y = 0; y < out_native.height(); y++) {
		for (int x = 0; x < out_native.width(); x++) {
			for (int c = 0; c < out_native.channels(); c++) {
				if (out_native(x, y, c) != out_hls(x, y, c)) {
					printf("out_native(%d, %d, %d) = %d, but out_c(%d, %d, %d) = %d\n",
								 x, y, c, out_native(x, y, c),
								 x, y, c, out_hls(x, y, c));
					success = false;
				}
			}
		}
	}

	// New context for coreir test
	Context* c = newContext();
	Namespace* g = c->getGlobal();

	CoreIRLoadLibrary_commonlib(c);
	if (!loadFromFile(c,"./design_prepass.json")) {
		cout << "Could not Load from json!!" << endl;
		c->die();
	}

	c->runPasses({"rungenerators", "flattentypes", "flatten", "wireclocks-coreir"});


	Module* m = g->getModule("DesignTop");
	assert(m != nullptr);
	SimulatorState state(m);

	state.setValue("self.in_arg_1_0_0", BitVector(16));
	state.resetCircuit();
	//state.setClock("self.clk", 0, 1);

	std::ofstream instream;
	std::ofstream outstream;
	instream.open("coreir_input.txt");
	outstream.open("coreir_output.txt");

	for (int y = 0; y < in.height(); y++) {
		for (int x = 0; x < in.width(); x++) {
			for (int c = 0; c < in.channels(); c++) {
				// set input value
				state.setValue("self.in_arg_1_0_0", BitVector(16, in(x,y,c)));
				instream << state.getBitVec("self.in_arg_1_0_0") << endl;

				// propogate to all wires
				state.exeCombinational();
            
				// read output wire
				outstream << state.getBitVec("self.out_0_0") << endl;
				out_coreir(x,y,c) = state.getBitVec("self.out_0_0").to_type<int16_t>();
				if (y>=0 && out_native(x, y, c) != out_coreir(x, y, c)) {
					printf("in=%d out_native(%d, %d, %d) = %d, but out_coreir(%d, %d, %d) = %d\n",
								 out_coreir(x,y,c) = state.getBitVec("self.in_arg_1_0_0").to_type<uint16_t>(),
								 x, y, c, out_native(x, y, c),
								 x, y, c, out_coreir(x, y, c));
					success = false;
				}

				// give another rising edge (execute seq)
				state.exeSequential();

			}
		}
	}

	instream.close();
	outstream.close();

	deleteContext(c);
	printf("finished running CoreIR code\n");

	if (success) {
		printf("Succeeded!\n");
		return 0;
	} else {
		printf("Failed!\n");
		return 1;
	}

}
