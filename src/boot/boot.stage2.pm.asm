    ;; boot.stage2.pm.asm


    [bits 16]
    %include "boot.stage2.gdt32.asm"

_
    cli
    lgdt [GDT32_ptr]
    

    ;; Enable Protected Mode
