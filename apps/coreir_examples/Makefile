ALL_COREIR_APPS = pointwise conv_bw conv_rgb cascade

cleanall:
	for app in $(ALL_COREIR_APPS); do \
	  $(MAKE) -C $$app clean; \
	done
