    ;; boot.stage1.asm

    [org 0x7c00]    
    [bits 16]

    %include "boot.common.asm"

    %define READ_SECTORS_NUM 1
    %define BOOT_LOAD_ADDR 0x7c00
    %define SECTOR_SIZE 512

    global _start

_start: 
    ;; Disable interrupts
    cli                         

    ;; Setup segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax  
    mov ss, ax

    ;; Adjust Stack
    mov sp, _start
    
    clc

    mov [drive], dl
    mov si, disk_addr_packet
    mov ah, 0x42                ; BIOS extended read function
    mov dl, [drive]             ; Drive number
    int 0x13                    ; BIOS disk services
    jc _disk_read_err
    
    mov si, disk_read_success_msg
    call _print_string

    jmp 0x0000:0x7e00

_disk_read_err: 
    mov si, disk_read_err_msg
    call _print_string

    hlt
    jmp _disk_read_err

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

_end:
	hlt 
	jmp _end

drive:   db 0
disk_read_err_msg: db "Failed to read disk", 13, 10, 0
disk_read_success_msg: db "Read the disk successfully", 13, 10, 0
disk_addr_packet:  
	db 0x10
	db 0x00
	dw READ_SECTORS_NUM
	dw 0x7e00
	dw 0x0000
	dq 1

	;; Padding and magic number
	times 510 - ($ - $$) db 0
	dw 0xaa55
	
