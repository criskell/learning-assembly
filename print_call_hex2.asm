section .data
newline_char: db 10
codes: db '0123456789abcdef'

section .text
global _start

print_newline:
    mov rax, 1
    mov rdi, 1 ; fd
    mov rsi, newline_char ; start
    mov rdx, 1 ; length
    syscall
    ret

print_hex:
    mov rax, 1
    mov rdx, 1
    mov rcx, 16 ; number of nibbles

    .iterate:
        mov rbx, rdi

        shr rbx, 60 ; get the highest nibble and store it in rbx
        lea rsi, [codes + rbx] ; load address of nibble character into rsi (used for write syscall)

        shl rdi, 4 ; remove the highest nibble from rax
        push rdi

        mov rdi, 1 ; fd
        push rcx ; syscall uses this register
        syscall
        pop rcx ; restore
        
        pop rdi

        dec rcx ; stop when all nibbles are processed
        jnz .iterate

        ret

_start:
    mov rdi, 0x102233445566778f
    call print_hex
    call print_newline

    mov rax, 60 ; exit
    xor rdi, rdi
    syscall