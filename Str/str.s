;String and char output functions

section .text

%include        "../commons.s"

global _start


;============================================================================
;Description:   Prints char.
;----------------------------------------------------------------------------
;Params:        [RSP + 8]        - char.
;----------------------------------------------------------------------------
;Returns:
;----------------------------------------------------------------------------
;Destroy:       [RSI], [RAX], [RDX], [RDI]
;============================================================================

putc:                         
                mov rsi, rsp
                add rsi, 8              ; rdi = rsp + 8, adress of char
                mov rdx, 1

                INT_WRITE

                ret


;============================================================================
;Description:   Print null terminated string.
;----------------------------------------------------------------------------
;Params:        [RSP + 8]       - string adress.
;----------------------------------------------------------------------------
;Returns:
;----------------------------------------------------------------------------
;Destroy:       [RSI], [RDI], [RAX], [RDX], [RCX]
;============================================================================

puts:           
                cld
                xor al, al              ; set accumulator 0 for scasb
                
                mov rdi, [rsp + 8]      
                
.NotEOL:        mov rcx, -1             ; set max possible line length
                repne scasb             ; while(*str != 0) str++
                jne .NotEOL

                dec rdi
                sub rdi, [rsp + 8]
                mov rdx, rdi

                mov rsi, [rsp + 8]
                
                INT_WRITE

                ret


section .data
Str: db         "Oh hi Mark", 0     