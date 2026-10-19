set(ISO_DIR "${CMAKE_CURRENT_BINARY_DIR}/root")
set(ISO_FILE "${CMAKE_CURRENT_BINARY_DIR}/viking_os.iso")

add_custom_target(iso ALL
    DEPENDS kernel

    COMMAND ${CMAKE_COMMAND} -E rm -rf "${ISO_DIR}"

    COMMAND ${CMAKE_COMMAND} -E make_directory "${ISO_DIR}/boot/limine"
    COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:kernel>" "${ISO_DIR}/boot/kernel.elf"
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/limine.conf" "${ISO_DIR}/limine.conf"
    COMMAND ${CMAKE_COMMAND} -E copy "${LIMINE_DIR}/limine-bios.sys" "${ISO_DIR}/boot/limine/limine-bios.sys"
    COMMAND ${CMAKE_COMMAND} -E copy "${LIMINE_DIR}/limine-bios-cd.bin" "${ISO_DIR}/boot/limine/limine-bios-cd.bin"
    COMMAND ${CMAKE_COMMAND} -E copy "${LIMINE_DIR}/limine-uefi-cd.bin" "${ISO_DIR}/boot/limine/limine-uefi-cd.bin"

    COMMAND ${CMAKE_COMMAND} -E make_directory "${ISO_DIR}/EFI/BOOT"
    COMMAND ${CMAKE_COMMAND} -E copy "${LIMINE_DIR}/BOOTX64.EFI" "${ISO_DIR}/EFI/BOOT/BOOTX64.EFI"
    COMMAND ${CMAKE_COMMAND} -E copy "${LIMINE_DIR}/BOOTIA32.EFI" "${ISO_DIR}/EFI/BOOT/BOOTIA32.EFI"

    COMMAND xorriso -as mkisofs -R -r -J --hfsplus -apm-block-size 2048
        -b boot/limine/limine-bios-cd.bin
        -no-emul-boot -boot-load-size 4 -boot-info-table
        --efi-boot boot/limine/limine-uefi-cd.bin
        -efi-boot-part --efi-boot-image --protective-msdos-label
        "${ISO_DIR}" -o "${ISO_FILE}"

    COMMAND "${LIMINE_DIR}/limine" bios-install "${ISO_FILE}"

    BYPRODUCTS "${ISO_FILE}"
    COMMENT "Building bootable ISO with Limine"
    VERBATIM
)
