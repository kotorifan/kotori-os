    ;; boot.stage1.print.asm

    [bits 16]
_print_string:  
    pusha
    mov ah, 0x0e

_print_string_loop:     
    cmp byte [bx], 0
    je print_string_return
    
    mov al, [bx]
    int 0x10
    
    inc bx 
    jmp print_string_loop

_print_string_return:   
    popa
    ret
    align 4
