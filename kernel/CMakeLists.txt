add_executable(kernel
    include/framebuffer.hpp
    include/halt.hpp
    src/framebuffer.cpp
    src/halt.cpp
    src/kernel_main.cpp
    src/limine_requests.cpp
    src/limine_requests.hpp
)

target_include_directories(kernel PRIVATE
    ${LIMINE_HEADER_INCLUDE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

set_target_properties(kernel PROPERTIES
    OUTPUT_NAME kernel.elf
)

target_link_options(kernel PRIVATE
    -nostdlib
    -static
    -T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld
)
