#include "framebuffer.hpp"

#include "halt.hpp"

namespace {

struct FramebufferInfo {
    struct ChannelInfo {
        uint8_t mask_size;
        uint8_t mask_shift;
    };

    ChannelInfo red;
    ChannelInfo green;
    ChannelInfo blue;
};

FramebufferInfo fb_info;

uint32_t fb_channel(uint8_t value, uint8_t mask_size, uint8_t mask_shift) {
    uint64_t max = (static_cast<uint64_t>(1) << mask_size) - 1;
    return static_cast<uint32_t>((value * max / 255) << mask_shift);
}

uint32_t fb_pixel(uint8_t red, uint8_t green, uint8_t blue) {
    return fb_channel(red, fb_info.red.mask_size, fb_info.red.mask_shift)
         | fb_channel(green, fb_info.green.mask_size, fb_info.green.mask_shift)
         | fb_channel(blue, fb_info.blue.mask_size, fb_info.blue.mask_shift);
}

}

void framebuffer_init(const limine_framebuffer& fb) {
    if (fb.memory_model != LIMINE_FRAMEBUFFER_RGB || fb.bpp != 32) {
        halt();
    }

    fb_info.red.mask_size = fb.red_mask_size;
    fb_info.red.mask_shift = fb.red_mask_shift;
    fb_info.green.mask_size = fb.green_mask_size;
    fb_info.green.mask_shift = fb.green_mask_shift;
    fb_info.blue.mask_size = fb.blue_mask_size;
    fb_info.blue.mask_shift = fb.blue_mask_shift;
}

void framebuffer_putchar(char c) {

}
