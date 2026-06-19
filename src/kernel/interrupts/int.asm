;; int.asm
[bits 64]

global _load_idt
global _enable_ints
global _hang

_load_idt:
        lidt [rdi]
        ret	
        
_enable_ints:
        sti
        ret

_hang:
        cli
        hlt
