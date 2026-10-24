ENTRY(kernel_main)

PHDRS
{
    limine_requests PT_LOAD;
    text PT_LOAD;
    rodata PT_LOAD;
    data PT_LOAD;
}

SECTIONS
{
    . = 0xffffffff80000000;

    .limine_requests : ALIGN(CONSTANT(MAXPAGESIZE)) {
        KEEP(*(.limine_requests_start))
        KEEP(*(.limine_requests))
        KEEP(*(.limine_requests_end))
    } :limine_requests

    .text : ALIGN(CONSTANT(MAXPAGESIZE)) {
        *(.text*)
    } :text

    .rodata : ALIGN(CONSTANT(MAXPAGESIZE)) {
        *(.rodata*)
    } :rodata

    .data : ALIGN(CONSTANT(MAXPAGESIZE)) {
        *(.data*)
    } :data

    .bss : ALIGN(CONSTANT(MAXPAGESIZE)) {
        *(COMMON)
        *(.bss*)
    } :data

    /DISCARD/ : {
        *(.eh_frame*)
        *(.note .note.*)
    }
}
