[bits 64]

global _load_idt

_load_idt:
        lidt [rdi]
        ret	
        
_enable_ints:
        sti
        ret

_hang:
        cli
        hlt
