; Benny Liu ID 40287238

section .data
        number db 5
        answer db 1

        prime_msg db 'Number is prime', 0x0a
        prime_msg_length equ $-prime_msg

	not_prime_msg db 'Number is NOT prime', 0x0a     
        not_prime_msg_length equ $-not_prime_msg

section .bss

section .text
        global _start

_start:
        mov bl, 2 ; sets the first divisor

primeCheck:
        mov al, [number]
        cmp bl, al
        jge checkAnswer      ; if divisor >= number then go to end

        xor ah, ah        ; this clears the high byte to make sure ax = number

	
        div bl            ; performs ax / bl = al , remainder in ah

        cmp ah, 0	  ; checks if remainder == 0
        jne nextDivisor

        mov byte[answer], 0 ; puts 0 in 'answer' if not prime
        jmp checkAnswer

nextDivisor:
        inc bl		    ; increments divisor
        jmp primeCheck	    ; restart loop

checkAnswer:
	mov eax, 4
        mov ebx, 1

        cmp byte[answer], 1        
        je printPrime
        jmp printNotPrime

printPrime:
        mov ecx, prime_msg
        mov edx, prime_msg_length
        int 80h
        jmp _exit

printNotPrime:
        mov ecx, not_prime_msg
        mov edx, not_prime_msg_length
        int 80h
        jmp _exit

_exit:
        mov eax, 1
        mov ebx, 0
        int 80h

