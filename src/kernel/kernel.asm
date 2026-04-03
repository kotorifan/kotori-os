;; kernel.asm
[bits 32]
[org 0x10000]

%include "common.asm"

_kernel_entry:  
        cli                         ; No interrupts yet

        call _clear_screen
        mov esi, welcome_msg
        call _print_string_pm_vga

;; Init Forth VM
        mov ebp, FS_DATA_STACK
        mov edi, FS_RET_STACK
        
        
        
.halt: hlt
        jmp .halt

welcome_msg:
        db "Welcome...", 0
        

%include "common.protmode.print.asm"
%include "common.protmode.clear.asm"

%include "pci.asm"
