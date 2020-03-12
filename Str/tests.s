;tests for str.s

section .text

%include        "../commons.s"
%include        "str.s"

global _start

_start:         
                push s1
                call puts

                push LF
                call putc

                push s2
                call puts

                push LF
                call putc

                push 'O'
                call putc

                push 'K'
                call putc

                push LF
                call putc

                EXIT 0

section .data

s1:     db "string", 0
s2:     db "another long long long very long string", 0
