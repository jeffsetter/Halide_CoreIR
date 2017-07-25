include Makefile.inc

.PHONY: all
all: help input_ones.pgm input_unique.pgm

gen_testimage: gen_testimage.cpp
	$(CXX) $(CXXFLAGS) -O1 -DNDEBUG -g -Wall -Werror $^ $(LDFLAGS) -o $@ $(PNGFLAGS)
help: gen_testimage
	./gen_testimage; test $$? -eq 255

unique input_unique.pgm: gen_testimage
	./gen_testimage 10 10 b input_unique.pgm
	./gen_testimage 10 10 b input.png
unique_64_64: gen_testimage
	./gen_testimage 64 64 b input_unique.pgm
	./gen_testimage 64 64 b input.png

input_ones.pgm: gen_testimage
	./gen_testimage 10 10 a input_ones.pgm
	./gen_testimage 10 10 a input.png


clean:
	rm -f gen_testimage
	rm -f input.png input_unique.pgm input_ones.pgm


