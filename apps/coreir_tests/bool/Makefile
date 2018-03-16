#### Halide flags
HALIDE_BIN_PATH := ../../..
HALIDE_SRC_PATH := ../../..
include ../../support/Makefile.inc

#### HLS flags
include ../hls_support/Makefile.inc

.PHONY: all
all: graph.png out.png

pipeline: pipeline.cpp
	$(CXX) $(CXXFLAGS) -Wall -g $^ $(LIB_HALIDE) -o $@ $(LDFLAGS) -ltinfo

pipeline_hls.cpp pipeline_native.o pipeline_cuda.o hls_target.cpp: pipeline
	HL_DEBUG_CODEGEN=0 ./pipeline

run: run.cpp pipeline_hls.cpp pipeline_native.o hls_target.cpp
	$(CXX) $(CXXFLAGS) -O1 -DNDEBUG $(HLS_CXXFLAGS) -g -Wall -Werror $^ -lpthread  $(LIB_HALIDE) -ldl $(PNGFLAGS) -o $@ $(LDFLAGS)

out.png: run
	./run input.png

design_prepass.json design_top.json design_top.txt: pipeline
	HL_DEBUG_CODEGEN=0 ./pipeline
graph.png: design_top.txt
	dot -Tpng design_top.txt > graph.png

clean:
	rm -f pipeline run
	rm -f *.html
	rm -f pipeline_native.h pipeline_native.o
	rm -f pipeline_hls.h pipeline_hls.cpp hls_target.h hls_target.cpp
	rm -f pipeline_coreir.cpp pipeline_coreir.h
	rm -f coreir_target.h coreir_target.cpp *.json input_unique.pgm
	rm -f *.txt out.pgm out.png graph.png
