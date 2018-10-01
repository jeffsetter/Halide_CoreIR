#include <iostream>
#include <math.h>
#include <float.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#ifndef HALIDE_ATTRIBUTE_ALIGN
  #ifdef _MSC_VER
    #define HALIDE_ATTRIBUTE_ALIGN(x) __declspec(align(x))
  #else
    #define HALIDE_ATTRIBUTE_ALIGN(x) __attribute__((aligned(x)))
  #endif
#endif
#ifndef BUFFER_T_DEFINED
#define BUFFER_T_DEFINED
#include <stdbool.h>
#include <stdint.h>
typedef struct buffer_t {
    uint64_t dev;
    uint8_t* host;
    int32_t extent[4];
    int32_t stride[4];
    int32_t min[4];
    int32_t elem_size;
    HALIDE_ATTRIBUTE_ALIGN(1) bool host_dirty;
    HALIDE_ATTRIBUTE_ALIGN(1) bool dev_dirty;
    HALIDE_ATTRIBUTE_ALIGN(1) uint8_t _padding[10 - sizeof(void *)];
} buffer_t;
#endif
struct halide_filter_metadata_t;
extern "C" {
void *halide_malloc(void *ctx, size_t);
void halide_free(void *ctx, void *ptr);
void *halide_print(void *ctx, const void *str);
void *halide_error(void *ctx, const void *str);
int halide_debug_to_file(void *ctx, const char *filename, int, struct buffer_t *buf);
int halide_start_clock(void *ctx);
int64_t halide_current_time_ns(void *ctx);
void halide_profiler_pipeline_end(void *, void *);
}

#ifdef _WIN32
float roundf(float);
double round(double);
#else
inline float asinh_f32(float x) {return asinhf(x);}
inline float acosh_f32(float x) {return acoshf(x);}
inline float atanh_f32(float x) {return atanhf(x);}
inline double asinh_f64(double x) {return asinh(x);}
inline double acosh_f64(double x) {return acosh(x);}
inline double atanh_f64(double x) {return atanh(x);}
#endif
inline float sqrt_f32(float x) {return sqrtf(x);}
inline float sin_f32(float x) {return sinf(x);}
inline float asin_f32(float x) {return asinf(x);}
inline float cos_f32(float x) {return cosf(x);}
inline float acos_f32(float x) {return acosf(x);}
inline float tan_f32(float x) {return tanf(x);}
inline float atan_f32(float x) {return atanf(x);}
inline float sinh_f32(float x) {return sinhf(x);}
inline float cosh_f32(float x) {return coshf(x);}
inline float tanh_f32(float x) {return tanhf(x);}
inline float hypot_f32(float x, float y) {return hypotf(x, y);}
inline float exp_f32(float x) {return expf(x);}
inline float log_f32(float x) {return logf(x);}
inline float pow_f32(float x, float y) {return powf(x, y);}
inline float floor_f32(float x) {return floorf(x);}
inline float ceil_f32(float x) {return ceilf(x);}
inline float round_f32(float x) {return roundf(x);}

inline double sqrt_f64(double x) {return sqrt(x);}
inline double sin_f64(double x) {return sin(x);}
inline double asin_f64(double x) {return asin(x);}
inline double cos_f64(double x) {return cos(x);}
inline double acos_f64(double x) {return acos(x);}
inline double tan_f64(double x) {return tan(x);}
inline double atan_f64(double x) {return atan(x);}
inline double sinh_f64(double x) {return sinh(x);}
inline double cosh_f64(double x) {return cosh(x);}
inline double tanh_f64(double x) {return tanh(x);}
inline double hypot_f64(double x, double y) {return hypot(x, y);}
inline double exp_f64(double x) {return exp(x);}
inline double log_f64(double x) {return log(x);}
inline double pow_f64(double x, double y) {return pow(x, y);}
inline double floor_f64(double x) {return floor(x);}
inline double ceil_f64(double x) {return ceil(x);}
inline double round_f64(double x) {return round(x);}

inline float nan_f32() {return NAN;}
inline float neg_inf_f32() {return -INFINITY;}
inline float inf_f32() {return INFINITY;}
inline bool is_nan_f32(float x) {return x != x;}
inline bool is_nan_f64(double x) {return x != x;}
inline float float_from_bits(uint32_t bits) {
 union {
  uint32_t as_uint;
  float as_float;
 } u;
 u.as_uint = bits;
 return u.as_float;
}

template<typename T> T max(T a, T b) {if (a > b) return a; return b;}
template<typename T> T min(T a, T b) {if (a < b) return a; return b;}
template<typename A, typename B> A reinterpret(B b) {A a; memcpy(&a, &b, sizeof(a)); return a;}

