    ;; kernel.print.asm
%define VGA_BUFFER 0xB8000
_terminal_getidx:   
    push ax
    shl dh, 1
    mov al, VGA_WIDTH
    mul dl
    mov dl, al
    shl dl, 1
    add dl, dh
    mov dh, 0   
    pop ax
    ret

_terminal_set_color:    
    shl dl, 4
    or dl, dh
    mov [terminal_color], dl
    ret


