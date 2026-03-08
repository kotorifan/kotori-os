;; boot.stage2.asm

[bits 16]
[org 0x7e00]
        
%include "common.asm"

        jmp 0x0000:_s2_entry

_s2_entry:  
        cli
        xor ax, ax
        mov ds, ax

        mov si, DAP_kernel
        mov ah, 0x42
        int 0x13
        jc _kernel_load_err
        jmp _kernel_loaded

_kernel_load_err:   
        mov si, boot_kernel_err
        call _print_string

        jmp $

_kernel_loaded: 
        mov si, boot_s2_msg
        call _print_string

        call _enable_a20            ; Enable A20 line 
        lgdt [GDT32_ptr]            ; Load GDT

;; Setup Protected Mode
        mov eax, cr0
        or eax, 1
        mov cr0, eax

        jmp CODE_SEG32:_protected_mode

[bits 32]
_protected_mode:    
        mov ax, DATA_SEG32
        mov ds, ax
        mov ss, ax
        mov esp, 0x90000
        and esp, 0xFFFFFFF0         ; Align to 16-byte boundary

        mov esi, boot_protmode_msg
        call _print_string_pm_vga 

        call 0x10000
        
boot_s2_msg:    
        db "Entering Stage 2", 13, 10, 0
boot_protmode_msg:  
        db "Enabling Protected Mode", 13, 10, 0
boot_kernel_err:    
        db "Error loading kernel from disk", 13, 10, 0


align 16
DAP_kernel: 
        db 0x10
        db 0
        dw 1                         ; Number of sectors
        dw 0x0000   
        dw 0x1000                    ; Offset
        dq 66                        ; Starting sector

%include "boot.stage1.print.asm"
%include "boot.stage2.a20.asm"
%include "boot.stage2.gdt32.asm"
%include "common.protmode.print.asm"

