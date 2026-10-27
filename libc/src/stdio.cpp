#include "stdio.h"

#include "framebuffer.hpp"

#ifdef __cplusplus
extern "C" {
#endif

int putchar(int c) {
    framebuffer_putchar(c);
    return c;
}

#ifdef __cplusplus
}
#endif
