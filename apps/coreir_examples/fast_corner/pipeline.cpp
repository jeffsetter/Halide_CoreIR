#include "Halide.h"
#include <string.h>

using namespace Halide;
using std::string;

Var x("x"), y("y"), l("l");
Var xo("xo"), xi("xi"), yi("yi"), yo("yo");

int8_t threshold = 10;
int8_t min_seg_len = 9;

class MyPipeline {
public:
  ImageParam input;
  Func hw_in, segment;
  Func lighter, darker, lighter8, darker8;
  Func contiguous_lighter, contiguous_darker;
  Func largest_seg_dark[16], largest_seg_light[16], largest_seg;
  Func output, hw_output;
  std::vector<Argument> args;

  RDom ring_win;
  RDom seg_win;

  MyPipeline() : input(UInt(8), 2, "input"),
                 output("output"), hw_output("hw_output"),
                 ring_win(0,16), seg_win(0, min_seg_len) {
    
    // define the algorithm
    hw_in(x,y) = input(x+3,y+3);
    segment(x,y,l) = select(l==0,  hw_in(x  , y-3),
                            l==1,  hw_in(x+1, y-3),
                            l==2,  hw_in(x+2, y-2),
                            l==3,  hw_in(x+3, y-1),
                            l==4,  hw_in(x+3, y),
                            l==5,  hw_in(x+3, y+1),
                            l==6,  hw_in(x+2, y+2),
                            l==7,  hw_in(x+1, y+3),
                            l==8,  hw_in(x,   y+3),
                            l==9,  hw_in(x-1, y+3),
                            select(l==10, hw_in(x-2, y+2),
                                   l==11, hw_in(x-3, y+1),
                                   l==12, hw_in(x-3, y),
                                   l==13, hw_in(x-3, y-1),
                                   l==14, hw_in(x-2, y-2),
                                   l==15, hw_in(x-1, y-3),
                                   l==16, hw_in(x,   y-3),
                                   l==17, hw_in(x+1, y-3),
                                   l==18, hw_in(x+2, y-2),
                                   l==19, hw_in(x+3, y-1),
                                   select(l==20, hw_in(x+3, y),
                                          l==21, hw_in(x+3, y+1),
                                          l==22, hw_in(x+2, y+2),
                                          l==23, hw_in(x+1, y+3), 0)));

    // compare center pixel to surrounding segment
    lighter(x,y,l)  = segment(x,y,l) > (hw_in(x,y) + threshold);
    darker(x,y,l)   = segment(x,y,l) < (hw_in(x,y) - threshold);

    // use select to convert a 1bit to 8bit
    lighter8(x,y,l) = cast<uint8_t>(select(lighter(x,y,l), 1, 0));
    darker8( x,y,l) = cast<uint8_t>(select(darker( x,y,l), 1, 0));

    // sum up looking for contiguous segment
    contiguous_lighter(x,y,l) += lighter8(x,y,l + seg_win);
    contiguous_darker(x,y,l)  += darker8( x,y,l + seg_win);
    contiguous_lighter.update().unroll(seg_win).unroll(l);
    contiguous_darker.update().unroll(seg_win).unroll(l);

    // calculate the largest contiguous segment
    for (int i=0; i<16; ++i) {
      if (i==0) {
        largest_seg_light[i](x,y) = contiguous_lighter(x,y,0);
        largest_seg_dark[i](x,y)  = contiguous_darker(x, y,0);
      } else {
        largest_seg_light[i](x,y) = max(contiguous_lighter(x,y,i), largest_seg_light[i-1](x,y));
        largest_seg_dark[i](x,y)  = max(contiguous_darker( x,y,i), largest_seg_dark[i-1](x,y));
      }
    }
    largest_seg(x,y) = max(largest_seg_dark[15](x,y), largest_seg_light[15](x,y));
    //largest_seg_dark(x,y)  = maximum(contiguous_darker(x, y,ring_win));
    //largest_seg_light(x,y) = maximum(contiguous_lighter(x,y,ring_win));
    //largest_seg_dark.unroll(ring_win);
    //largest_seg_light.unroll(ring_win);

    // Output largest segment size if greater than
    // minimum segment length needed to classify as corner.
    hw_output(x,y) = select(largest_seg(x,y) > min_seg_len, largest_seg(x,y), 0);

    output(x, y) = hw_output(x, y);

    args.push_back(input);

  }

