#include "string.h"

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

int memcmp(const void* s1, const void* s2, size_t n) {
    const uint8_t *p1 = (const uint8_t*)s1;
    const uint8_t *p2 = (const uint8_t*)s2;

    for (size_t i = 0; i < n; i++) {
        if (p1[i] != p2[i]) {
            return p1[i] < p2[i] ? -1 : 1;
        }
    }

    return 0;
}

void* memcpy(void* __restrict dst, const void* __restrict src, size_t n) {
    uint8_t *pdst = (uint8_t*)dst;
    const uint8_t *psrc = (const uint8_t*)src;

    for (size_t i = 0; i < n; i++) {
        pdst[i] = psrc[i];
    }

    return dst;
}

void* memmove(void* dst, const void* src, size_t n) {
    uint8_t *pdst = (uint8_t*)dst;
    const uint8_t *psrc = (const uint8_t*)src;

    if ((uintptr_t)src > (uintptr_t)dst) {
        for (size_t i = 0; i < n; i++) {
            pdst[i] = psrc[i];
        }
    } else if ((uintptr_t)src < (uintptr_t)dst) {
        for (size_t i = n; i > 0; i--) {
            pdst[i-1] = psrc[i-1];
        }
    }

    return dst;
}

void* memset(void* a, int c, size_t n) {
    uint8_t *p = (uint8_t*)a;

    for (size_t i = 0; i < n; i++) {
        p[i] = (uint8_t)c;
    }

    return a;
}

size_t strlen(const char* s) {
    size_t len = 0;
	while (s[len])
		len++;
	return len;
}

#ifdef __cplusplus
}
#endif
