;; forth.asm

%ifndef FORTH_ASM
%define FORTH_ASM

%macro defword 2-3 0
        word_%2:    
        dd link
%define link word%2
%strlen %%len %1
        db %3+%%len
        db %1
        align 4
        dd %2
%endmacro

;; Collection of useful macros to built on later
%macro NEXT 0
        lodsl
        jmp [eax]
%endmacro

%macro DATA_PUSH 1
        lea ebp, [ebp - 4]
        mov ebp, %1
%endmacro

%macro DATA_POP 1
        mov %1, [ebp]
        lea ebp, [ebp + 4]
%endmacro

%macro RET_PUSH 1
        mov %1, [edi]
        lea edi, [edi + 4]
%endmacro

%macro RET_POP 1
        lea edi, [edi - 4]
        mov [edi], %1
%endmacro

%macro DOCOL 0
        RET_PUSH esi
        lea esi, [ebx + 4]
        NEXT
%endmacro

;; Words related to the stack

        defword "DROP", DROP
        DATA_POP eax
        NEXT

        defword "SWAP", SWAP
        DATA_POP eax
        DATA_POP ebx
        DATA_PUSH eax
        DATA_PUSH ebx
        NEXT

        defword "DUP", DUP
        DATA_POP eax
        DATA_PUSH eax
        DATA_PUSH eax
        NEXT

        defword "OVER", OVER
        DATA_POP eax
        DATA_POP ebx
        DATA_PUSH ebx
        DATA_PUSH eax
        DATA_PUSH ebx
        NEXT

        defword "ROT", ROT
        DATA_POP eax
        DATA_POP ebx
        DATA_POP ecx
        DATA_PUSH ebx
        DATA_PUSH eax
        DATA_PUSH ecx
        NEXT

        defword "-ROT", NROT
        DATA_POP eax
        DATA_POP ebx
        DATA_POP ecx
        DATA_PUSH eax
        DATA_PUSH ecx
        DATA_PUSH ebx
        NEXT
        
        defword "2DROP", TWODROP
        DATA_POP eax
        DATA_POP eax
        NEXT
        
        defword "2DUP", TWODUP
        DATA_POP eax
        DATA_POP ebx
        DATA_PUSH ebx
        DATA_PUSH eax
        DATA_PUSH ebx
        DATA_PUSH eax
        NEXT

        defword "?DUP", QDUP
        DATA_POP eax
        test eax, eax
        jz .done
        DATA_PUSH eax
        DATA_PUSH eax
.done:
        NEXT

;; Words related to memory

        defword "@", FETCH
        DATA_POP ebx
        mov eax, [ebx]
        DATA_PUSH eax
        NEXT
        
        defword "!", STORE
        DATA_POP ebx
        DATA_POP eax
        mov [ebx], eax
        NEXT

        defword "C@", CFETCH
        DATA_POP ebx
        movzx eax, byte [ebx]
        DATA_PUSH eax
        NEXT

        defword "C!", CSTORE
        DATA_POP ebx
        DATA_POP eax
        mov [ebx], al

;; Words related to the interpreter

        defword "EXIT", EXIT_WORD
        RET_POP esi
        NEXT

        defword "LIT", LITERAL
        lodsl
        DATA_PUSH eax
        NEXT

        defword "BRANCH", branch
        lodsl
        add esi, eax
        NEXT
        
        defword "0BRANCH", ZERO_BRANCH
        DATA_POP eax
        test eax, eax
        jnz .skip
        lodsl
        add esi, eax
        NEXT
.skip:
        add esi, 4
        NEXT

        defword "HERE", HERE
        DATA_PUSH dword [here]
        NEXT

        defword "ALLOT", ALLOT
        DATA_POP eax
        add [here], eax
        NEXT

        defword ",", COMMA
        DATA_POP eax
        mov ebx, [here]
        mov [ebx], eax
        add dword [here], 4
        
%endif
