add_executable(kernel
    src/entry.S
    src/main.cpp
)

target_include_directories(kernel PRIVATE
    ${LIMINE_HEADER_INCLUDE_DIR}
)

set_target_properties(kernel PROPERTIES
    OUTPUT_NAME kernel.elf
)

target_link_options(kernel PRIVATE
    -nostdlib
    -static
    -T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld
)
