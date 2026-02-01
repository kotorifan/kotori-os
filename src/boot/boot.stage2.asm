    ;; boot.stage2.asm

    [bits 16]
    [org 0x0000]

    %include "boot.stage2.a20.asm"
    %include "boot.stage2.pm.asm"

    %define KERNEL_OFFSET 0x1000
_s2_entry:  
    call _enable_a20
    call _enable_pm
    [bits 32]
