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

pipeline_hls.cpp pipeline_native.o pipeline_zynq.o pipeline_cuda.o: pipeline
	HL_DEBUG_CODEGEN=0 ./pipeline

run: run.cpp pipeline_hls.cpp hls_target.cpp pipeline_native.o
	$(CXX) $(CXXFLAGS) -O1 -DNDEBUG $(HLS_CXXFLAGS) -g -Wall -Werror $^ -lpthread -ldl $(PNGFLAGS) -o $@

run_cuda: pipeline_native.o pipeline_cuda.o run_cuda.cpp
	$(CXX) -O3 $(CXXFLAGS) -Wall -Werror $^ -lpthread -ldl -o $@  $(PNGFLAGS)

out.png: run
	./run ../../images/gray.png

out_cuda.png: run_cuda
	CUDA_LAUNCH_BLOCKING=1 HL_NUM_THREADS=4 ./run_cuda ../../images/benchmark_8mp_gray.png

design_top.json: pipeline
	HL_DEBUG_CODEGEN=0 ./pipeline

$(HLS_LOG): ../hls_support/run_hls.tcl pipeline_hls.cpp run.cpp
	RUN_PATH=$(realpath ./) \
	RUN_ARGS=$(realpath ./../../images/gray.png) \
	vivado_hls -f $< -l $(HLS_LOG)

#pipeline_zynq.o: pipeline_zynq.c
#	$(CXX) -c -O2 $(CXXFLAGS) -g -Wall -Werror $^ -o $@

run_zynq.o: run_zynq.cpp
	$(CXX) -c $(CXXFLAGS) -g -Wall -Werror $^ -o $@  $(PNGFLAGS)

run_zynq: pipeline_zynq.o pipeline_native.o run_zynq.o
	$(CXX) -Wall -Werror $^ -lpthread -ldl -o $@  $(PNGFLAGS)

run_power: run_power.cpp
	$(CXX) -O $(CXXFLAGS) -g -Wall -Werror $^ -o $@

out_zynq.png: run_zynq
	HL_NUM_THREADS=3 ./run_zynq ../../images/benchmark_8mp_gray.png

clean:
	rm -f pipeline run run_zynq
	rm -f out.png out_zynq.png
	rm -f pipeline_native.h pipeline_native.o
	rm -f pipeline_hls.h pipeline_hls.cpp hls_target.h hls_target.cpp
	rm -f pipeline_coreir.h pipeline_coreir.cpp coreir_target.cpp
	rm -f pipeline_cuda.h pipeline_cuda.o
	rm -f pipeline_zynq.h pipeline_zynq.c pipeline_zynq.o run_zynq.o
	rm -f rigel_target.h rigel_target.t coreir_target.h coreir_target.t
	rm -f *.html *.json
