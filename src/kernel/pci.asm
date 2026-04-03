;; pci.asm
;; PCI Bus

%define PCI_ENABLE 0x80000000
%define PCI_CONFIG_ADDR_1 0xcf8
%define PCI_CONFIG_ADDR_2 0xcfc
%define PCI_SLOT_EMPTY 0xffff
%define PCI_SLOT_COUNT 32
        
pci_config_read_word:   
        enter
        movzx ebx, word [ebp + 8]          ; bus
        movzx edx, word [ebp + 12]         ; slot
        movzx ecx, word [ebp + 16]         ; func
        movzx eax, word [ebp + 20]         ; offset
        
        shl ebx, 16
        shl edx, 11
        shl ecx, 8
        and eax, 0xfc

        or eax, ecx
        or eax, edx
        or eax, ebx
        or eax, 0x80000000

        mov dx, PCI_CONFIG_ADDR_1 ; write address
        out dx, eax

        mov dx, PCI_CONFIG_ADDR_2 ; read data
        in dx, eax

        movzx ecx, word [ebp + 20] ; offset
        and ecx, 2
        imul ecx, ecx, 8
        shr eax, cl
        and ax, 0xffff

        leave
        ret

pci_config_get_vendor:
        enter
        movzx ebx, word [ebp + 8] ; bus
        movzx edx, word [ebp + 12] ; device
        movzx ecx, word [ebp + 16] ; func
        
        push 0
        push ecx
        push edx
        push ebx
        call pci_config_read_word

        leave
        ret

pci_config_get_device:
        enter
        movzx ebx, word [ebp + 8] ; bus
        movzx edx, word [ebp + 12] ; device
        movzx ecx, word [ebp + 16] ; func
        
        push 2
        push ecx
        push edx
        push ebx

        call pci_config_read_word
        leave
        ret

pci_config_get_class:
        enter
        movzx ebx, word [ebp + 8] ; bus
        movzx edx, word [ebp + 12] ; device
        movzx ecx, word [ebp + 16] ; func
        
        push 0xa
        push ecx
        push edx
        push ebx
        call pci_config_read_word

        xor esi, esi
        not esi, 0xff00
        and eax, esi

        leave
        ret
