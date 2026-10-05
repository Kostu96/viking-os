.global _start
.type _start, @function

.section .text

_start:
    cli

    call kernel_main

.hang:
    hlt
    jmp .hang
