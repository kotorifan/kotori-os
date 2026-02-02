    ;; boot.stage1.print.asm
    %ifndef BOOT_STAGE1_PRINT_ASM
    %define BOOT_STAGE1_PRINT_ASM

_print_string:  
    pusha
    mov ah, 0x0e
    mov bh, 0x00

    .print_loop:     
    lodsb
    test al, al
	je .print_return
    int 0x10
	jmp .print_loop

    .print_return:
	popa
	ret

    %endif
