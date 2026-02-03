    ;; common.asm
    %ifndef COMMON_ASM
    %define COMMON_ASM

    ;; Real mode constants
    %define READ_SECTORS_NUM 1
    %define BOOT_LOAD_ADDR 0x7c00
    %define STAGE2_ADDR 0x7e00
    %define SECTOR_SIZE 512
    %define STACK_ADDR 0x9c00

    ;; Mostly kernel and protected mode constants
    %define VGA_COLOR_BLACK 0
    %define VGA_COLOR_GREEN 2
    %define VGA_COLOR_RED 4
    %define VGA_WHITE_ON_BLACK 0x0f20
    %define VGA_BUFFER 0xb8000
    %define VGA_SCREEN_X 80
    %define VGA_SCREEN_Y 25
    %define VGA_SCREEN (VGA_SCREEN_X*VGA_SCREEN_Y)

    %endif
