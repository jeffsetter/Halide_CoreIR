ALL_COREIR_APPS = pointwise \
	conv_1_1 conv_1_2 conv_2_1 conv_3_1 conv_bw \
	onebit_comp onebit_and onebit_mux onebit_bool harris \
	conv_nest conv_multi demosaic

NOT_WORKING_APPS = cascade conv_rgb stereo

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

test_all: $(ALL_COREIR_APPS)
	@echo -e "\033[0;32m ALL APPS PASSED!!!! \033[0m"
