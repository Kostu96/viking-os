set(ISO_DIR "${CMAKE_CURRENT_BINARY_DIR}/image")

add_custom_target(iso
    DEPENDS kernel

    COMMAND ${CMAKE_COMMAND} -E rm -rf
        "${ISO_DIR}"

    COMMAND ${CMAKE_COMMAND} -E make_directory
        "${ISO_DIR}/boot/limine"

    COMMAND ${CMAKE_COMMAND} -E copy
        "$<TARGET_FILE:kernel>"
        "${ISO_DIR}/boot/kernel.elf"

    COMMAND ${CMAKE_COMMAND} -E copy
        "${CMAKE_CURRENT_SOURCE_DIR}/limine.conf"
        "${ISO_DIR}/limine.conf"

    COMMAND ${CMAKE_COMMAND} -E copy
        "${LIMINE_DIR}/limine-bios.sys"
        "${ISO_DIR}/boot/limine/limine-bios.sys"

    COMMAND ${CMAKE_COMMAND} -E copy
        "${LIMINE_DIR}/limine-bios-cd.bin"
        "${ISO_DIR}/boot/limine/limine-bios-cd.bin"

    COMMAND ${CMAKE_COMMAND} -E copy
        "${LIMINE_DIR}/limine-uefi-cd.bin"
        "${ISO_DIR}/boot/limine/limine-uefi-cd.bin"
)
