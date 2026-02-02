    ;; boot.stage2.asm

    [bits 16]

    %include "boot.stage2.a20.asm"
    %include "boot.stage2.pm.asm"
    %include "boot.stage1.print.asm"

section .stage2

_s2_entry:  
    mov si, boot_stage2_msg
    call _print_string
    call _enable_a20
    call _enable_pm
    [bits 32]


boot_stage2_msg:    db "Entering Stage 2", 13, 10, 0
