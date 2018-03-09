SHELL := /bin/bash

ALL_COREIR_APPS = pointwise param \
	conv_1_1 conv_1_2 conv_2_1 conv_3_1 conv_bw gaussian \
	conv_nest \
	onebit_comp onebit_and onebit_mux onebit_bool harris 

NOT_WORKING_APPS = cascade conv_rgb demosaic stereo camera_pipe simpleCNN unsharp \
	demosaic_flow demosaic_harris conv_multi

# all directories (just text) excluding a particular list
ALL_APPS := $(subst /,, $(dir $(wildcard */.)))
ALL_APPS := $(filter-out hls_support tools, $(ALL_APPS))

all: test_all
cleanall:
	for app in $(ALL_COREIR_APPS); do \
	  $(MAKE) -C $$app clean > /dev/null; \
	done
	for app in $(NOT_WORKING_APPS); do \
	  $(MAKE) -C $$app clean > /dev/null; \
	done
	$(MAKE) -C tools cleanall > /dev/null

.PHONY: $(ALL_COREIR_APPS)
$(ALL_COREIR_APPS):
	$(MAKE) -C $@ || exit 1

test_conv: conv_1_2 conv_2_1 conv_3_1 conv_bw conv_nest

test_onebit: onebit_comp onebit_and onebit_mux onebit_bool

# runs all tests, and then specifies which passed and which failed
test_all testall: $(ALL_COREIR_APPS)
	@echo ""
	@for app in $(ALL_APPS); do \
		if [[ "$(ALL_COREIR_APPS)" == *"$$app"* ]]; then \
			if [ -f $$app"/design_prepass.json" ]; then \
				printf "%-15s \033[0;32m%s\033[0m\n" $$app "PASSED"; \
			else \
				printf "%-15s \033[0;31m%s\033[0m\n" $$app "FAILED"; \
			fi \
		elif [[ "$(NOT_WORKING_APPS)" == *"$$app"* ]]; then \
			printf "%-15s \033[1;37m%s\033[0m\n" $$app "DID NOT RUN"; \
		else \
			printf "%-15s \033[1;33m%s\033[0m\n" $$app "NOT CLASSIFIED"; \
		fi \
	done

