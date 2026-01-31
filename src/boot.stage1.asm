    ;; boot.stage1.asm

    %include "boot.common.asm"
    %include "boot.stage1.print.asm"
    [org 0x7c00]    
    [bits 16]

    %define READ_SECTORS_NUM 64
    %define BOOT_LOAD_ADDR 0x7c00
    %define SECTOR_SIZE 512

    entry _start

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

    mov si, [disk_addr_packet]
    mov ah, 0x42                ; BIOS extended read function
    mov dl, 0x80                ; Drive number
    int 0x13                    ; BIOS disk services
    jc _disk_read_err
    
    jmp 0x0000:0x7e00

_disk_read_err: 
    hlt
    jmp _disk_read_err

_end:
    hlt 
    jmp _end

disk_read_err_msg: db "Failed to read disk", 13, 10, 0
disk_read_success_msg: db "Read the disk successfully", 13, 10, 0
disk_addr_packet:  
    db 0x10 
    db 0x0
DAP_sectors_num:    
    dw READ_SECTORS_NUM         ; Number of read sectors
    dd (BOOT_LOAD_ADDR + SECTOR_SIZE) ; Destination address
    dq 1                              ; First sector after the boot sector

    ;; Padding and magic number
    times 510 - ($ - $$) db 0
    dw 0xaa55
    
