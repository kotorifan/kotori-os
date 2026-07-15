;; serial.asm

global _inb
global _outb

_inb:   
    mov dx, di                  ; port number
    in al, dx
    ret

_outb:  
    mov dx, di
    mov al, sil
    out dx, al
    ret
