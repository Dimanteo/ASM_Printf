;Converter

section .text

global _start

_start:         
                mov dl, 0x1a
                call ByteToHex
                mov rax, 0x01                           ; write
                mov rdi, 1                              ; stdout
                mov rsi, r8
                mov rdx, 1                              ; rdx = strlen(rsi)
                syscall
                mov rsi, r9
                syscall

                mov dl, 0xF0
                call ByteToHex
                mov rax, 0x01                           ; write
                mov rdi, 1                              ; stdout
                mov rsi, r8
                mov rdx, 1                              ; rdx = strlen(rsi)
                syscall
                mov rsi, r9
                syscall

                mov rax, 0x3C                           ;exit(rdi)
                xor rdi, rdi
                syscall


;====================================================================
;Translates byte into its ASCII HEX interpretation.
;--------------------------------------------------------------------
;Params:        [DL] - number to translate.
;--------------------------------------------------------------------
;Returns;       [R8] - first(higher) character adress
;               [R9] - second(lower) character adress
;--------------------------------------------------------------------
;Destroy:       [RAX]
;====================================================================

ByteToHex:      
                xor rax, rax 
                mov al, dl                              ; save entry          

                shr al, 4                               ; take first character
                add rax, HEXstr
                mov r8, rax                             ; prepare first ASCII character for return

                xor rax, rax
                mov al, dl                              ; take second character
                shl al, 4
                shr al, 4
                add rax, HEXstr
                mov r9, rax                             ; prepare second character for return

                ret

section .data

HEXstr: db "0123456789ABCDEF"
