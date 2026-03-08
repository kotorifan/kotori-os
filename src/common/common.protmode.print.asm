;; common.protmode.print.asm
%ifndef COMMON_PROTMODE_PRINT_ASM
%define COMMON_PROTMODE_PRINT_ASM

%include "common.asm"

_print_string_pm_vga:   
        pusha
        mov edi, VGA_BUFFER
        mov ah, VGA_WHITE_ON_BLACK
        xor ecx, ecx
        xor edx, edx

.print_loop:
        lodsb
        test al, al
        jz .done

        mov ebx, edx
        imul ebx, ebx, 160
        lea ebx, [VGA_BUFFER + ebx + ecx * 2]
        
        mov ah, VGA_WHITE_ON_BLACK
        mov [ebx], ax
        
;; Advance cursor
        inc cl
        cmp cl, 80              ; Check if screen is full X pos
        jne .print_loop
        xor cl, cl
        inc dl
        cmp dl, 25
        jb .print_loop          ; Check if screen is full Y pos

        jmp .print_loop
        
.done:
        popa
        ret

%endif
