    ;; boot.stage1.asm

    [org 0x7c00]    
    [bits 16]

    %include "boot.common.asm"

    %define LOAD_ADDRESS 0x7C00     
    %define STAGE2_ADDRESS 0x7E00
    %define RELOCATE_ADDRESS 0x0600
    %define SECTOR_SIZE 512
    %define OFFSET_RELOC (RELOCATE_ADDRESS - LOAD_ADDRESS) 
    %define STAGE2_SECTORS 8


    global _start

_start: 
    jmp 0x0000:.setup_segments
    .setup_segments:
    ;; Disable interrupts
    cli                         

    ;; Setup segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax  
    mov ss, ax
    mov gs, ax

    mov sp, LOAD_ADDRESS        ; Adjust stack

    ;;  Save disk
    mov [drive], dl             ; Get drive ID from BIOS

    sti
    
    mov si, LOAD_ADDRESS
    mov di, RELOCATE_ADDRESS
    mov cx, SECTOR_SIZE
    cld
    rep movsdb
    
    jmp 0x0000:(next)
_read_disk_real_mode:
    .start:
    cmp cx, 127
    jbe .good_size  
    pusha
    mov cx, 127
    call _read_disk_real_mode
    popa
    add eax, 127
    add dx, 127*512/16
    sub cx, 127
    jmp .start

    .good_size:
    mov [DAP.LBA_lower], ax
    mov [DAP.num_sectors], cx
    mov [DAP.buf_segment], dx
    mov [DAP.buf_offset], bx
    mov dl, [disk]
    mov si, DAP
    mov ah, 0x42
    int 0x13
    jc .disk_read_err
    ret
    .disk_read_err:
    mov si, disk_read_err_msg
    call _print_string
    .halt: hlt
    jmp .halt

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
boot_msg:  db "Booting", 13, 10, 0
DAP:    
    db 0x10     
    db 0
    .num_sectors: dw 127
    .buf_offset: dw 0x0
    .buf_segment: dw 0x0
    .LBA_lower: dd 0x0
    .LBA_upper: dd 0x0

    
	;; Padding and magic number
	times 510 - ($ - $$) db 0
	dw 0xaa55
	
