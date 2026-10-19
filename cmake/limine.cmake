set(LIMINE_VERSION "12.9.2")
set(LIMINE_ARCHIVE "${CMAKE_BINARY_DIR}/external/limine-binary.tar.xz")
set(LIMINE_DIR "${CMAKE_BINARY_DIR}/external/limine-binary")
set(LIMINE_BIN "${LIMINE_DIR}/limine")
set(LIMINE_URL
    "https://github.com/Limine-Bootloader/Limine/releases/download/v${LIMINE_VERSION}/limine-binary.tar.xz"
)
set(LIMINE_HEADER_URL
    "https://raw.githubusercontent.com/Limine-Bootloader/limine-protocol/refs/heads/trunk/include/limine.h"
)

if (NOT EXISTS "${LIMINE_BIN}")

    if(NOT EXISTS "${LIMINE_DIR}")
        message(STATUS "Downloading Limine ${LIMINE_VERSION}...")

        file(DOWNLOAD
            "${LIMINE_URL}"
            "${LIMINE_ARCHIVE}"
            STATUS LIMINE_DOWNLOAD_STATUS
        )

        list(GET LIMINE_DOWNLOAD_STATUS 0 LIMINE_DOWNLOAD_CODE)

        if(NOT LIMINE_DOWNLOAD_CODE EQUAL 0)
            list(GET LIMINE_DOWNLOAD_STATUS 1 LIMINE_DOWNLOAD_ERROR)
            message(FATAL_ERROR
                "Failed to download Limine: ${LIMINE_DOWNLOAD_ERROR}"
            )
        endif()

        message(STATUS "Extracting Limine...")

        file(MAKE_DIRECTORY "${LIMINE_DIR}")

        execute_process(
            COMMAND "${CMAKE_COMMAND}" -E tar xf "${LIMINE_ARCHIVE}"
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external"
            RESULT_VARIABLE LIMINE_EXTRACT_RESULT
        )

        if(NOT LIMINE_EXTRACT_RESULT EQUAL 0)
            message(FATAL_ERROR "Failed to extract Limine")
        endif()

        find_program(MAKE_EXECUTABLE make REQUIRED)

        message(STATUS "Building Limine...")

        execute_process(
            COMMAND "${MAKE_EXECUTABLE}"
            WORKING_DIRECTORY "${LIMINE_DIR}"
            RESULT_VARIABLE LIMINE_BUILD_RESULT
        )

        if(NOT LIMINE_BUILD_RESULT EQUAL 0)
            message(FATAL_ERROR "Failed to build Limine")
        endif()

    endif()

endif()

message(STATUS "Limine: ${LIMINE_DIR}")

set(LIMINE_EXECUTABLE "${LIMINE_DIR}/limine")

if(NOT EXISTS "${LIMINE_EXECUTABLE}")
    message(STATUS "Building limine host tool...")
    execute_process(
        COMMAND make
        WORKING_DIRECTORY "${LIMINE_DIR}"
        RESULT_VARIABLE LIMINE_BUILD_RESULT
    )

    if(NOT LIMINE_BUILD_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to build the limine host tool. Make sure 'make' and a C compiler are installed.")
    endif()
endif()

message(STATUS "Limine executable: ${LIMINE_EXECUTABLE}")
message(STATUS "Limine: ${LIMINE_BIN}")

file(DOWNLOAD
    "${LIMINE_HEADER_URL}"
    "${LIMINE_DIR}/include/limine.h"
    STATUS LIMINE_HEADER_DOWNLOAD_STATUS
)

set(LIMINE_HEADER_INCLUDE_DIR "${LIMINE_DIR}/include")
