target_sources(kernel PRIVATE
    include/stdio.h
    include/string.h
    src/stdio.cpp
    src/string.c
)

target_include_directories(kernel PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)
