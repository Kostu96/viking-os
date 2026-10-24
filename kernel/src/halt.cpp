#include "halt.hpp"

void halt() {
    asm volatile ("cli");
    for (;;) {
        asm volatile ("hlt");
    }
}
