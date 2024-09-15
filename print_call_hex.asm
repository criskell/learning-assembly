section .data

newline_char: db 10
codes: db '0123456789abcdef'

section .text
global _start ; entrypoint

print_newline:
    mov rax, 1 ; ; write(
    mov rdi, 1 ; ; fd,
    mov rsi, newline_char ; data,
    mov rdx, 1 ; len)
    syscall
    ret ; pop rip

print_hex:
    mov rax, rdi
    mov rdi, 1
    mov rdx, 1
    mov rcx, 64 ; amount of bits

    .iterate:
        ; save rax for restoring later
        push rax
        
        ; get next 4 bits
        sub rcx, 4
        
        ; right-arithmetic shift by cl bytes (lowest byte of rcx)
        ; remove lowest cl bytes (60-4, 60-4-4 and so on.)
        sar rax, cl
        
        ; get lowest four significant bits
        ; the lowest nibble (0-15) is always the index in the table 
        and rax, 0xf

        ; load address of current character in rsi
        lea rsi, [codes + rax]

        ; write syscall identifier
        mov rax, 1

        ; rcx is a special register for syscall
        ; syscall instruction change this register
        push rcx

        ; rax = 1 (31) - identifier of write
        ; rdi = file descriptor
        ; rsi = address of character
        syscall

        ; restore rcx
        pop rcx

        ; restore rax
        pop rax

        ; check if rcx == 0
        test rcx, rcx

        ; jump if not it is not equal to zero
        jnz .iterate

        ; pop rip
        ret

_start:
    mov rdi, 0x1122334455667788
    
    call print_hex
    call print_newline

    mov rax, 60 ; exit(
    xor rdi, rdi ; 0
    syscall ; )