inline static bool halide_rewrite_buffer(buffer_t *b, int32_t elem_size,
                           int32_t min0, int32_t extent0, int32_t stride0,
                           int32_t min1, int32_t extent1, int32_t stride1,
                           int32_t min2, int32_t extent2, int32_t stride2,
                           int32_t min3, int32_t extent3, int32_t stride3) {
 b->min[0] = min0;
 b->min[1] = min1;
 b->min[2] = min2;
 b->min[3] = min3;
 b->extent[0] = extent0;
 b->extent[1] = extent1;
 b->extent[2] = extent2;
 b->extent[3] = extent3;
 b->stride[0] = stride0;
 b->stride[1] = stride1;
 b->stride[2] = stride2;
 b->stride[3] = stride3;
 return true;
}
#ifndef HALIDE_FUNCTION_ATTRS
#define HALIDE_FUNCTION_ATTRS
#endif
#ifndef CMA_BUFFER_T_DEFINED
#define CMA_BUFFER_T_DEFINED
struct mMap;
typedef struct cma_buffer_t {
  unsigned int id; // ID flag for internal use
  unsigned int width; // Width of the image
  unsigned int stride; // Stride between rows, in pixels. This must be >= width
  unsigned int height; // Height of the image
  unsigned int depth; // Byte-depth of the image
  unsigned int phys_addr; // Bus address for DMA
  void* kern_addr; // Kernel virtual address
  struct mMap* cvals;
  unsigned int mmap_offset;
} cma_buffer_t;
#endif
// Zynq runtime API
int halide_zynq_init();
void halide_zynq_free(void *user_context, void *ptr);
int halide_zynq_cma_alloc(struct buffer_t *buf);
int halide_zynq_cma_free(struct buffer_t *buf);
int halide_zynq_subimage(const struct buffer_t* image, struct cma_buffer_t* subimage, void *address_of_subimage_origin, int width, int height);
int halide_zynq_hwacc_launch(struct cma_buffer_t bufs[]);
int halide_zynq_hwacc_sync(int task_id);

