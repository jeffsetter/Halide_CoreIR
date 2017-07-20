#### Halide flags
HALIDE_BIN_PATH := ../../..
HALIDE_SRC_PATH := ../../..
include ../../support/Makefile.inc

#### HLS flags
include ../hls_support/Makefile.inc
HLS_LOG = vivado_hls.log

#### COREIR flags
COREIR_DIR ?= ../../../../coreir
COREIR_LIBPATH = -L$(COREIR_DIR)/lib -Wl,-rpath,$(COREIR_DIR)/lib
COREIR_LIBS = -lcoreir-stdlib -lcoreir-cgralib -lcoreir-passes -lcoreir

.PHONY: all run_hls
all: out.png
run_hls: $(HLS_LOG)


pipeline: pipeline.cpp
	$(CXX) $(CXXFLAGS) -Wall -g $^ $(LIB_HALIDE) $(COREIR_LIBPATH) -o $@ $(LDFLAGS) -ltinfo $(COREIR_LIBS)

pipeline_hls.cpp pipeline_native.o pipeline_cuda.o: pipeline
	HL_DEBUG_CODEGEN=0 ./pipeline

run: run.cpp pipeline_hls.cpp hls_target.cpp pipeline_native.o
	$(CXX) $(CXXFLAGS) -O1 -DNDEBUG $(HLS_CXXFLAGS) -g -Wall -Werror $^ -lpthread -ldl -o $@ $(PNGFLAGS)


run_cuda: pipeline_native.o pipeline_cuda.o run_cuda.cpp
	$(CXX) -O3 $(CXXFLAGS) -Wall -Werror $^ -lpthread -ldl -o $@  $(PNGFLAGS) `pkg-config --libs opencv`

out.png: run
	./run input.png

design_top.json: pipeline
	HL_DEBUG_CODEGEN=0 ./pipeline
graph.png: design_top.json
	dot -Tpng design_top.txt > graph.png
$(HLS_LOG): ../hls_support/run_hls.tcl pipeline_hls.cpp run.cpp
	RUN_PATH=$(realpath ./) \
	RUN_ARGS= \
	vivado_hls -f $< -l $(HLS_LOG)

out_cuda.png: run_cuda
	CUDA_LAUNCH_BLOCKING=1 HL_NUM_THREADS=4 ./run_cuda ../../images/benchmark_8mp_gray.png

clean:
	rm -f pipeline run
	rm -f *.html
	rm -f pipeline_native.h pipeline_native.o
	rm -f pipeline_hls.h pipeline_hls.cpp hls_target.h hls_target.cpp
	rm -f pipeline_coreir.cpp pipeline_coreir.h
	rm -f coreir_target.h coreir_target.cpp design_top.json design_target.json
	rm -f design_top.txt out.png graph.png
