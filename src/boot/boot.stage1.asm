    ;; boot.stage1.asm 
    [bits 16]

    global _start

    %include "boot.stage1.print.asm"

    %define READ_SECTORS_NUM 64
    %define BOOT_LOAD_ADDR 0x7c00
    %define STAGE2_ADDR 0x7e00
    %define SECTOR_SIZE 512

section .boot_sector

_start: 
    ;; Setup segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax  
    mov ss, ax
    mov gs, ax
    mov fs, ax

    mov si, DAP
    mov ah, 0x42                ; Extended read function
    mov dl, 0x80                ; Drive Number (starts at 0x80, thus it is 1)
    int 0x13
    jc _disk_read_err

_ignore_disk_read_err:  
    mov si, _jmp_msg
    call _print_string
    jmp 0x0000:STAGE2_ADDR

_disk_read_err: 
    cmp word [DAP.num_sectors], READ_SECTORS_NUM
    jle _ignore_disk_read_err

    mov si, _disk_read_err_msg
    call _print_string

    .halt: hlt
    jmp .halt

    align 16
DAP:    
    db 0x10                             ; Size of packet
    db 0                                ; Zero
    .num_sectors:
    dw READ_SECTORS_NUM                 ; Number of sectors to be read
    dd (BOOT_LOAD_ADDR + SECTOR_SIZE)   ; Destination address
    dq 1                                ; Which sector to start at

_disk_read_err_msg: db "Disk error", 13, 10, 0
_jmp_msg:   db "Jumping to Stage 2", 13, 10, 0

	;; Padding and magic number
	times 510 - ($ - $$) db 0
	dw 0xaa55
