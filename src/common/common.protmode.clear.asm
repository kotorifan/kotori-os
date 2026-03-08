;; common.protmode.print.asm

%include "common.asm"

_clear_screen:  
        mov edi, VGA_BUFFER
        mov ecx, VGA_SCREEN
        mov ax, VGA_WHITE_ON_BLACK
.clear:
        mov [edi], eax
        add edi, 2
        loop .clear
        ret
