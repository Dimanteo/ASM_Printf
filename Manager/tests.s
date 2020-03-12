;tests for printf.s

section .text

%include        "printf.s"

global _start

_start:
                push str
                call printf
                PUTC LF

                push str_Percent
                call printf
                PUTC LF

                push 10
                push 10
                push 10

                push str_hex
                call printf
                pop r8
                PUTC LF

                push str_dec
                call printf
                pop r8
                PUTC LF

                push str_oct
                call printf
                pop r8
                PUTC LF

                push str_bin
                call printf
                pop r8
                PUTC LF

                EXIT 0

section .data

str:            db "Oh hi Mark", 0
str_Percent:    db "%% Percent %% %%", 0
str_hex:        db "%x Hex %x %x", 0
str_dec:        db "%d Dec %d %d", 0
str_oct:        db "%o Oct %o %o", 0
str_bin:        db "%b Bin %b %b", 0
