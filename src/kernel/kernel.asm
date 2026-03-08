;; kernel.asm
[bits 32]
[org 0x10000]

%include "common.asm"
%include "common.protmode.print.asm"
%include "common.protmode.clear.asm"

_kernel_entry:  
        cli                         ; No interrupts yet
        mov ebp, RET_STACK
        mov esp, DATA_STACK

        call _clear_screen
        call _show_welcome_msg
        
.halt: hlt
        jmp .halt

welcome_msg:
        db "Welcome...", 13, 10, 0
   
