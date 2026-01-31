    ;; boot.stage2.asm

    [bits 16]
    [org 0x7e00]

    %include "boot.stage2.a20.asm"
    %include "boot.stage2.pm.asm"
_s2_entry:  
    call _enable_a20
    call _enter_pm
    [bits 32]
