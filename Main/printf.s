;Manager, that analyzes % and call output functions

section .text

%include        "../commons.s"
%include        "../Str/str.s"
%include        "../Converter/conv.s"
             

%macro          caseNumber 5

.%1:            cmp bl, %2
                jne .%3

                push rax                        ; save registers
                push rbx
                push rcx
                push rdx
                push rdi

                mov r8, [rax]
                push r8
                call %4                         ; translate
                mov rcx, %5
                call writeNums                  ; wiret result on the screen
                pop r8
                
                pop rdi
                pop rdx                         ; load registers
                pop rcx
                pop rbx
                pop rax
                
                add rax, 8                     ; move to next argument
                inc rdi
                ret    

                %endmacro


global _start


;============================================================================
;Description:   printf() - print format string to stdout.
;----------------------------------------------------------------------------
;Params:        [RSP + 8]       - adress of null-terminated format string
;               [RSP + 16*n]    - arguments, to insert in line
;----------------------------------------------------------------------------
;Returns:
;----------------------------------------------------------------------------
;Destroy:       [R8], [RAX], [RBX], [RCX], [RSI], [RDI] 
;============================================================================ 

printf:         
                xor bx, bx
                mov rax, rsp                    ; adress of argument
                add rax, 16

                mov rdi, [rsp + 8]


.Next:          mov bl, [rdi]

                cmp bl, '%'
                jne .Symb

                call insert

                jmp .Next

.Symb:          cmp bl, 0
                je .Break

                push rdi                        ; save registers
                push rax

                push bx                         ; putc(bx)
                call putc
                pop bx                          ; balance stack

                pop rax                         ; load registers
                pop rdi

                inc rdi
                jmp .Next
.Break:

                ret


;============================================================================
;Description:   Handler for % in printf.
;----------------------------------------------------------------------------
;Params:        [RAX]           - adress of argument to insert.
;               [RDI]           - adress of '%'.
;----------------------------------------------------------------------------
;Returns:       [RDI]           - adress of next symbol after control sequence
;----------------------------------------------------------------------------
;Destroy:       [R8], [BL]
;============================================================================

insert:
                inc rdi
                mov bl, [rdi]

                cmp bl, '%'
                je .Percent                     ; #in most cases je won't work, so there will be only 1 clock


                cmp bl, 'c'
                jne .s

                push rsi                        ; save registers
                push rax
                push rdx
                push rdi

                mov r8, [rax]
                push r8
                call putc
                pop r8

                pop rdi                         ; load registers
                pop rdx
                pop rax
                pop rsi

                add rax, 8                     ; move to next argument
                inc rdi
                ret


.s:             cmp bl, 's'
                jne .b

                push rsi                        ; save registers
                push rdi
                push rax
                push rdx
                push rcx

                mov r8, [rax]
                push r8
                call puts
                pop r8

                pop rcx                         ; load registers
                pop rdx
                pop rax
                pop rdi
                pop rsi

                add rax, 8                     ; move to next argument
                inc rdi
                ret   

                caseNumber b, 'b', o,    toBin, BINlen          ; case %b

                caseNumber o, 'o', d,    toOct, OCTlen          ; case %o

                caseNumber d, 'd', x,    toDec, DEClen          ; case %d

                caseNumber x, 'x', Quit, toHex, HEXlen          ; case %x


.Percent:       push rsi                        ; save registers
                push rax
                push rdx
                push rdi

                push '%'
                call putc
                pop r8

                pop rdi                         ; load registers
                pop rdx
                pop rax
                pop rsi

.Quit           inc rdi
                ret                

