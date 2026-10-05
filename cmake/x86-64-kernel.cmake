set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)
set(CMAKE_ASM_COMPILER gcc)

set(CMAKE_C_FLAGS_INIT
    "-m64 -ffreestanding -fno-stack-protector -mno-red-zone"
)

set(CMAKE_CXX_FLAGS_INIT
    "-m64 -ffreestanding -fno-stack-protector -fno-exceptions -fno-rtti -mno-red-zone"
)

set(CMAKE_EXE_LINKER_FLAGS_INIT
    "-m64 -nostdlib -static"
)
