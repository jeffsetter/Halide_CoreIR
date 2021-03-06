SHELL := /bin/bash
CXX ?= g++-4.9
OUTPUT_REDIRECTION ?= &>/dev/null

APP_PATH := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
APPNAME := $(notdir $(patsubst %/,%,$(dir $(APP_PATH))))

# empty "make all" rule included here so "make" refers to "make all"
all:


# Use halide compiler to create design.
pipeline: pipeline.cpp
	$(CXX) $(CXXFLAGS) -Wall -g $^ $(LIB_HALIDE) -o $@ $(LDFLAGS) -ltinfo

pipeline_hls.cpp hls_target.cpp pipeline_native.o design_top.json design_top.txt: pipeline
	HL_DEBUG_CODEGEN=0 ./pipeline


# Create input image.
gen_testimage:
	$(MAKE) -C ../tools/gen_testimage gen_testimage
	cp ../tools/gen_testimage/gen_testimage .

input_unique.pgm-default:
	$(MAKE) gen_testimage
	./gen_testimage 16 16 b input_unique.pgm
	./gen_testimage 16 16 b input.png
input_ones.pgm-default:
	$(MAKE) gen_testimage
	./gen_testimage 16 16 a input_ones.pgm
	./gen_testimage 16 16 a input.png
input.png-default: 
	@if [[ ! -f input.png ]]; then \
		$(MAKE) input_unique.pgm; \
	fi

%: %-default
	@ true

# Use design and run it to create output image.
run: run.cpp pipeline_hls.cpp pipeline_native.o hls_target.cpp
	$(CXX) $(CXXFLAGS) -O1 -DNDEBUG $(HLS_CXXFLAGS) -g -Wall -Werror $^ -lpthread -ldl $(LIB_HALIDE) -o $@ $(PNGFLAGS) $(LDFLAGS)

out.png: run input.png design_top.json
	./run input.png quick
out_coreir.png: run input.png design_top.json
	./run input.png all


# Use graphviz to create graph of processing nodes.
graph.png: design_top.txt
	dot -Tpng design_top.txt > graph.png


# Test if app works, using cached result if json design matches golden.
test:
	@-$(MAKE) -s pipeline $(OUTPUT_REDIRECTION)
	@-$(MAKE) -s design_top.json $(OUTPUT_REDIRECTION)
	@-$(MAKE) -s run $(OUTPUT_REDIRECTION)
	@if [ -f "passed.md5" ]; then \
		md5sum -c --status passed.md5; \
		EXIT_CODE=$$?; \
		if [[ $$EXIT_CODE = "0" ]]; then \
			printf "%-15s \033[0;32m%s\033[0m\n" $(APPNAME) "PASSED"; \
		else \
			rm -f passed.md5; \
			$(MAKE) -s testrun; \
		fi \
	elif [ -f "failed.md5" ]; then \
		md5sum -c --status failed.md5; \
		EXIT_CODE=$$?; \
		if [[ $$EXIT_CODE = "0" ]]; then \
			printf "%-15s \033[0;31m%s\033[0m\n" $(APPNAME) "FAILED" && exit 1; \
		else \
			rm -f failed.md5; \
			$(MAKE) -s testrun; \
		fi \
	else \
		$(MAKE) -s testrun; \
	fi

# Run design on cpu and coreir interpreter, and print if it passes/fails.
testrun:
		@-$(MAKE) out_coreir.png $(OUTPUT_REDIRECTION); \
		EXIT_CODE=$$?; \
		if [[ $$EXIT_CODE = "0" && -f "out.png" ]]; then \
			printf "%-15s \033[1;33m%s\033[0m\n" $(APPNAME) "PASSED, but needs golden updated"; \
		else \
			printf "%-15s \033[0;31m%s\033[0m\n" $(APPNAME) "FAILED, and needs golden updated" && exit 1; \
		fi

# Update golden file, run design, and store result in md5 filename.
updategolden update_golden passed.md5 failed.md5:
	@$(MAKE) out_coreir.png; \
	EXIT_CODE=$$?; \
	if [[ $$EXIT_CODE = "0" && -f "out.png" ]]; then \
		rm -f failed.md5; \
		md5sum run design_top.json > passed.md5; \
		echo "$(APPNAME): Updated design_top_golden.json and created passed.md5"; \
	else \
		rm -f failed.md5; \
		md5sum run design_top.json > failed.md5; \
		echo "$(APPNAME): Updated design_top_golden.json and created failed.md5"; \
	fi
	@cp design_top.json design_top_golden.json

check:
	@printf "%-15s" $(APPNAME); 
	@if [ -f "design_prepass.json" ]; then \
		printf "  \033[0;32m%s\033[0m" " coreir"; \
	else \
		printf "  \033[0;31m%s\033[0m" "!coreir"; \
	fi 
	@if [ -f "run" ]; then \
		printf "  \033[0;32m%s\033[0m" " run"; \
	else \
		printf "  \033[0;31m%s\033[0m" "!run"; \
	fi 
	@if [ -f "out.png" ]; then \
		printf "  \033[0;32m%s\033[0m" " out.png"; \
	else \
		printf "  \033[0;31m%s\033[0m" "!out.png"; \
	fi 
	@if [ -f "passed.md5" ]; then \
		printf "  \033[0;32m%s\033[0m" "passed.md5"; \
	fi 
	@if [ -f "failed.md5" ]; then \
		printf "  \033[0;31m%s\033[0m" "failed.md5"; \
	fi 
	@printf "\n"

# Clean all of the common generated files.
clean_commonfiles:
	rm -f pipeline run
	rm -f *.html
	rm -f pipeline_native.h pipeline_native.o
	rm -f pipeline_hls.h pipeline_hls.cpp hls_target.h hls_target.cpp
	rm -f pipeline_coreir.cpp pipeline_coreir.h coreir_target.h coreir_target.cpp
	rm -f gen_testimage input_unique.pgm input_unique.png
	rm -f design_prepass.json design_top.json design_flattened.json
	rm -f design_top.txt graph.png out.png out_coreir.png
