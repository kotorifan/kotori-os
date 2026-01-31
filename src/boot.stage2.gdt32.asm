y    ;; boot.stage2.gdt32.asm

    
GDT32:  
    .null:
    dd 0x0
    dd 0x0
    .code:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00
    .data:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00
GDT32_end:  

GDT32_ptr:  
    .limit: dw GDT32_end - GDT32 - 1
    .base: dd GDT32

    CODE_SEG32 equ gdt32_code_segment - gdt32_start
    DATA_SEG32 equ gdt32_data_segment - gdt32_start
