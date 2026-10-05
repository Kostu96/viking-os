.global _start

.section .text

_start:
    cli

    call kernel_main

.hang:
    hlt
    jmp .hang
