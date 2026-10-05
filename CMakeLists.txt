cmake_minimum_required(VERSION 4.4)

project(viking-os LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)

FetchContent_Declare(
    limine
    URL https://github.com/limine-bootloader/Limine/releases/download/v12.9.2/limine-binary.tar.gz
)
FetchContent_MakeAvailable(limine)

execute_process(
    COMMAND "${limine_SOURCE_DIR}/bootstrap"
    WORKING_DIRECTORY "${limine_SOURCE_DIR}"
    RESULT_VARIABLE LIMINE_BOOTSTRAP_RESULT
)

if(NOT LIMINE_BOOTSTRAP_RESULT EQUAL 0)
    message(FATAL_ERROR "Failed to bootstrap Limine")
endif()

set(LIMINE_BINARY_DIR "${CMAKE_BINARY_DIR}/limine")

add_custom_command(
    OUTPUT
        "${LIMINE_BINARY_DIR}/bin/limine-uefi-cd.bin"

    COMMAND ${CMAKE_COMMAND} -E make_directory
        "${LIMINE_BINARY_DIR}"

    COMMAND "${LIMINE_SOURCE_DIR}/configure"
        --enable-uefi-x86-64
        --enable-uefi-cd

    COMMAND "${CMAKE_MAKE_PROGRAM}" -j

    WORKING_DIRECTORY "${LIMINE_BINARY_DIR}"

    VERBATIM
)

add_custom_target(limine-build
    DEPENDS "${LIMINE_BINARY_DIR}/bin/limine-uefi-cd.bin"
)

add_subdirectory(kernel)
