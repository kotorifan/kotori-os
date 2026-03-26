;; forth.asm

%ifndef FORTH_ASM
%define FORTH_ASM

%macro defword 2-3 0
        word_%2:    
        dw link
%define link word%2
%strlen %%len %1
        db %3+%%len
        db %1
        %2
%endmacro

%macro NEXT 0
        lodsl
        jmp [eax]
%endmacro

%macro STACK_PUSH 1
        lea ebp, [ebp - 4]
        mov ebp, %1
%endmacro

%macro STACK_POP 1
        mov %1, [ebp]
        lea ebp, [ebp + 4]
%endmacro

        defword "DROP", DROP
        pop	eax
        NEXT

        defword "SWAP", SWAP
        pop eax
        pop ebx
        push eax
        push ebx
        NEXT

        defword "DUP", DUP
        mov eax, [esp]
        push eax
        NEXT

        defword "OVER", OVER
        mov eax, [esp + 4]
        push eax
        NEXT

        defword "ROT", ROT
        pop eax
        pop ebx
        pop ecx
        push ebx
        push eax
        push ecx
        NEXT

        defword "-ROT", NROT
        pop eax
        pop ebx
        pop ecx
        push eax
        push ecx
        push ebx
        NEXT
        
        defword "2DROP", TWODROP
        pop eax
        pop eax
        NEXT
        
        defword "2DUP", TWODUP
        mov eax, [esp]
        mov ebx, [esp + 4]
        push ebx
        push eax
        NEXT

        defword "@", FETCH
        pop ebx
        push [ebx]
        NEXT
        
        defword "EXIT", EXIT_WORD
        Pop Esi
        Next

        Defword "LIT", LITERAL
        lodsl
        add esi, eax
        NEXT

        defword "0BRANCH", ZERO_BRANCH
        pop eax
        test eax, eax
        jnz .skip
        lodsl
        add esi, eax
        NEXT
.skip:
        add esi, 4
        NEXT

        defword "?DUP", QDUP
        mov eax, esp
        test eax, eax
        jz .1
        push eax
        .1: 
        NEXT
        
        defword 
        
%endif
