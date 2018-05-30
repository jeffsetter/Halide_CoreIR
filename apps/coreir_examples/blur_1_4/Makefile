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

out.png: run input.png
	./run input.png

clean: clean_commonfiles
	rm -f coreir_input.txt coreir_output.txt out.pgm
