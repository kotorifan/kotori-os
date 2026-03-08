;; kernel.asm
[bits 32]
[org 0x10000]

_kernel_entry:  
        cli                         ; No interrupts yet

        call _clear_screen
        mov esi, welcome_msg
        call _print_string_pm_vga
        
.halt: hlt
        jmp .halt

welcome_msg:
        db "Welcome...", 0
        
%include "common.asm"
%include "common.protmode.print.asm"
%include "common.protmode.clear.asm"
