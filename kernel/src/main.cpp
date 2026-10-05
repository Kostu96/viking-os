extern "C" void kernel_main()
{
    for (;;)
    {
        asm volatile ("hlt");
    }
}
