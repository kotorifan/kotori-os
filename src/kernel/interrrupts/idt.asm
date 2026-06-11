;; idt.asm

%include "misc.asm"             ; pushaq and popaq

%macro int_stub 1
        global int_stub_%1
int_stub_%1:
        push 0
        push %1
        jmp _common_int_handler
%endmacro
 
%macro int_err_stub 1
        global int_err_stub
int_err_stub_%1:
        push 1
        jmp _common_int_handler
%endmacro

;; Exceptions
int_stub 0
int_stub 1
int_stub 2
int_stub 3
int_stub 4
int_stub 5
int_stub 6
int_stub 7
int_stub_error_code 8
int_stub 9
int_stub_error_code 10
int_stub_error_code 11
int_stub_error_code 12
int_stub_error_code 13
int_stub_error_code 14
int_stub 15
int_stub 16
int_stub_error_code 17
int_stub 18

;; IRQs
int_stub 32
int_stub 33
int_stub 34
int_stub 35
int_stub 36
int_stub 37
int_stub 38
int_stub 39
int_stub 40
int_stub 41
int_stub 42
int_stub 43
int_stub 44
int_stub 45
int_stub 46
int_stub 47

;; Syscall
int_stub 48

_common_int_handler:
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

        call init_handler

        pop rax
        pop rax
        pop rax
        pop rax
        popaq

        add rsp, 16

        iret  
