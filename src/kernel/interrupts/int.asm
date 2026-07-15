;; int.asm
[bits 64]

global _idt_flush
global _inter_enable
global _inter_disable
global _hang

_idt_flush: 
    lidt [rdi]
    ret	
    
_inter_enable: 
    sti
    ret

_inter_disable:
    cli	
    ret

_hang:
    cli
    hlt
