;Converter tests

section .text

global _start

%include        "commons.s"
%include        "conv.s"

%macro          test_series 1                   ;output %1 -> {BIN, OCT, HEX, DEC}
                
                push %1

                PUTC '{'

                call toBin
                mov rcx, BINlen
                call writeNums

                PUTC ','
                PUTC ' '

                call toOct
                mov rcx, OCTlen
                call writeNums

                PUTC ','
                PUTC ' '

                call toHex
                mov rcx, HEXlen
                call writeNums

                PUTC ','
                PUTC ' '

                call toDec
                mov rcx, DEClen
                call writeNums

                PUTC '}'
                PUTC LF

                %endmacro

_start:
                test_series 7                           ; {111, 7, 7, 7}

                test_series 10                          ; {1010, 12, A, 10}

                mov rax, 0x1000000000000000             ; {10..0(60), 10..0(20), -||-, 1152921504606846976}
                test_series rax

                mov rax, 12345678901234567890           ; {100011000101101010100111100100010101011101011000000,
                                                        ; 43055247442535300, 
                                                        ; 462D53C8ABAC0, -||-}
                test_series rax

                EXIT 0
