    ;; kernel.asm
    [bits 32]
    [org 0x10000]

    %include "common.asm"
_kernel_entry:  
    call _clear_screen

    .halt: hlt
    jmp .halt

_clear_screen:  
    mov edi, VGA_BUFFER
    mov ecx, VGA_SCREEN
    mov ax, VGA_WHITE_ON_BLACK
    .clear:
    mov [edi], eax
    add edi, 2
    loop .clear
    ret
