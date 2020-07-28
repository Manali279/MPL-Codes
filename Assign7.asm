section .data
fname: db 'Text7.txt',0
msg: db "file opened successfully!",0x0A
len: equ $-msg
msg1: db "cannot open file",0x0A
len1: equ $-msg1
length: dq 0
cnt: db 0
result: db 0
temp: db 0
result1: db 0

section .bss
fd: resb 2
buffer: resb 1000

section .text
global main
main:
mov rax,2
mov rdi,fname
mov rsi,2
mov rdx,0777
syscall

mov qword[fd],rax
bt rax,63
jc check

mov rax,1
mov rdi,1
mov rsi,msg
mov rdx,len
syscall

mov rax,0
mov rdi,[fd]
mov rsi,buffer
mov rdx,1000
syscall

mov qword[length],rax

mov rsi,00
mov rsi,buffer
mov rcx,00
mov rcx,07

bubble:
call abc
dec rcx
jnz bubble

mov rax,60
mov rdi,0
syscall

check:
mov rax,1
mov rdi,1
mov rsi,msg1
mov rdx,len1
syscall
mov rax,60
mov rdi,0
syscall

large:
mov byte[temp],dl
mov dl,bl
mov bl,byte[temp]
ret


abc:
mov bl,byte[rsi]
add rsi,2
mov dl,byte[rsi]
cmp bl,dl
ja large
mov byte[result1],bl
mov rax,1
mov rdi,1
mov rsi,result1
mov rdx,10
syscall
ret




