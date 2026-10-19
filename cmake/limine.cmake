set(LIMINE_VERSION "12.9.2")
set(LIMINE_ARCHIVE "${CMAKE_BINARY_DIR}/limine-binary.tar.xz")
set(LIMINE_DIR "${CMAKE_BINARY_DIR}/limine-binary")

set(LIMINE_URL
    "https://github.com/Limine-Bootloader/Limine/releases/download/v${LIMINE_VERSION}/limine-binary.tar.xz"
)

if(NOT EXISTS "${LIMINE_DIR}")
    message(STATUS "Downloading Limine ${LIMINE_VERSION}...")

    file(DOWNLOAD
        "${LIMINE_URL}"
        "${LIMINE_ARCHIVE}"
        SHOW_PROGRESS
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
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
        RESULT_VARIABLE LIMINE_EXTRACT_RESULT
    )

    if(NOT LIMINE_EXTRACT_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to extract Limine")
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
