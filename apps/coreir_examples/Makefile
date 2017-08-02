ALL_COREIR_APPS = pointwise \
	conv_1_1 conv_1_2 conv_2_1 conv_3_1 conv_bw conv_rgb cascade \
	onebit_comp onebit_and onebit_mux harris

cleanall:
	for app in $(ALL_COREIR_APPS); do \
	  $(MAKE) -C $$app clean > /dev/null; \
	done
	$(MAKE) -C tools cleanall > /dev/null

test_conv:
	for app in conv_1_2 conv_2_1 conv_3_1 conv_bw; do \
	  $(MAKE) -C $$app; \
	done

test_onebit:
	for app in onebit_comp onebit_and onebit_mux; do \
	  $(MAKE) -C $$app; \
	done

