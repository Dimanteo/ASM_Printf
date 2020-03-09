;Converter

section .text

global _start

_start:         
                push 0x1A4
                call ByteToHex
                mov rax, 0x01                           ; write
                mov rdi, 1                              ; stdout
                mov rdx, 16                             ; rdx = strlen(rsi)
                syscall

                mov rax, 0x123456789ABCDEF0
                push rax
                call ByteToHex
                mov rax, 0x01
                mov rdx, 16
                syscall

                mov rax, 0x3C                           ;exit(rdi)
                xor rdi, rdi
                syscall


;====================================================================
;Translates number into its ASCII HEX interpretation.
;--------------------------------------------------------------------
;Params:        [RBP + 16] - number to translate.
;--------------------------------------------------------------------
;Returns;       [RSI] - adress of string, containing translated number
;--------------------------------------------------------------------
;Destroy:       [RAX], [RBX], [RCX], [RDX]
;====================================================================

ByteToHex:      
                push rbp
                mov rbp, rsp
                std
                
                mov rcx, 16                              ; number of symbols                
                mov rax, [rbp + 16]                      ; stack dump: rbp_old[rbp] <- call_adr[rbp+8] <- args[rbp+16] 

Next:           mov rdx, 0x0F                            ; set up mask
                and dl, al                               ; take current byte
                
                add rdx, HEXstr                          ; generate ASCII code

                mov rbx, OutputBuffer                    ; calculate symbol buffer offset                        
                add rbx, rcx
                dec rbx
                mov dl, [rdx]
                mov [rbx], dl

                shr rax, 4
                loop Next

                mov rsi, OutputBuffer

                pop rbp
                ret

section .data

HEXstr: db "0123456789ABCDEF"
OutputBuffer: db "PPPPPPPPPPPPPPPPPPPPPPP"
