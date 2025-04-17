; prime_check.asm
; Assemble with: nasm -f elf32 prime_check.asm
; Link with: ld -m elf_i386 -s -o prime_check prime_check.o


section .data
    number          db 6               ; change this to test other values
    answer          db 1               ; 1 = prime (default). Initialized here and remains 1 if no divisor ever sets it to 0

    prime_msg       db 'Number is prime', 0x0a
    prime_len       equ $ - prime_msg  ; length of prime_msg: sys_write needs the byte count in EDX

    not_prime_msg   db 'Number is NOT prime', 0x0a
    not_prime_len   equ $ - not_prime_msg  ; length of not_prime_msg for sys_write

section .text
    global _start

_start:
    ; Initialize divisor = 2
    mov     cl, 2

PrimeLoop:
    ; load number into AL for compare and dividend
    mov     al, [number]    ; AL = number

    ; if divisor >= number, we’re done
    cmp     cl, al          ; compare divisor and number
    jge     PrintResult

    ; prepare AX = number for division (AL holds number)
    xor     ah, ah          ; clear AH so AX = number

    ; divide AX by divisor
    mov     bl, cl          ; BL = divisor
    div     bl              ; AX / BL -> AL = quotient, AH = remainder

    cmp     ah, 0           ; remainder == 0?
    jne     NextDivisor

    ; not prime: set answer = 0
    mov     byte [answer], 0    ; store 0 into 'answer' to indicate number is NOT prime
    jmp     PrintResult         ; exit loop and print result

NextDivisor:
    inc     cl               ; next divisor
    jmp     PrimeLoop

PrintResult:
    ; branch on answer: if answer == 1, print prime_msg; else print not_prime_msg
    cmp     byte [answer], 1    ; test if answer equals 1
    je      PrintPrimeMsg
    jmp     PrintNotPrimeMsg

; ----------------------------
; print "Number is prime"
; uses: eax, ebx, ecx, edx
; ----------------------------
PrintPrimeMsg:
    mov     eax, 4           ; sys_write syscall
    mov     ebx, 1           ; file descriptor: stdout
    mov     ecx, prime_msg   ; pointer to string
    mov     edx, prime_len   ; message length (sys_write needs length)
    int     0x80        ; invoke interrupt 0x80 (hex 0x80 == 80h)
    jmp _exit

; ----------------------------
; print "Number is NOT prime"
; uses: eax, ebx, ecx, edx
; ----------------------------
PrintNotPrimeMsg:
    mov     eax, 4           ; sys_write syscall
    mov     ebx, 1           ; stdout
    mov     ecx, not_prime_msg
    mov     edx, not_prime_len  ; length for sys_write
    int     0x80        ; invoke interrupt 0x80 (hex 0x80 == 80h)
    jmp _exit

; ----------------------------
; exit
; ----------------------------
_exit:
    mov     eax, 1           ; sys_exit
    xor     ebx, ebx         ; return code = 0
    int     0x80        ; invoke interrupt 0x80 (hex 0x80 == 80h)
