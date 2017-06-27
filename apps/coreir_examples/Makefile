ALL_COREIR_APPS = pointwise conv_1_1 conv_1_2 conv_2_1 conv_3_1 conv_bw conv_rgb cascade

cleanall:
	for app in $(ALL_COREIR_APPS); do \
	  $(MAKE) -C $$app clean; \
	done