#ifdef __cplusplus
extern "C" {
#endif
int32_t  halide_error_access_out_of_bounds(void *, const char *, int32_t , int32_t , int32_t , int32_t , int32_t );
int32_t  halide_error_bad_elem_size(void *, const char *, const char *, int32_t , int32_t );
int32_t  halide_error_buffer_allocation_too_large(void *, const char *, int64_t , int64_t );
int32_t  halide_error_buffer_extents_too_large(void *, const char *, int64_t , int64_t );
int32_t  halide_error_constraint_violated(void *, const char *, int32_t , const char *, int32_t );
int32_t  halide_error_explicit_bounds_too_small(void *, const char *, const char *, int32_t , int32_t , int32_t , int32_t );


static int __pipeline_zynq(buffer_t *_p2___input_buffer, buffer_t *_hw_output__1_buffer) HALIDE_FUNCTION_ATTRS {
 uint8_t *_p2___input = (uint8_t *)(_p2___input_buffer->host);
 (void)_p2___input;
 const bool _p2___input_host_and_dev_are_null = (_p2___input_buffer->host == nullptr) && (_p2___input_buffer->dev == 0);
 (void)_p2___input_host_and_dev_are_null;
 const int32_t _p2___input_min_0 = _p2___input_buffer->min[0];
 (void)_p2___input_min_0;
 const int32_t _p2___input_min_1 = _p2___input_buffer->min[1];
 (void)_p2___input_min_1;
 const int32_t _p2___input_min_2 = _p2___input_buffer->min[2];
 (void)_p2___input_min_2;
 const int32_t _p2___input_min_3 = _p2___input_buffer->min[3];
 (void)_p2___input_min_3;
 const int32_t _p2___input_extent_0 = _p2___input_buffer->extent[0];
 (void)_p2___input_extent_0;
 const int32_t _p2___input_extent_1 = _p2___input_buffer->extent[1];
 (void)_p2___input_extent_1;
 const int32_t _p2___input_extent_2 = _p2___input_buffer->extent[2];
 (void)_p2___input_extent_2;
 const int32_t _p2___input_extent_3 = _p2___input_buffer->extent[3];
 (void)_p2___input_extent_3;
 const int32_t _p2___input_stride_0 = _p2___input_buffer->stride[0];
 (void)_p2___input_stride_0;
 const int32_t _p2___input_stride_1 = _p2___input_buffer->stride[1];
 (void)_p2___input_stride_1;
 const int32_t _p2___input_stride_2 = _p2___input_buffer->stride[2];
 (void)_p2___input_stride_2;
 const int32_t _p2___input_stride_3 = _p2___input_buffer->stride[3];
 (void)_p2___input_stride_3;
 const int32_t _p2___input_elem_size = _p2___input_buffer->elem_size;
 (void)_p2___input_elem_size;
 uint8_t *_hw_output__1 = (uint8_t *)(_hw_output__1_buffer->host);
 (void)_hw_output__1;
 const bool _hw_output__1_host_and_dev_are_null = (_hw_output__1_buffer->host == nullptr) && (_hw_output__1_buffer->dev == 0);
 (void)_hw_output__1_host_and_dev_are_null;
 const int32_t _hw_output__1_min_0 = _hw_output__1_buffer->min[0];
 (void)_hw_output__1_min_0;
 const int32_t _hw_output__1_min_1 = _hw_output__1_buffer->min[1];
 (void)_hw_output__1_min_1;
 const int32_t _hw_output__1_min_2 = _hw_output__1_buffer->min[2];
 (void)_hw_output__1_min_2;
 const int32_t _hw_output__1_min_3 = _hw_output__1_buffer->min[3];
 (void)_hw_output__1_min_3;
 const int32_t _hw_output__1_extent_0 = _hw_output__1_buffer->extent[0];
 (void)_hw_output__1_extent_0;
 const int32_t _hw_output__1_extent_1 = _hw_output__1_buffer->extent[1];
 (void)_hw_output__1_extent_1;
 const int32_t _hw_output__1_extent_2 = _hw_output__1_buffer->extent[2];
 (void)_hw_output__1_extent_2;
 const int32_t _hw_output__1_extent_3 = _hw_output__1_buffer->extent[3];
 (void)_hw_output__1_extent_3;
 const int32_t _hw_output__1_stride_0 = _hw_output__1_buffer->stride[0];
 (void)_hw_output__1_stride_0;
 const int32_t _hw_output__1_stride_1 = _hw_output__1_buffer->stride[1];
 (void)_hw_output__1_stride_1;
 const int32_t _hw_output__1_stride_2 = _hw_output__1_buffer->stride[2];
 (void)_hw_output__1_stride_2;
 const int32_t _hw_output__1_stride_3 = _hw_output__1_buffer->stride[3];
 (void)_hw_output__1_stride_3;
 const int32_t _hw_output__1_elem_size = _hw_output__1_buffer->elem_size;
 (void)_hw_output__1_elem_size;
 int32_t _455 = _hw_output__1_extent_0 + -1;
 int32_t _456 = _455 / 61;
 int32_t _457 = _456 * 61;
 int32_t _458 = _455 - _457;
 int32_t _459 = _458 >> 31;
 int32_t _460 = 61 >> 31;
 int32_t _461 = _459 & _460;
 int32_t _462 = _456 - _461;
 int32_t _463 = ~_460;
 int32_t _464 = _459 & _463;
 int32_t _465 = _462 + _464;
 int32_t _466 = _465 * 61;
 int32_t _467 = _466 + _hw_output__1_min_0;
 int32_t _468 = _467 + 60;
 int32_t _469 = _hw_output__1_min_0 + _hw_output__1_extent_0;
 int32_t _470 = _469 + -1;
 int32_t _471 = min(_468, _470);
 int32_t _472 = _469 + -61;
 int32_t _473 = min(_hw_output__1_min_0, _472);
 int32_t _474 = _471 - _473;
 int32_t _475 = _hw_output__1_extent_1 + -1;
 int32_t _476 = _475 / 61;
 int32_t _477 = _476 * 61;
 int32_t _478 = _475 - _477;
 int32_t _479 = _478 >> 31;
 int32_t _480 = _479 & _460;
 int32_t _481 = _476 - _480;
 int32_t _482 = _479 & _463;
 int32_t _483 = _481 + _482;
 int32_t _484 = _483 * 61;
 int32_t _485 = _484 + _hw_output__1_min_1;
 int32_t _486 = _485 + 60;
 int32_t _487 = _hw_output__1_min_1 + _hw_output__1_extent_1;
 int32_t _488 = _487 + -1;
 int32_t _489 = min(_486, _488);
 int32_t _490 = _487 + -61;
 int32_t _491 = min(_hw_output__1_min_1, _490);
 int32_t _492 = _489 - _491;
 int32_t _493 = _474 + 1;
 int32_t _494 = _492 + 1;
 int32_t _495 = _493 * _494;
 if (_hw_output__1_host_and_dev_are_null)
 {
  int32_t _496 = _474 + 1;
  int32_t _497 = _492 + 1;
  bool _498 = halide_rewrite_buffer(_hw_output__1_buffer, 1, _473, _496, 1, _491, _497, _496, 0, 3, _495, 0, 0, 0);
  (void)_498;
 } // if _hw_output__1_host_and_dev_are_null
 if (_p2___input_host_and_dev_are_null)
 {
  int32_t _499 = _hw_output__1_extent_0 + 3;
  int32_t _500 = _hw_output__1_extent_1 + 3;
  bool _501 = halide_rewrite_buffer(_p2___input_buffer, 1, _hw_output__1_min_0, _499, 1, _hw_output__1_min_1, _500, _499, 0, 0, 0, 0, 0, 0);
  (void)_501;
 } // if _p2___input_host_and_dev_are_null
 bool _502 = _hw_output__1_host_and_dev_are_null || _p2___input_host_and_dev_are_null;
 bool _503 = !(_502);
 if (_503)
 {
  bool _504 = _hw_output__1_elem_size == 1;
  if (!_504)   {
   int32_t _505 = halide_error_bad_elem_size(nullptr, "Output buffer hw_output$1", "uint8", _hw_output__1_elem_size, 1);
   return _505;
  }
  bool _506 = _p2___input_elem_size == 1;
  if (!_506)   {
   int32_t _507 = halide_error_bad_elem_size(nullptr, "Input buffer p2:input", "uint8", _p2___input_elem_size, 1);
   return _507;
  }
  bool _508 = _hw_output__1_min_0 <= _473;
  int32_t _509 = _473 + _474;
  int32_t _510 = _509 - _hw_output__1_extent_0;
  int32_t _511 = _510 + 1;
  bool _512 = _511 <= _hw_output__1_min_0;
  bool _513 = _508 && _512;
  if (!_513)   {
   int32_t _514 = _473 + _474;
   int32_t _515 = _hw_output__1_min_0 + _hw_output__1_extent_0;
   int32_t _516 = _515 + -1;
   int32_t _517 = halide_error_access_out_of_bounds(nullptr, "Output buffer hw_output$1", 0, _473, _514, _hw_output__1_min_0, _516);
   return _517;
  }
  bool _518 = _hw_output__1_min_1 <= _491;
  int32_t _519 = _491 + _492;
  int32_t _520 = _519 - _hw_output__1_extent_1;
  int32_t _521 = _520 + 1;
  bool _522 = _521 <= _hw_output__1_min_1;
  bool _523 = _518 && _522;
  if (!_523)   {
   int32_t _524 = _491 + _492;
   int32_t _525 = _hw_output__1_min_1 + _hw_output__1_extent_1;
   int32_t _526 = _525 + -1;
   int32_t _527 = halide_error_access_out_of_bounds(nullptr, "Output buffer hw_output$1", 1, _491, _524, _hw_output__1_min_1, _526);
   return _527;
  }
  bool _528 = _hw_output__1_min_2 <= 0;
  int32_t _529 = 3 - _hw_output__1_extent_2;
  bool _530 = _529 <= _hw_output__1_min_2;
  bool _531 = _528 && _530;
  if (!_531)   {
   int32_t _532 = _hw_output__1_min_2 + _hw_output__1_extent_2;
   int32_t _533 = _532 + -1;
   int32_t _534 = halide_error_access_out_of_bounds(nullptr, "Output buffer hw_output$1", 2, 0, 2, _hw_output__1_min_2, _533);
   return _534;
  }
  bool _535 = _p2___input_min_0 <= _hw_output__1_min_0;
  int32_t _536 = _hw_output__1_min_0 + _hw_output__1_extent_0;
  int32_t _537 = _536 - _p2___input_extent_0;
  int32_t _538 = _537 + 3;
  bool _539 = _538 <= _p2___input_min_0;
  bool _540 = _535 && _539;
  if (!_540)   {
   int32_t _541 = _hw_output__1_min_0 + _hw_output__1_extent_0;
   int32_t _542 = _541 + 2;
   int32_t _543 = _p2___input_min_0 + _p2___input_extent_0;
   int32_t _544 = _543 + -1;
   int32_t _545 = halide_error_access_out_of_bounds(nullptr, "Input buffer p2:input", 0, _hw_output__1_min_0, _542, _p2___input_min_0, _544);
   return _545;
  }
  bool _546 = _p2___input_min_1 <= _hw_output__1_min_1;
  int32_t _547 = _hw_output__1_min_1 + _hw_output__1_extent_1;
  int32_t _548 = _547 - _p2___input_extent_1;
  int32_t _549 = _548 + 3;
  bool _550 = _549 <= _p2___input_min_1;
  bool _551 = _546 && _550;
  if (!_551)   {
   int32_t _552 = _hw_output__1_min_1 + _hw_output__1_extent_1;
   int32_t _553 = _552 + 2;
   int32_t _554 = _p2___input_min_1 + _p2___input_extent_1;
   int32_t _555 = _554 + -1;
   int32_t _556 = halide_error_access_out_of_bounds(nullptr, "Input buffer p2:input", 1, _hw_output__1_min_1, _553, _p2___input_min_1, _555);
   return _556;
  }
  bool _557 = _hw_output__1_stride_0 == 1;
  if (!_557)   {
   int32_t _558 = halide_error_constraint_violated(nullptr, "hw_output$1.stride.0", _hw_output__1_stride_0, "1", 1);
   return _558;
  }
  bool _559 = _p2___input_stride_0 == 1;
  if (!_559)   {
   int32_t _560 = halide_error_constraint_violated(nullptr, "p2:input.stride.0", _p2___input_stride_0, "1", 1);
   return _560;
  }
  int64_t _561 = (int64_t)(_hw_output__1_extent_1);
  int64_t _562 = (int64_t)(_hw_output__1_extent_0);
  int64_t _563 = _561 * _562;
  int64_t _564 = (int64_t)(_p2___input_extent_1);
  int64_t _565 = (int64_t)(_p2___input_extent_0);
  int64_t _566 = _564 * _565;
  int64_t _567 = (int64_t)(2147483647);
  bool _568 = _562 <= _567;
  if (!_568)   {
   int64_t _569 = (int64_t)(_hw_output__1_extent_0);
   int64_t _570 = (int64_t)(2147483647);
   int32_t _571 = halide_error_buffer_allocation_too_large(nullptr, "hw_output$1", _569, _570);
   return _571;
  }
  int64_t _572 = (int64_t)(_hw_output__1_extent_1);
  int64_t _573 = (int64_t)(_hw_output__1_stride_1);
  int64_t _574 = _572 * _573;
  int64_t _575 = (int64_t)(2147483647);
  bool _576 = _574 <= _575;
  if (!_576)   {
   int64_t _577 = (int64_t)(_hw_output__1_extent_1);
   int64_t _578 = (int64_t)(_hw_output__1_stride_1);
   int64_t _579 = _577 * _578;
   int64_t _580 = (int64_t)(2147483647);
   int32_t _581 = halide_error_buffer_allocation_too_large(nullptr, "hw_output$1", _579, _580);
   return _581;
  }
  int64_t _582 = (int64_t)(2147483647);
  bool _583 = _563 <= _582;
  if (!_583)   {
   int64_t _584 = (int64_t)(2147483647);
   int32_t _585 = halide_error_buffer_extents_too_large(nullptr, "hw_output$1", _563, _584);
   return _585;
  }
  int64_t _586 = (int64_t)(_hw_output__1_extent_2);
  int64_t _587 = (int64_t)(_hw_output__1_stride_2);
  int64_t _588 = _586 * _587;
  int64_t _589 = (int64_t)(2147483647);
  bool _590 = _588 <= _589;
  if (!_590)   {
   int64_t _591 = (int64_t)(_hw_output__1_extent_2);
   int64_t _592 = (int64_t)(_hw_output__1_stride_2);
   int64_t _593 = _591 * _592;
   int64_t _594 = (int64_t)(2147483647);
   int32_t _595 = halide_error_buffer_allocation_too_large(nullptr, "hw_output$1", _593, _594);
   return _595;
  }
  int64_t _596 = (int64_t)(_hw_output__1_extent_2);
  int64_t _597 = _596 * _563;
  int64_t _598 = (int64_t)(2147483647);
  bool _599 = _597 <= _598;
  if (!_599)   {
   int64_t _600 = (int64_t)(_hw_output__1_extent_2);
   int64_t _601 = _600 * _563;
   int64_t _602 = (int64_t)(2147483647);
   int32_t _603 = halide_error_buffer_extents_too_large(nullptr, "hw_output$1", _601, _602);
   return _603;
  }
  int64_t _604 = (int64_t)(_p2___input_extent_0);
  int64_t _605 = (int64_t)(2147483647);
  bool _606 = _604 <= _605;
  if (!_606)   {
   int64_t _607 = (int64_t)(_p2___input_extent_0);
   int64_t _608 = (int64_t)(2147483647);
   int32_t _609 = halide_error_buffer_allocation_too_large(nullptr, "p2:input", _607, _608);
   return _609;
  }
  int64_t _610 = (int64_t)(_p2___input_extent_1);
  int64_t _611 = (int64_t)(_p2___input_stride_1);
  int64_t _612 = _610 * _611;
  int64_t _613 = (int64_t)(2147483647);
  bool _614 = _612 <= _613;
  if (!_614)   {
   int64_t _615 = (int64_t)(_p2___input_extent_1);
   int64_t _616 = (int64_t)(_p2___input_stride_1);
   int64_t _617 = _615 * _616;
   int64_t _618 = (int64_t)(2147483647);
   int32_t _619 = halide_error_buffer_allocation_too_large(nullptr, "p2:input", _617, _618);
   return _619;
  }
  int64_t _620 = (int64_t)(2147483647);
  bool _621 = _566 <= _620;
  if (!_621)   {
   int64_t _622 = (int64_t)(2147483647);
   int32_t _623 = halide_error_buffer_extents_too_large(nullptr, "p2:input", _566, _622);
   return _623;
  }
  int32_t _624 = _hw_output__1_extent_1 + -1;
  int32_t _625 = _624 / 61;
  int32_t _626 = _625 * 61;
  int32_t _627 = _624 - _626;
  int32_t _628 = _627 >> 31;
  int32_t _629 = 61 >> 31;
  int32_t _630 = _628 & _629;
  int32_t _631 = _625 - _630;
  int32_t _632 = ~_629;
  int32_t _633 = _628 & _632;
  int32_t _634 = _631 + _633;
  int32_t _635 = _634 * 61;
  int32_t _636 = _635 + _hw_output__1_min_1;
  int32_t _637 = _636 + 60;
  int32_t _638 = _hw_output__1_min_1 + _hw_output__1_extent_1;
  int32_t _639 = _638 + -1;
  int32_t _640 = min(_637, _639);
  int32_t _641 = _640 + 2;
  int32_t _642 = _638 + 1;
  int32_t _643 = max(_641, _642);
  int32_t _644 = _hw_output__1_extent_0 + -1;
  int32_t _645 = _644 / 61;
  int32_t _646 = _645 * 61;
  int32_t _647 = _644 - _646;
  int32_t _648 = _647 >> 31;
  int32_t _649 = _648 & _629;
  int32_t _650 = _645 - _649;
  int32_t _651 = _648 & _632;
  int32_t _652 = _650 + _651;
  int32_t _653 = _652 * 61;
  int32_t _654 = _653 + _hw_output__1_min_0;
  int32_t _655 = _654 + 60;
  int32_t _656 = _hw_output__1_min_0 + _hw_output__1_extent_0;
  int32_t _657 = _656 + -1;
  int32_t _658 = min(_655, _657);
  int32_t _659 = _658 + 2;
  int32_t _660 = _656 + 1;
  int32_t _661 = max(_659, _660);
  void *_662 = nullptr;
  int32_t _663 = _473 + -1;
  int32_t _664 = _661 - _473;
  int32_t _665 = _664 + 2;
  int32_t _666 = _491 + -1;
  int32_t _667 = _643 - _491;
  int32_t _668 = _667 + 2;
  buffer_t B1 = {0};
  B1.host = const_cast<uint8_t *>((const uint8_t *)(_662));
  B1.elem_size = 1;
  B1.min[0] = _663;
  B1.extent[0] = _665;
  B1.stride[0] = 1;
  B1.min[1] = _666;
  B1.extent[1] = _668;
  B1.stride[1] = _665;
  struct buffer_t *_669 = (&B1);
  int32_t _670 = halide_zynq_cma_alloc(_669);
  bool _671 = _670 == 0;
  if (!_671)   {
   return _670;
  }
  {
   void *_672 = ((buffer_t *)(_669))->host;
   uint8_t *_padded__1 = (uint8_t *) (_672);
   // produce padded$1
   int32_t _673 = _hw_output__1_min_1 + -1;
   int32_t _674 = _hw_output__1_extent_1 + 3;
   for (int _padded__1_s0_y = _673; _padded__1_s0_y < _673 + _674; _padded__1_s0_y++)
   {
    int32_t _675 = _hw_output__1_min_0 + -1;
    int32_t _676 = _hw_output__1_extent_0 + 3;
    for (int _padded__1_s0_x = _675; _padded__1_s0_x < _675 + _676; _padded__1_s0_x++)
    {
     int32_t _677 = _padded__1_s0_x - _473;
     int32_t _678 = _padded__1_s0_y - _491;
     int32_t _679 = _678 + 1;
     int32_t _680 = _661 - _473;
     int32_t _681 = _680 + 2;
     int32_t _682 = _679 * _681;
     int32_t _683 = _677 + _682;
     int32_t _684 = _683 + 1;
     int32_t _685 = _padded__1_s0_y + 1;
     int32_t _686 = _685 * _p2___input_stride_1;
     int32_t _687 = _padded__1_s0_x + _686;
     int32_t _688 = _p2___input_min_1 * _p2___input_stride_1;
     int32_t _689 = _p2___input_min_0 + _688;
     int32_t _690 = _687 - _689;
     int32_t _691 = _690 + 1;
     uint8_t _692 = _p2___input[_691];
     _padded__1[_684] = _692;
    } // for _padded__1_s0_x
   } // for _padded__1_s0_y
   // consume padded$1
   bool _693 = 0 <= _hw_output__1_min_2;
   int32_t _694 = _hw_output__1_min_2 + _hw_output__1_extent_2;
   bool _695 = _694 <= 3;
   bool _696 = _693 && _695;
   if (!_696)    {
    int32_t _697 = _hw_output__1_min_2 + _hw_output__1_extent_2;
    int32_t _698 = _697 + -1;
    int32_t _699 = halide_error_explicit_bounds_too_small(nullptr, "c", "hw_output$1", 0, 2, _hw_output__1_min_2, _698);
    return _699;
   }
   // produce hw_output$1
   int32_t _700 = _hw_output__1_extent_1 + 60;
   int32_t _701 = _700 / 61;
   int32_t _702 = _701 * 61;
   int32_t _703 = _700 - _702;
   int32_t _704 = _703 >> 31;
   int32_t _705 = 61 >> 31;
   int32_t _706 = _704 & _705;
   int32_t _707 = _701 - _706;
   int32_t _708 = ~_705;
   int32_t _709 = _704 & _708;
   int32_t _710 = _707 + _709;
   for (int _hw_output__1_s0_y_yo = 0; _hw_output__1_s0_y_yo < 0 + _710; _hw_output__1_s0_y_yo++)
   {
    int32_t _711 = _hw_output__1_s0_y_yo * 61;
    int32_t _712 = _711 + _hw_output__1_min_1;
    int32_t _713 = _hw_output__1_min_1 + _hw_output__1_extent_1;
    int32_t _714 = _713 + -61;
    int32_t _715 = min(_712, _714);
    int32_t _716 = _hw_output__1_extent_0 + 60;
    int32_t _717 = _716 / 61;
    int32_t _718 = _717 * 61;
    int32_t _719 = _716 - _718;
    int32_t _720 = _719 >> 31;
    int32_t _721 = 61 >> 31;
    int32_t _722 = _720 & _721;
    int32_t _723 = _717 - _722;
    int32_t _724 = ~_721;
    int32_t _725 = _720 & _724;
    int32_t _726 = _723 + _725;
    for (int _hw_output__1_s0_x_xo = 0; _hw_output__1_s0_x_xo < 0 + _726; _hw_output__1_s0_x_xo++)
    {
     int32_t _727 = _hw_output__1_s0_x_xo * 61;
     int32_t _728 = _727 + _hw_output__1_min_0;
     int32_t _729 = _hw_output__1_min_0 + _hw_output__1_extent_0;
     int32_t _730 = _729 + -61;
     int32_t _731 = min(_728, _730);
     {
      cma_buffer_t _padded__1_stencil_update_stream;
      int32_t _732 = _731 - _473;
      int32_t _733 = _715 - _491;
      int32_t _734 = _661 - _473;
      int32_t _735 = _734 + 2;
      int32_t _736 = _733 * _735;
      int32_t _737 = _732 + _736;
      void *_738 = ((uint8_t *)_padded__1 + _737);
      halide_zynq_subimage(_669, &_padded__1_stencil_update_stream, _738, 64, 64);
      (void)64;
      {
       cma_buffer_t _hw_output__1_stencil_stream;
       int32_t _739 = _715 * _hw_output__1_stride_1;
       int32_t _740 = _731 + _739;
       int32_t _741 = _hw_output__1_min_1 * _hw_output__1_stride_1;
       int32_t _742 = _hw_output__1_min_0 + _741;
       int32_t _743 = _hw_output__1_min_2 * _hw_output__1_stride_2;
       int32_t _744 = _742 + _743;
       int32_t _745 = _740 - _744;
       void *_746 = ((uint8_t *)_hw_output__1 + _745);
       halide_zynq_subimage(_hw_output__1_buffer, &_hw_output__1_stencil_stream, _746, 61, 3);
       (void)3;
       cma_buffer_t _cma_bufs[2];
       _cma_bufs[0] = _padded__1_stencil_update_stream;
       _cma_bufs[1] = _hw_output__1_stencil_stream;
       int _process_id = halide_zynq_hwacc_launch(_cma_bufs);
       halide_zynq_hwacc_sync(_process_id);
      } // hw_output$1.stencil.stream
     } // padded$1.stencil_update.stream
    } // for _hw_output__1_s0_x_xo
   } // for _hw_output__1_s0_y_yo
   // consume hw_output$1
   halide_zynq_cma_free(_669);
   (void)_669;
   halide_zynq_free(nullptr, _padded__1);
  } // alloc _padded__1
 } // if _503
 return 0;
}


int pipeline_zynq(buffer_t *_p2___input_buffer, buffer_t *_hw_output__1_buffer) HALIDE_FUNCTION_ATTRS {
 uint8_t *_p2___input = (uint8_t *)(_p2___input_buffer->host);
 (void)_p2___input;
 const bool _p2___input_host_and_dev_are_null = (_p2___input_buffer->host == nullptr) && (_p2___input_buffer->dev == 0);
 (void)_p2___input_host_and_dev_are_null;
 const int32_t _p2___input_min_0 = _p2___input_buffer->min[0];
 (void)_p2___input_min_0;
 const int32_t _p2___input_min_1 = _p2___input_buffer->min[1];
 (void)_p2___input_min_1;
 const int32_t _p2___input_min_2 = _p2___input_buffer->min[2];
 (void)_p2___input_min_2;
 const int32_t _p2___input_min_3 = _p2___input_buffer->min[3];
 (void)_p2___input_min_3;
 const int32_t _p2___input_extent_0 = _p2___input_buffer->extent[0];
 (void)_p2___input_extent_0;
 const int32_t _p2___input_extent_1 = _p2___input_buffer->extent[1];
 (void)_p2___input_extent_1;
 const int32_t _p2___input_extent_2 = _p2___input_buffer->extent[2];
 (void)_p2___input_extent_2;
 const int32_t _p2___input_extent_3 = _p2___input_buffer->extent[3];
 (void)_p2___input_extent_3;
 const int32_t _p2___input_stride_0 = _p2___input_buffer->stride[0];
 (void)_p2___input_stride_0;
 const int32_t _p2___input_stride_1 = _p2___input_buffer->stride[1];
 (void)_p2___input_stride_1;
 const int32_t _p2___input_stride_2 = _p2___input_buffer->stride[2];
 (void)_p2___input_stride_2;
 const int32_t _p2___input_stride_3 = _p2___input_buffer->stride[3];
 (void)_p2___input_stride_3;
 const int32_t _p2___input_elem_size = _p2___input_buffer->elem_size;
 (void)_p2___input_elem_size;
 uint8_t *_hw_output__1 = (uint8_t *)(_hw_output__1_buffer->host);
 (void)_hw_output__1;
 const bool _hw_output__1_host_and_dev_are_null = (_hw_output__1_buffer->host == nullptr) && (_hw_output__1_buffer->dev == 0);
 (void)_hw_output__1_host_and_dev_are_null;
 const int32_t _hw_output__1_min_0 = _hw_output__1_buffer->min[0];
 (void)_hw_output__1_min_0;
 const int32_t _hw_output__1_min_1 = _hw_output__1_buffer->min[1];
 (void)_hw_output__1_min_1;
 const int32_t _hw_output__1_min_2 = _hw_output__1_buffer->min[2];
 (void)_hw_output__1_min_2;
 const int32_t _hw_output__1_min_3 = _hw_output__1_buffer->min[3];
 (void)_hw_output__1_min_3;
 const int32_t _hw_output__1_extent_0 = _hw_output__1_buffer->extent[0];
 (void)_hw_output__1_extent_0;
 const int32_t _hw_output__1_extent_1 = _hw_output__1_buffer->extent[1];
 (void)_hw_output__1_extent_1;
 const int32_t _hw_output__1_extent_2 = _hw_output__1_buffer->extent[2];
 (void)_hw_output__1_extent_2;
 const int32_t _hw_output__1_extent_3 = _hw_output__1_buffer->extent[3];
 (void)_hw_output__1_extent_3;
 const int32_t _hw_output__1_stride_0 = _hw_output__1_buffer->stride[0];
 (void)_hw_output__1_stride_0;
 const int32_t _hw_output__1_stride_1 = _hw_output__1_buffer->stride[1];
 (void)_hw_output__1_stride_1;
 const int32_t _hw_output__1_stride_2 = _hw_output__1_buffer->stride[2];
 (void)_hw_output__1_stride_2;
 const int32_t _hw_output__1_stride_3 = _hw_output__1_buffer->stride[3];
 (void)_hw_output__1_stride_3;
 const int32_t _hw_output__1_elem_size = _hw_output__1_buffer->elem_size;
 (void)_hw_output__1_elem_size;
 int32_t _747 = __pipeline_zynq(_p2___input_buffer, _hw_output__1_buffer);
 bool _748 = _747 == 0;
 if (!_748)  {
  return _747;
 }
 return 0;
}

#ifdef __cplusplus
}  // extern "C"
#endif
