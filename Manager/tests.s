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

                push 0xEDA
                push ' '
                push str_love
                push ' '
                push 'I'
                push str_killer
                call printf
                PUTC LF

                push LF
                push '!' 
                push str_finally
                call printf

                EXIT 0

section .data

str:            db "Oh hi Mark", 0
str_Percent:    db "%% Percent %% %%", 0
str_hex:        db "%x Hex %x %x", 0
str_dec:        db "%d Dec %d %d", 0
str_oct:        db "%o Oct %o %o", 0
str_bin:        db "%b Bin %b %b", 0
str_killer:     db "%c%c%s%c%x", 0
str_love:       db "love", 0
str_finally:    db "A ya vse otdebugal%c%c", 0
