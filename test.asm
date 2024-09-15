global _start
_start:
    mov rax, 1 ; write syscall
    mov rdi, 1 ; fd = stdout
    mov rsi, message ; pointer to string
    mov rdx, 14 ; length
    syscall

    mov rax, 60
    xor rdi, rdi ; exit code
    syscall

message: db 'Hello, world!', 0xA