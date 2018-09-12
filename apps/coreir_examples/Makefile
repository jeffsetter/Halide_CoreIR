SHELL := /bin/bash

# comment out this line to output when creating and testing designs
OUTPUT_REDIRECTION ?= &>/dev/null

WORKING_APPS = pointwise param \
	conv_1_1 conv_1_2 conv_2_1 conv_3_1 conv_bw gaussian blur_1_4 \
	conv_1_2_valid conv_2_1_valid conv_3_1_valid conv_bw_valid cascade \
	threshold_conv conv_nest conv_chain \
	onebit_comp onebit_and onebit_mux onebit_bool \
	harris harris_valid demosaic

NOT_WORKING_APPS = \
	conv_rgb demosaic stereo camera_pipe simpleCNN unsharp \
	demosaic_flow demosaic_harris conv_multi \


# all directories (just text) excluding a particular list
ALL_APPS := $(subst /,, $(dir $(wildcard */.)))
ALL_APPS := $(filter-out hls_support tools, $(ALL_APPS))

WORKING_APPS_TESTS := $(WORKING_APPS:=-test)
WORKING_APPS_GOLDENS := $(WORKING_APPS:=-update-golden)
WORKING_APPS_CHECKS := $(WORKING_APPS:=-check)

all: test_all
cleanall:
	for app in $(ALL_APPS); do \
	  $(MAKE) -C $$app clean > /dev/null; \
	done
	$(MAKE) -C tools cleanall > /dev/null

# continue running these even if they fail
.PHONY: $(WORKING_APPS)
$(WORKING_APPS):
	$(MAKE) -C $@ -i test

%-test:
	$(MAKE) -C $* -si test $(OUTPUT_REDIRECTION)
	@$(MAKE) -C $* -s check --no-print-directory

%-update-golden:
	$(MAKE) -C $* update_golden $(OUTPUT_REDIRECTION)
	@$(MAKE) -C $* -s check --no-print-directory

%-check:
	@$(MAKE) -C $* -s check --no-print-directory

test_conv: conv_1_2 conv_2_1 conv_3_1 conv_bw conv_nest

test_onebit: onebit_comp onebit_and onebit_mux onebit_bool

test_travis: pointwise conv_bw onebit_bool harris cascade

test_all_apps: $(WORKING_APPS_TESTS)
	$(MAKE) check_all_apps

check_all_apps:
	@echo ""
	@echo "---TESTING SUMMARY---"
	@for app in $(ALL_APPS); do \
		if [[ "$(WORKING_APPS)" == *"$$app"* ]]; then \
			if [[ -f $$app"/design_prepass.json" && ( -f $$app/"out.png" || -f $$app/"passed.md5" ) ]]; then \
				if [ -f $$app/"passed.md5" ]; then \
					printf "%-15s \033[0;32m%s\033[0m\n" $$app "PASSED"; \
				else \
					printf "%-15s \033[1;33m%s\033[0m\n" $$app "PASSED, but needs golden updated"; \
				fi \
			else \
				printf "%-15s \033[0;31m%s\033[0m\n" $$app "FAILED"; \
			fi \
		elif [[ "$(NOT_WORKING_APPS)" == *"$$app"* ]]; then \
			printf "%-15s \033[1;37m%s\033[0m\n" $$app "DID NOT RUN"; \
		else \
			printf "%-15s \033[1;33m%s\033[0m\n" $$app "NOT CLASSIFIED"; \
		fi \
	done

testall test_all test-all:
	@$(MAKE) test_all_apps -i

update_goldens_all_apps: $(WORKING_APPS_GOLDENS)
	@$(MAKE) check_all_apps

updateall update_all updategoldens update_goldens:
	@$(MAKE) update_goldens_all_apps -i

checkall check_all: $(WORKING_APPS_CHECKS)
	@for app in $(ALL_APPS); do \
		if [[ "$(WORKING_APPS)" == *"$$app"* ]]; then \
			true; \
		elif [[ "$(NOT_WORKING_APPS)" == *"$$app"* ]]; then \
			printf "%-15s \033[1;37m%s\033[0m\n" $$app "DID NOT RUN"; \
		else \
			printf "%-15s \033[1;33m%s\033[0m\n" $$app "NOT CLASSIFIED"; \
		fi \
	done
