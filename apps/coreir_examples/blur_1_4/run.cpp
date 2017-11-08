#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "halide_image.h"
#include "halide_image_io.h"
#include "pipeline_native.h"
#include "pipeline_hls.h"

using namespace Halide::Tools;

int main(int argc, char **argv) {
  Image<uint8_t> in(10, 16, 1);

    Image<uint8_t> out_native(in.width(), in.height(), in.channels());
    Image<uint8_t> out_hls(in.width(), in.height(), in.channels());
    in = load_image(argv[1]);

    printf("start.\n");

    pipeline_native(in, out_native);
    save_image(out_native, "out.png");
    save_image(out_native, "out.pgm");

    printf("finish running native code\n");

    pipeline_hls(in, out_hls);

    printf("finish running HLS code\n");

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

    if (success) {
        printf("Successed!\n");
        return 0;
    } else {
        printf("Failed!\n");
        return 1;
    }

}
