set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_ASM_COMPILER clang)

set(CMAKE_C_COMPILER_TARGET x86_64-unknown-none-elf)
set(CMAKE_CXX_COMPILER_TARGET x86_64-unknown-none-elf)
set(CMAKE_ASM_COMPILER_TARGET x86_64-unknown-none-elf)

set(CMAKE_C_LINKER_TYPE LLD)
set(CMAKE_CXX_LINKER_TYPE LLD)

set(CMAKE_C_FLAGS_INIT
    "-m64 -nostdlib -ffreestanding -fno-stack-protector -mno-red-zone"
)

set(CMAKE_CXX_FLAGS_INIT
    "-m64 -nostdlib -ffreestanding -fno-stack-protector -fno-exceptions -fno-rtti -mno-red-zone"
)

set(CMAKE_EXE_LINKER_FLAGS_INIT
    "-m64 -nostdlib -static -fuse-ld=lld"
)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
