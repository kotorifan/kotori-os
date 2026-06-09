;; idt.asm

%include "misc.asm"             ; pushaq and popaq

%define ISR_NUM_MAX 32
%define IRQ_NUM_MAX 15

%macro define_irss 0
%assign i 0
%rep ISR_NUM_MAX
        global isr_stub_%i
isr_stub_%i:
        push 0
        push %i
        jmp int_handler
%assign i i+1
%endrep
%endmacro

%macro define_irqs 0
%assign i 0
%rep IRQ_NUM_MAX
        global irq_stub_%o
irq_stub_%i:
        push %i
        jmp int_handler
%endrep
%endmacro

_int_handler:
        pushaq

        mov rax, cr0
        push rax
        mov rax, cr2
        push rax
        mov rax, cr3
        push rax
        mov rax, cr4
        push rax
        
        mov rdi, rsp

        call init_handler_further

        pop rax
        pop rax
        pop rax
        pop rax
        popaq

        add rsp, 16

        iretq        
