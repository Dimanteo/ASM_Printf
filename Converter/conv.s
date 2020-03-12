;Converter

section .text

;====================================================================
;Description: Generate function for translation
;             from number to ASCII interpretation.
;             Macro parameters set number system base.
;--------------------------------------------------------------------
;Macro Params:  %1 - function name.
;               %2 - maximum length of 64 bit number in required base.
;               %3 - bit mask = 0..01..1. Quantity of 1 in lower bits equal to %4.
;                    number & bit mask = last digit of number
;               %4 - number of bits to encode one digit in required base. 
;Params:        [RSP + 8]      - number to translate.
;--------------------------------------------------------------------
;Returns;       [RSI]           - adress of string, containing translated number
;--------------------------------------------------------------------
;Destroy:       [RAX], [RBX], [RCX], [RDX]
;====================================================================

%macro          translationTemplate 4                   ; %1 = name, %2 = length, %3 = mask, %4 = shift

%1:             std
                
                mov rcx, %2                             ; number of symbols                
                mov rax, [rsp + 8]                      ; stack dump: rbp_old[rbp] <- call_adr[rbp+8] <- args[rbp+16] 

.Next:          mov rdx, %3                             ; set up mask, to take one last digit
                and dl, al                              ; take current digit
                
                mov dl, [rdx + ASCIIstr]                ; generate ASCII
                mov [OutputBuffer + rcx - 1], dl        ; mov ASCII to buffer

                shr rax, %4
                loop .Next

                mov rsi, OutputBuffer

                ret
                %endmacro


translationTemplate toBin, BINlen, mask_1   , 1         ; translation to BIN
translationTemplate toOct, OCTlen, mask_111 , 3         ; translation to OCT
translationTemplate toHex, HEXlen, mask_1111, 4         ; translation to HEX

;============================================================================
;Description: Write string of nums to stdout. Cuts leading zeroes.
;----------------------------------------------------------------------------
;Params:        [RSI]           - string adress
;               [RCX]           - string length
;----------------------------------------------------------------------------
;Returns:       [RDX]           - output length
;               [RSI]           - output adress, without leading zeroes
;----------------------------------------------------------------------------
;Destroy:       [RCX], [RAX], [RDI]
;============================================================================                

writeNums:
                cld
                mov al, '0'
                mov rdi, OutputBuffer

                repe scasb                              ; skip leading '0'

                dec rdi
                inc cx

                mov rsi, rdi
                mov rdx, rcx
                
                INT_WRITE

                ret

;============================================================================
;Description:   Do number to decimal translation.
;----------------------------------------------------------------------------
;Params:        [RSP + 8]      - number to translate.
;----------------------------------------------------------------------------
;Returns:       [RSI]           - adress of string, containing translated number.
;----------------------------------------------------------------------------
;Destroy:       [RAX], [RCX], [RDX]
;============================================================================

toDec:
                mov rax, [rsp + 8]
                mov rsi, 10                             ;number system base
                mov rcx, DEClen

.Next           xor rdx, rdx
                div rsi
                mov dl, [ASCIIstr + rdx]                ; generate ASCII
                mov [OutputBuffer + rcx - 1], dl        ; mov ASCII to buffer
                loop .Next

                mov rsi, OutputBuffer

                ret


section .data

ASCIIstr: db "0123456789ABCDEF"
OutputBuffer: times 64 db 0
