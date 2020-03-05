;Converter

section .text

global _start

_start:         
                mov rdl, 1ah
                call ByteToHex
                mov rax, 0x01              ; write
                mov rdi, 1              ; stdout
                mov rsi, rdx
                mov rdx, 1              ; strlen(rsi)
                syscall

                mov rax, 0x3C           ;exit(rdi)
                xor rdi, rdi
                syscall


;====================================================================
;Translates byte into its ASCII HEX interpretation.
;--------------------------------------------------------------------
;Params:        [RDL] - number to translate.
;--------------------------------------------------------------------
;Returns;       [RDH] - first(higher) character
;               [RDL] - second(lower) character
;--------------------------------------------------------------------
;Destroy:       [RAL]
;====================================================================

ByteToHex:       
                mov ral, rdl                            ; save entry          

                shr ral, 8                              ; take first character
                add ral, HEXdict
                mov rdh, ral                            ; prepare ASCII character for return

                mov ral, rdl                            ; take second character
                shl ral, 24
                shr ral, 24
                add ral, HEXdict
                mov rdl, ral                            ; prepare second character for return

                ret

section .data

HEXdict: db "0123456789ABCDE"
