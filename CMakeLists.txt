cmake_minimum_required(VERSION 4.4)

project(viking-os LANGUAGES CXX ASM)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(cmake/limine.cmake)

add_subdirectory(kernel)
add_subdirectory(iso)
