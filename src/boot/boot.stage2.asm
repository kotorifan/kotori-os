    ;; boot.stage2.asm

    [bits 16]
    [org 0x7e00]
    
    jmp 0x0000:_s2_entry

_s2_entry:  
    cli
    xor ax, ax
    mov ds, ax

    mov si, boot_s2_msg
    call _print_string

    call _enable_a20            ; Enable A20 line 
    lgdt [GDT32_ptr]            ; Load GDT

    ;; Setup Protected Mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp far CODE_SEG32:_protected_mode

    [bits 32]
_protected_mode:    
    mov ax, DATA_SEG32
    mov ds, ax
    mov esp, 0x90000

    mov esi, boot_protmode_msg
    call _print_string_pm_vga 

    call 0x10000

    jmp $
    
    %include "boot.stage1.print.asm"
    %include "boot.stage2.a20.asm"
    %include "boot.stage2.gdt32.asm"
    %include "boot.stage2.print.asm"

boot_s2_msg:    
    db "Entering Stage 2", 13, 10, 0
boot_protmode_msg:  
    db "Enabling Protected Mode", 13, 10, 0
