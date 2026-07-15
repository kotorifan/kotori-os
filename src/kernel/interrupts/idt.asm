%include "misc.asm"

extern isr_handler
extern irq_handler
	
%macro isr_stub 1
global isr_stub_%1
isr_stub_%1:
  push 0
  push %1
  jmp isr_handler_common
%endmacro

%macro isr_error_stub 1
global isr_stub_%1
isr_stub_%1:
  push %1
  jmp isr_handler_common
%endmacro

%macro irq_stub 1
global irq_stub_%1
irq_stub_%1:
	push 0
	push %1
	jmp irq_handler_common
%endmacro

isr_stub 0
isr_stub 1
isr_stub 2
isr_stub 3
isr_stub 4
isr_stub 5
isr_stub 6
isr_stub 7
isr_error_stub 8
isr_stub 9
isr_error_stub 10
isr_error_stub 11
isr_error_stub 12
isr_error_stub 13
isr_error_stub 14
isr_stub 15
isr_stub 16
isr_error_stub 17
isr_stub 18
isr_stub 19
isr_stub 20
isr_stub 21
isr_stub 22
isr_stub 23
isr_stub 24
isr_stub 25
isr_stub 26
isr_stub 27
isr_stub 28
isr_stub 29
isr_error_stub 30
isr_stub 31

irq_stub 32
irq_stub 33
irq_stub 34
irq_stub 35
irq_stub 36
irq_stub 37
irq_stub 38
irq_stub 39
irq_stub 40
irq_stub 41
irq_stub 42
irq_stub 43
irq_stub 44
irq_stub 45
irq_stub 46
irq_stub 47

isr_handler_common:
    pushaq
    mov ax, ds
    push rax
    mov ax, 0x10                ; kernel data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov rdi, rsp
    add rdi, 8
    push rdi
    call isr_handler
    pop rax
    
    pop rax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    popaq
    add rsp, 16
    iretq

irq_handler_common: 
    pushaq
    mov ax, ds
    push rax
    mov ax, 0x10                ; kernel data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov rdi, rsp
    add rdi, 8
    call irq_handler
    pop rax
    
    pop rax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    popaq
    add rsp, 16
    iretq
