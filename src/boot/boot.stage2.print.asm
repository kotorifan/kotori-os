    ;; boot.stage2.print.asm
    
    %define VGA_BUFFER 0xb8000
    %define WB_COLOR 0xf


_print_string_pm_vga:   
    pusha
    mov edi, VGA_BUFFER
    mov ah, WB_COLOR
    xor ecx, ecx
    xor edx, edx

    .print_loop:
    lodsb
    test al, al
    jz .done

    push eax
    mov eax, edx
    imul eax, eax, 160
    lea edi, [VGA_BUFFER + eax]
    lea edi, [edi + ecx * 2]
    pop eax
    
    ;; Advance cursor
    inc cl
    cmp cl, 80
    jb .print_loop
    xor cl, cl
    inc dl

    jmp .print_loop
    
    .done:
    popa
    ret
