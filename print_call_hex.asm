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
    mov rcx, 64 ; amount of bytes

    .iterate:
        push rax
        
        sub rcx, 4
        sar rax, cl
        
        and rax, 0xf ; get least four significant bits

        lea rsi, [codes + rax] ; load address of current character in rsi

        mov rax, 1 ; syscall number

        push rcx ; rcx is a special register for syscall

        ; rax = 1 (31) - identifier of write
        ; rdi = file descriptor
        ; rsi = address of character
        syscall

        pop rcx ; restore rcx

        pop rax

        ; check if rcx = 0
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