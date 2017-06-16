#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "halide_image.h"
#include "halide_image_io.h"
#include "pipeline_native.h"
#include "pipeline_hls.h"

using namespace Halide::Tools;

const unsigned char gaussian2d[5][5] = {
    {1,     3,     6,     3,     1},
    {3,    15,    25,    15,     3},
    {6,    25,    44,    25,     6},
    {3,    15,    25,    15,     3},
    {1,     3,     6,     3,     1}
};


int main(int argc, char **argv) {
    Image<uint8_t> in(64, 64, 1);
    Image<uint8_t> weight(5,5);

    Image<uint8_t> out_native(in.width(), in.height(), in.channels());
    Image<uint8_t> out_hls(in.width(), in.height(), in.channels());

//    for (int y = 0; y < in.height(); y++) {
//        for (int x = 0; x < in.width(); x++) {
//	    for (int c = 0; c < in.channels(); c++) {
//	        in(x, y, c) = (uint8_t) x+y;   //rand();
//	    }
//        }
//    }

    in = load_image(argv[1]);

    for (int y = 0; y < weight.height(); y++)
      for (int x = 0; x < weight.width(); x++)
            weight(x, y) = gaussian2d[y][x];

    printf("start.\n");

    //    pipeline_native(in, weight, 0, out_native);
    pipeline_native(in, 0, out_native);
    save_image(out_native, "out.png");

    printf("finish running native code\n");

    //    pipeline_hls(in, weight, 0, out_hls);
    pipeline_hls(in, 0, out_hls);

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
