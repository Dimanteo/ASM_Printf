;Converter

section .text

global _start

                os_write        equ 1
                stdout          equ 1

_start:         
                push 0x1A4
                call byteToHex
                call writeNums

                mov rax, 0x3C                           ; exit(rdi)
                xor rdi, rdi
                syscall


;====================================================================
;Description: Translates number into its ASCII HEX interpretation.
;--------------------------------------------------------------------
;Params:        [RBP + 16]      - number to translate.
;--------------------------------------------------------------------
;Returns;       [RSI]           - adress of string, containing translated number
;--------------------------------------------------------------------
;Destroy:       [RAX], [RBX], [RCX], [RDX]
;====================================================================

byteToHex:      
                push rbp
                mov rbp, rsp
                std
                
                mov rcx, 16                              ; number of symbols                
                mov rax, [rbp + 16]                      ; stack dump: rbp_old[rbp] <- call_adr[rbp+8] <- args[rbp+16] 

.Next:          mov rdx, 0x0F                            ; set up mask
                and dl, al                               ; take current byte
                
                add rdx, HEXstr                          ; generate ASCII code

                mov rbx, OutputBuffer                    ; calculate symbol buffer offset                        
                add rbx, rcx
                dec rbx
                mov dl, [rdx]
                mov [rbx], dl

                shr rax, 4
                loop .Next

                mov rsi, OutputBuffer

                pop rbp
                ret


;============================================================================
;Description: Write string of nums to stdout. Cuts leading zeroes.
;----------------------------------------------------------------------------
;Params:        [RSI]           - string adress
;----------------------------------------------------------------------------
;Returns:       [RDX]           - output length
;               [RSI]           - output adress, without leading zeroes
;----------------------------------------------------------------------------
;Destroy:       [RDX], [RAX], [RDI], [RSI]
;============================================================================                

writeNums:
                std
                mov al, '0'
                mov rdx, 16                             ; strlen(rsi)

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
OutputBuffer: 
