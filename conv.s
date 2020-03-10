;Converter

section .text

global _start

                os_write        equ 1
                stdout          equ 1

_start:         
                push 0x7
                call toBin
                mov rdx, 64
                call writeNums

                call toOct
                mov rdx, 21
                call writeNums

                call toHex
                mov rdx, 16
                call writeNums

                mov rax, 0x3C                           ; exit(rdi)
                xor rdi, rdi
                syscall


;====================================================================
;Description: Generate function for translation
;             from number to ASCII interpretation.
;             Macro parameters set number system base.
;--------------------------------------------------------------------
;Macro Params:  %1 - function name.
;               %2 - maximum length of 64 bit number in required base.
;               %3 - bit mask = 0..01..1. Quantity of 1 in lower bits equal to %4.
;                    number & bit mask = last digit of number
;               %4 - number of bits to encode one digit in required base. 
;Params:        [RBP + 16]      - number to translate.
;--------------------------------------------------------------------
;Returns;       [RSI]           - adress of string, containing translated number
;--------------------------------------------------------------------
;Destroy:       [RAX], [RBX], [RCX], [RDX]
;====================================================================

%macro          translationTemplate 4                   ; %1 = name, %2 = length, %3 = mask, %4 = shift

%1:             push rbp
                mov rbp, rsp
                std
                
                mov rcx, %2                             ; number of symbols                
                mov rax, [rbp + 16]                     ; stack dump: rbp_old[rbp] <- call_adr[rbp+8] <- args[rbp+16] 

.Next:          mov rdx, %3                             ; set up mask, to take one last digit
                and dl, al                              ; take current digit
                
                add rdx, HEXstr                         ; generate ASCII code

                mov rbx, OutputBuffer                   ; calculate symbol buffer offset                        
                add rbx, rcx
                dec rbx
                mov dl, [rdx]
                mov [rbx], dl

                shr rax, %4
                loop .Next

                mov rsi, OutputBuffer

                pop rbp
                ret
                %endmacro


translationTemplate toBin, 64, 0x1, 1                   ; translation to BIN
translationTemplate toOct, 21, 0x7, 3                   ; translation to OCT
translationTemplate toHex, 16, 0xF, 4                   ; translation to HEX

;============================================================================
;Description: Write string of nums to stdout. Cuts leading zeroes.
;----------------------------------------------------------------------------
;Params:        [RSI]           - string adress
;               [RDX]           - string length
;----------------------------------------------------------------------------
;Returns:       [RDX]           - output length
;               [RSI]           - output adress, without leading zeroes
;----------------------------------------------------------------------------
;Destroy:       [RDX], [RAX], [RDI], [RSI]
;============================================================================                

writeNums:
                std
                mov al, '0'

.Next:          cmp [rsi], al                           ; skip '0'
                jne .Break
                inc rsi
                dec rdx
                jmp .Next

.Break:         mov rax, os_write                       ; setup write syscall
                mov rdi, stdout
                syscall

                ret

section .data

HEXstr: db "0123456789ABCDEF"
OutputBuffer: times 64 db 0
