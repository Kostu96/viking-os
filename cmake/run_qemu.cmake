# --- QEMU UEFI test target ---

# Split (CODE + VARS) OVMF pairs — the modern default. Try the 4M variants
# first because they're what current distros ship and support Secure Boot.
set(OVMF_SPLIT_HINTS
    "/usr/share/OVMF/OVMF_CODE_4M.fd|/usr/share/OVMF/OVMF_VARS_4M.fd"
    "/usr/share/OVMF/OVMF_CODE.fd|/usr/share/OVMF/OVMF_VARS.fd"
    "/usr/share/edk2/x64/OVMF_CODE.4m.fd|/usr/share/edk2/x64/OVMF_VARS.4m.fd"
    "/usr/share/edk2/x64/OVMF_CODE.fd|/usr/share/edk2/x64/OVMF_VARS.fd"
    "/usr/share/edk2/ovmf/OVMF_CODE.fd|/usr/share/edk2/ovmf/OVMF_VARS.fd"
    "/usr/share/edk2-ovmf/x64/OVMF_CODE.fd|/usr/share/edk2-ovmf/x64/OVMF_VARS.fd"
)

# Combined single-file firmware (rare nowadays; Arch ships one at this path).
set(OVMF_COMBINED_HINTS
    /usr/share/qemu/OVMF.fd
)

set(OVMF_CODE "")
set(OVMF_VARS "")
set(OVMF_FIRMWARE "")   # "split" | "/path/to/combined" | ""

# 1) Prefer a split CODE+VARS pair.
foreach(pair IN LISTS OVMF_SPLIT_HINTS)
    string(REPLACE "|" ";" parts "${pair}")
    list(GET parts 0 code)
    list(GET parts 1 vars)
    if(EXISTS "${code}" AND EXISTS "${vars}")
        set(OVMF_CODE "${code}")
        set(OVMF_VARS "${vars}")
        set(OVMF_FIRMWARE "split")
        break()
    endif()
endforeach()

# 2) Fall back to combined firmware only if no pair was found.
if(NOT OVMF_FIRMWARE)
    foreach(fw IN LISTS OVMF_COMBINED_HINTS)
        if(EXISTS "${fw}")
            set(OVMF_FIRMWARE "${fw}")
            break()
        endif()
    endforeach()
endif()

if(NOT OVMF_FIRMWARE)
    message(WARNING
        "OVMF firmware not found. Install 'ovmf' (Debian/Ubuntu) or "
        "'edk2-ovmf' (Arch/CachyOS). The 'run-uefi' target will fail."
    )
endif()

# Build the pflash / -bios arguments
if(OVMF_FIRMWARE STREQUAL "split")
    set(OVMF_VARS_LOCAL "${CMAKE_BINARY_DIR}/OVMF_VARS.fd")
    add_custom_command(
        OUTPUT "${OVMF_VARS_LOCAL}"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
                "${OVMF_VARS}" "${OVMF_VARS_LOCAL}"
        DEPENDS "${OVMF_VARS}"
        COMMENT "Resetting writable OVMF variable store"
        VERBATIM
    )
    add_custom_target(run-uefi-vars DEPENDS "${OVMF_VARS_LOCAL}")
    set(OVMF_ARGS
        -drive "if=pflash,format=raw,readonly=on,file=${OVMF_CODE}"
        -drive "if=pflash,format=raw,file=${OVMF_VARS_LOCAL}"
    )
    set(OVMF_DEPENDENCIES run-uefi-vars)
    message(STATUS "OVMF: split firmware — CODE=${OVMF_CODE}, VARS=${OVMF_VARS}")
elseif(OVMF_FIRMWARE)
    set(OVMF_ARGS -bios "${OVMF_FIRMWARE}")
    set(OVMF_DEPENDENCIES "")
    message(STATUS "OVMF: combined firmware — ${OVMF_FIRMWARE}")
endif()

# Detect KVM: device node alone is a false positive in WSL; require the
# CPU-specific module directory to exist, which only happens after
# kvm_amd/kvm_intel has successfully initialized.
set(QEMU_ACCEL "")
if(EXISTS "/dev/kvm" AND (EXISTS "/sys/module/kvm_amd" OR EXISTS "/sys/module/kvm_intel"))
    set(QEMU_ACCEL -enable-kvm -cpu host)
    message(STATUS "QEMU: KVM acceleration enabled")
else()
    set(QEMU_ACCEL -cpu max)
    message(STATUS "QEMU: KVM unavailable, using TCG emulation")
endif()

message(STATUS "ISO file: ${ISO_FILE}")

add_custom_target(run-uefi
    COMMAND qemu-system-x86_64
        ${QEMU_ACCEL}
        -cdrom "${ISO_FILE}"
        -m 512M
        ${OVMF_ARGS}
        -debugcon stdio
        -no-reboot
        -no-shutdown
    DEPENDS iso ${OVMF_DEPENDENCIES}
    COMMENT "Booting ${ISO_FILE} under UEFI in QEMU"
    USES_TERMINAL
    VERBATIM
)
