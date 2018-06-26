#include "halide_image.h"
#include "halide_image_io.h"

#include "coreir.h"
#include "coreir/passes/transform/rungenerators.h"
#include "coreir/simulator/interpreter.h"
#include "coreir/libs/commonlib.h"

template <typename elem_t>
class ImageWriter {
public:
  ImageWriter(uint width, uint height, uint channels=1) :
    width(width), height(height), channels(channels),
    image(width, height, channels),
    current_x(0), current_y(0), current_z(0) { }

  void write(elem_t data) {
    assert(current_x < width &&
           current_y < height &&
           current_z < depth);
    image(current_x, current_y, current_z) = data;

    // increment coords
    current_x++;
    if (current_x == width) {
      current_y++;
      current_x = 0;
    }
    if (current_y == height) {
      current_z++;
      current_y = 0;
    }
  }

  elem_t read(uint x, uint y, uint z) {
    return image(x,y,z);
  }

  void save_image(std::string image_name) {
    Halide::Tools::save_image(image, image_name);
  }

  void print_coords() {
    std::cout << "x=" << current_x 
              << ",y=" << current_y
              << ",z=" << current_z << std::endl;
  }


private:
  const uint width, height, channels;
  Halide::Tools::Image<elem_t> image;
  uint current_x, current_y, current_z;
};
