#### Halide flags
HALIDE_BIN_PATH := ../../..
HALIDE_SRC_PATH := ../../..
include ../../support/Makefile.inc

#### HLS flags
include ../hls_support/Makefile.inc
HLS_LOG = vivado_hls.log

.PHONY: all run_hls
all: out.png
run_hls: $(HLS_LOG)


pipeline: pipeline.cpp
	$(CXX) $(CXXFLAGS) -Wall -g $^ $(LIB_HALIDE) -o $@ $(LDFLAGS) -ltinfo

pipeline_hls.cpp pipeline_native.o pipeline_cuda.o hls_target.cpp: pipeline
	HL_DEBUG_CODEGEN=0 ./pipeline

run: run.cpp pipeline_hls.cpp pipeline_native.o hls_target.cpp
	$(CXX) $(CXXFLAGS) -O1 -DNDEBUG $(HLS_CXXFLAGS) -g -Wall -Werror $^ -lpthread  $(LIB_HALIDE) -ldl $(PNGFLAGS) -o $@ $(LDFLAGS)

out.png: run input_unique.pgm
	./run input.png

gen_testimage:
	$(MAKE) -C ../tools/gen_testimage gen_testimage
	cp ../tools/gen_testimage/gen_testimage .

input_unique.pgm: gen_testimage
	./gen_testimage 10 10 b input_unique.pgm
	./gen_testimage 10 10 b input.png
input_ones.pgm: gen_testimage
	./gen_testimage 10 10 a input_ones.pgm
	./gen_testimage 10 10 a input.png


design_top.txt design_top.json: pipeline
	HL_DEBUG_CODEGEN=0 ./pipeline

graph.png: design_top.txt
	dot -Tpng design_top.txt > graph.png
clean:
	rm -f pipeline run
	rm -f *.html
	rm -f pipeline_native.h pipeline_native.o
	rm -f pipeline_hls.h pipeline_hls.cpp hls_target.h hls_target.cpp
	rm -f pipeline_coreir.cpp pipeline_coreir.h
	rm -f coreir_target.h coreir_target.cpp design_top.json design_*.json
	rm -f design_top.txt graph.png gen_testimage
	rm -f input* out.png out.pgm
