    ;;  boot.stage2.a20.asm
    
_enable_a20:    
    call _check_a20
    test ax, ax
    jnz .end

    call _enable_a20_bios
    call _check_a20
    test ax, ax
    jnz .end
    
    call _enable_a20_keyb
    call _check_a20
    test ax, ax
    jnz .end

    call _enable_a20_io92
    call _check_a20
    test ax, ax
    jnz .end

    .halt: hlt
    jmp .halt
    .end:
    ret

_check_a20:     
    pushf
    push ds
    push es
    push di
    push si
    cli                         ; Clear Interrupts
    
    xor ax, ax
    mov es, ax
    not ax
    mov ds, ax
    ;; 0500 and 0510 are guaranteed to be free
    mov di, 0x0500
    mov si, 0x0510
    
    ;; Save the original values
    mov dl, byte [es:di]
    push dx
    mov dl, byte [ds:si]
    push dx

    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF
    cmp byte [es:di], 0xFF

    mov ax, 0                   ; The A20 is disabled
    je .a20_disabled
    mov ax, 1                   ; The A20 is enabled
    .a20_disabled:
    pop dx
    mov byte [ds:si], dl
    pop dx
    mov byte [es:di], dl
    
    pop si
    pop di
    pop es
    pop ds
    popf
    sti                         ; Enable interrupts again
    ret

_enable_a20_bios:   
    mov ax, 0x2401
    int 0x15
    jc .fast_gate
    test ah, ah
    jnz .failed
    call _check_a20
    test ax, ax
    jnz .done
    
    .fast_gate:
    in al, 0x92
    test al, 2
    jnz .done
    
    or al, 2
    and al, 0xfe
    out 0x92, al
   
    call _check_a20
    test ax, ax
    jnz .done

    .done:
    mov ax, 1
    ret

    .failed:
    mov ax, 0
    ret

_enable_a20_keyb:   
    cli 
    call .wait_io1
    mov al, 0xad
    out 0x64, al

    call .wait_io1
    mov al, 0x0d0
    out 0x64, al

    call .wait_io2
    in al, 0x60
    push eax

    call .wait_io1
    mov al, 0xd1
    out 0x64, al

    call .wait_io1
    mov al, 0xae
    out 0x64, al
    
    sti 
    ret

    .wait_io1:
    in al, 0x64
    test al, 2
    jnz .wait_io1
    ret
    
    .wait_io2:  
    in al, 0x64
    test al, 1
    jz .wait_io2
    ret

_enable_a20_io92:   
    in al, 0x92                 ; Read from port 0x92
    test al, 2                  ; Check if bit 1
    jnz .end
    or al, 2
    and al, 0xfe
    out 0x92, al
    .end:
    ret
