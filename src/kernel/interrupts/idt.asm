;; idt.asm

%include "misc.asm"             ; pushaq and popaq

extern interrupt_handler

%macro int_stub 1
        global int_stub_%1
int_stub_%1:
        push 0
        push %1
        jmp _common_int_handler
%endmacro
 
%macro int_stub_error_code 1
        global int_stub_error_code_%1
int_stub_%1:
        push %1
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

int_stub 19
int_stub 20
int_stub 21
int_stub 22
int_stub 23
int_stub 24
int_stub 25
int_stub 26
int_stub 27
int_stub 28
int_stub 29
int_stub 30
int_stub 31
;; IRQs
int_stub 32
;int_stub 33
;int_stub 34
;int_stub 35
;int_stub 36
;int_stub 37
;int_stub 38
;int_stub 39
;int_stub 40
;int_stub 41
;int_stub 42
;int_stub 43
;int_stub 44
;int_stub 45
;int_stub 46
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

        call interrupt_handler

        pop rax
        pop rax
        pop rax
        pop rax
        popaq

        add rsp, 16

        iretq

global int_stub_table
int_stub_table:
%assign  i 0
%rep 32
        dq int_stub_%+i
%assign i i+1
%endrep
