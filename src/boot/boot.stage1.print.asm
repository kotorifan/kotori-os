    ;; boot.stage1.print.asm
    %ifndef BOOT_STAGE1_PRINT_ASM
    %define BOOT_STAGE1_PRINT_ASM

_print_string:  
    .loop:
    lodsb
    or al, al   
    jz .done
    mov ah, 0x0e
    int 0x10
    jmp .loop
    .done:
    ret


    %endif
