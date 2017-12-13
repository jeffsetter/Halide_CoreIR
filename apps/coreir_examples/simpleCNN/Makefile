#### Halide flags
HALIDE_BIN_PATH := ../../..
HALIDE_SRC_PATH := ../../..
include ../../support/Makefile.inc

#### HLS flags
include ../hls_support/Makefile.inc

#### end of HLS flags

all: test

pipeline: pipeline.cpp
	$(CXX) $(CXXFLAGS) -Wall -g $^ $(LIB_HALIDE) -o $@ $(LDFLAGS) -ltinfo

pipeline_hls.cpp pipeline_native.o: pipeline
	HL_DEBUG_CODEGEN=0 ./pipeline

design_top.json design_top.txt: pipeline
	HL_DEBUG_CODEGEN=0 ./pipeline
graph.png: design_top.txt
	dot -Tpng design_top.txt > graph.png


run: run.cpp pipeline_native.o pipeline_hls.cpp hls_target.cpp
	$(CXX) $(CXXFLAGS) -O1 -DNDEBUG $(HLS_CXXFLAGS) -g -Wall -Werror $^ -lpthread -ldl $(PNGFLAGS) -o $@

test: run
	./run
	touch $@

clean:
	rm -f pipeline run run_zynq run_cuda
	rm -f pipeline_*.cpp pipeline_*.h pipeline_*.c *.o
	rm -f hls_target.h hls_target.cpp coreir_target.cpp coreir_target.h
	rm -f *.html
	rm -f *.json *.txt *.png
