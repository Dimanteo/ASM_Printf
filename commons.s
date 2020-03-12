;Macro and constants.

section .text

                os_write        equ 1
                stdout          equ 1
                LF              equ 10
                HEXlen          equ 16
                OCTlen          equ 21
                DEClen          equ 20
                BINlen          equ 64
                mask_1          equ 1
                mask_111        equ 0x7
                mask_1111       equ 0xF

;============================================================================
;Description:   Print char.
;---------------------------------------------------------------------------
;Destroy:       [RAX], [RDI], [RDX], [RSI]
;============================================================================

%macro          PUTC 1

                mov rax, os_write
                mov rdi, stdout
                mov rdx, 1
                mov rsi, $ + 12                 ;muahahahah
                jmp $ + 3
                db %1
                syscall

                %endmacro

;============================================================================
;Description:   syscall write()
;----------------------------------------------------------------------------
;Params:        [RDX]   - strlen.
;               [RSI]   - string adress.
;----------------------------------------------------------------------------
;Destroy:       [RAX], [RDI]
;============================================================================

%macro          INT_WRITE 0

                mov rax, os_write
                mov rdi, stdout
                syscall

                %endmacro

;============================================================================
;Description:   exit
;----------------------------------------------------------------------------
;Params:        %1      - exit code
;----------------------------------------------------------------------------
;Destroy:       [RAX], [RDI]
;============================================================================

%macro          EXIT 1

                mov rax, 0x3C                           ; exit(rdi)
                mov rdi, %1
                syscall

                %endmacro