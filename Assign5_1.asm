section .data
global count,count1,count2,length,length1,length2,cnt,cnt1,cnt2
fname: db 'abc.txt',0
msg: db "file opened successfully!",0x0A
len: equ $-msg
msg1: db "cannot open file",0x0A
len1: equ $-msg1
msg2: db "Number of enter are=",0x0A
len2: equ $-msg2
msg3: db "Number of spaces are=",0x0A
len3: equ $-msg3
msg4: db "Number of occurence of the character=",0x0A
len4: equ $-msg4
msg5: db "Enter the character whose occurence is to be found=",0x0A
len5: equ $-msg5
msg6: db " ",0x0A
len6: equ $-msg6
count: db 0
count1: db 0
count2: db 0
length: dq 0
length1:dq 0
length2:dq 0
cnt: db 0
cnt1: db 0
cnt2: db 0



section .bss
global fd,buffer,char
fd: resb 2
buffer: resb 1000
char: resb 2


section .text

global main2
main2:
extern enter,space,occurence

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
mov qword[length1],rax
mov qword[length2],rax

mov rax,1
mov rdi,1
mov rsi,msg2
mov rdx,len2
syscall
call enter
mov rax,1
mov rdi,1
mov rsi,msg6
mov rdx,len6
syscall
mov rax,1
mov rdi,1
mov rsi,msg3
mov rdx,len3
syscall
call space
mov rax,1
mov rdi,1
mov rsi,msg6
mov rdx,len6
syscall
msg5: db "Enter the character whose occurence is to be found=",0x0A
len5: equ $-msg5
mov rax,1
mov rdi,1
mov rsi,msg4
mov rdx,len4
syscall

mov rbx,qword[char]
call occurence
mov rax,1
mov rdi,1
mov rsi,msg6
mov rdx,len6
syscall
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