  void compile_cpu() {
    std::cout << "\ncompiling cpu code..." << std::endl;

    output.tile(x, y, xo, yo, xi, yi, 32,32);
    output.fuse(xo, yo, xo).parallel(xo);

    output.vectorize(xi, 8);

    //output.print_loop_nest();
    output.compile_to_lowered_stmt("pipeline_native.ir.html", args, HTML);
    output.compile_to_header("pipeline_native.h", args, "pipeline_native");
    output.compile_to_object("pipeline_native.o", args, "pipeline_native");
  }

  void compile_hls() {
    std::cout << "\ncompiling HLS code..." << std::endl;

    hw_in.compute_root(); // prepare the input for the whole image

    // HLS schedule: make a hw pipeline producing 'hw_output', taking
    // inputs of 'hw_in', buffering intermediates at (output, xo) loop
    // level
    hw_output.compute_root();
    //hw_output.tile(x, y, xo, yo, xi, yi, 1920, 1080).reorder(xi, yi, xo, yo);
    hw_output.tile(x, y, xo, yo, xi, yi, 64-7,64-7).reorder(xi, yi, xo, yo);
    lighter.compute_at(hw_output,xi).unroll(l);
    darker.compute_at(hw_output,xi).unroll(l);
    lighter8.compute_at(hw_output,xi).unroll(l);
    darker8.compute_at(hw_output,xi).unroll(l);
    contiguous_lighter.compute_at(hw_output,xi).unroll(l);
    contiguous_darker.compute_at(hw_output,xi).unroll(l);

    //hw_output.unroll(xi, 2);
    hw_output.accelerate({hw_in}, xi, xo, {});  // define the inputs and the output

    output.print_loop_nest();
    Target hls_target = get_target_from_environment();
    hls_target.set_feature(Target::CPlusPlusMangling);
    output.compile_to_lowered_stmt("pipeline_hls.ir.html", args, HTML, hls_target);
    output.compile_to_hls("pipeline_hls.cpp", args, "pipeline_hls", hls_target);
    output.compile_to_header("pipeline_hls.h", args, "pipeline_hls", hls_target);
  }

  void compile_coreir() {
    std::cout << "\ncompiling CoreIR code..." << std::endl;
    hw_in.compute_root();
    hw_output.compute_root();
    hw_output.tile(x, y, xo, yo, xi, yi, 64-6,64-6).reorder(xi,yi,xo,yo);
    hw_output.accelerate({hw_in}, xi, xo, {});
    lighter.compute_at(hw_output,xi).unroll(l);
    darker.compute_at(hw_output,xi).unroll(l);
    lighter8.compute_at(hw_output,xi).unroll(l);
    darker8.compute_at(hw_output,xi).unroll(l);
    contiguous_lighter.compute_at(hw_output,xi).unroll(l);
    contiguous_darker.compute_at(hw_output,xi).unroll(l);

    Target coreir_target = get_target_from_environment();
    coreir_target.set_feature(Target::CoreIRValid);
    coreir_target.set_feature(Target::CPlusPlusMangling);
    output.compile_to_lowered_stmt("pipeline_coreir.ir.html", args, HTML, coreir_target);
    output.compile_to_coreir("pipeline_coreir.cpp", args, "pipeline_coreir", coreir_target);
  }

};


int main(int argc, char **argv) {
  MyPipeline p1;
  p1.compile_cpu();

  MyPipeline p2;
  p2.compile_hls();

  MyPipeline p4;
  p4.compile_coreir();

  //    MyPipeline p3;
  //p3.compile_gpu();
  return 0;
}
