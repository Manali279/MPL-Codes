section .data
arr: dq 0x2234567890ABCDEF,0xE234567890ABCDEF,0x7234567890ABCDEF,0xC234567890ABCDEF,0x5234567CC0ABCDEF
pos: db 00
neg: db 00
count: db 5
msg: db "Number of positive number:"
len: equ $-msg
msg1: db "Number of negative number:"
len1: equ $-msg1
msg2: db " ",0x0A
len2: equ $-msg2

section .text
global main
main:
mov rsi,arr
up:mov rax,qword[rsi]
bt rax,63
jc next
inc byte[pos]
jmp up2
next:inc byte[neg]
up2:add rsi,8
dec byte[count]
jnz up
syscall
cmp byte[pos],9H
jbe down
add byte[pos],7H
down:add byte[pos],30H
cmp byte[neg],9H
jbe down1
add byte[neg],7H
down1:add byte[neg],30H
syscall
mov rax,1          ;printing msg
mov rdi,1
mov rsi,msg
mov rdx,len
syscall
mov rax,1          ;printing positive number
mov rdi,1
mov rsi,pos
mov rdx,1
syscall
mov rax,1          ;printing blank space
mov rdi,1
mov rsi,msg2
mov rdx,len2
syscall
mov rax,1          ;printing msg1
mov rdi,1
mov rsi,msg1
mov rdx,len1
mov rax,1          ;printing negative number
mov rdi,1
mov rsi,neg
mov rdx,1
syscall
mov rax,1          ;printing blank space
mov rdi,1
mov rsi,msg2
mov rdx,len2
syscall
mov rax,60
mov rdi,3
syscall

