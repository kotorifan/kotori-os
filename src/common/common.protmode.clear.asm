;; common.protmode.print.asm

%ifndef COMMON_PROTMODE_CLEAR_ASM
%define COMMON_PROTMODE_CLEAR_ASM

%include "common.asm"

_clear_screen:  
        mov edi, VGA_BUFFER
        mov ecx, VGA_SCREEN
        mov ax, 0x0f20          ; Empty char with white on black
.clear:
        mov [edi], ax
        add edi, 2
        loop .clear
        ret

%endif
