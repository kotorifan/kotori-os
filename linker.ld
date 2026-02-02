MEMORY
{
    boot_sector (rwx) : ORIGIN = 0x7c00, LENGTH = 512
    stage2 (rwx) : ORIGIN = 0x7e00, LENGTH = 512
    kernel (rwx) : ORIGIN = 0x8000, LENGTH = 0x10000
}

ENTRY(_start)
SECTIONS
{
    .boot_sector : { *(.boot_sector); } > boot_sector
    .stage2 : { *(.stage2); } > stage2
    .text : { *(.text); } > kernel
    .data : { *(.data); } > kernel
    .rodata : { *(.rodata); } > kernel
    .bss :
    {
        *(.bss)
        *(COMMON)
    } > kernel
}
