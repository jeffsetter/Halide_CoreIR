ALL_COREIR_APPS = pointwise \
	conv_1_1 conv_1_2 conv_2_1 conv_3_1 conv_bw conv_rgb cascade \
	onebit_comp onebit_and onebit_mux

cleanall:
	for app in $(ALL_COREIR_APPS); do \
	  $(MAKE) -C $$app clean > /dev/null; \
	done
	$(MAKE) -C tools cleanall > /dev/null
