#### Halide flags
HALIDE_BIN_PATH := ../../..
HALIDE_SRC_PATH := ../../..
include ../../support/Makefile.inc

#### HLS flags
include ../hls_support/Makefile.inc
HLS_LOG = vivado_hls.log


#### Common CoreIR targets
#### try make {design_top.json, out.png, graph.png, test, update_golden}
include ../hls_support/coreir.mk

.PHONY: all
all: out.png

input.png: gen_testimage
	./gen_testimage 10 10 b input.png
input_unique.pgm: gen_testimage
	./gen_testimage 10 10 b input_unique.pgm

clean: clean_commonfiles
	rm -f coreir_input.txt coreir_output.txt out.pgm
