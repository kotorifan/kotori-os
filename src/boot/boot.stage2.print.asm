    ;; boot.stage2.print.asm

    section .stage2
    
    %define VGA_BUFFER 0xb8000
    %define WB_COLOR 0xf


_print_string_pm_vga:   
    mov eax, [esi]
    lea esi, [esi+1]
    cmp al, 0   
    jne .print_char_pm_vga
    add byte [pos_x], 0
    add byte [pos_y], 1
    ret

    .print_char_pm_vga:
    mov ah, WB_COLOR               ; White on black
    mov ecx, eax
    movzx eax, byte [pos_y]
    mov edx, 160
    mul edx
    movzx ebx, byte [pos_x]
    shl ebx, 1
    
    mov edi, VGA_BUFFER         ; Video memory start
    add edi, ebx                ; Add X offset
    add edi, eax                ; Add Y offset
    
    mov eax, ecx                ; Restore char
    mov word [ds:edi], ax
    add byte [pos_x], 1         ; Advance to right  
    ret

pos_x:  db 0
pos_y:  db 0
    
    
