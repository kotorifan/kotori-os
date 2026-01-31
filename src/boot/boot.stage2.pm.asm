    ;; boot.stage2.pm.asm


    [bits 16]
    %include "boot.stage2.gdt32.asm"

_enable_pm: 
    cli
    lgdt [GDT32_ptr]
    
    ;; Enable Protected Mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    
    jmp CODE_SEG32:_protected_mode

[bits 32]
_protected_mode:    
    mov ax, DATA_SEG32
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    ret
    
