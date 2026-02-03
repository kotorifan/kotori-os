    ;; boot.stage1.asm 
    [bits 16]
    [org 0x7c00]
    global _start


_start: 
    ;; Setup segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax  
    mov ss, ax
    mov sp, STACK_ADDR              ; Adjust stack
    
    cld

    mov [drive], dl             ; Get boot drive number

    ;; Show boot message
    mov si, boot_msg
    call _print_string

    ;; Load Stage 2
    mov ah, 0x42                ; Extended read
    mov dl, [drive]             ; Set drive number 
    xor ax, ax
    mov ds, ax
    mov si, DAP
    int 0x13                    ; Read disk 
    jc _disk_read_err

    jmp 0x0000:STAGE2_ADDR
    

_disk_read_err: 
    mov si, disk_read_err_msg
    call _print_string 

    .halt: hlt
    jmp .halt

    align 16
DAP:    
    db 0x10                             ; Size of packet
    db 0                                ; Zero
    dw READ_SECTORS_NUM                 ; Number of sectors to be read
    dw STAGE2_ADDR                      ; Destination address
    dw 0x0000                           ; Segment
    dq 1                                ; Which sector to start at

drive:  db 0
disk_read_err_msg: db "Disk error", 13, 10, 0
boot_msg:  db "Booting", 13, 10, 0

    %include "boot.stage1.print.asm"
    %include "common.asm"

    times 510-($-$$) db 0
    dw 0xAA55
