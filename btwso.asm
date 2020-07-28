;Block transfer with overlapping and without string instructions
section .data
msg: db "Original array is:",0x0A
len: equ $-msg
msg1: db "After block transfer array is:",0x0A
len1: equ $-msg1
msg2: db ":"
len2: equ $-msg2
msg3: db " ",0x0A
len3: equ $-msg3
count: db 05
count1: db 00
arr: dq 0x12345AB89D583694,0x12345ABDFD583694,0x123436719D583694,0xDEF45AB89D583694,0x896410AB89D58369,0,0,0,0,0

section .bss
arr1: resq 5
result: resb 16

section .text
mov rax,1                 ;printing msg1
mov rdi,1
mov rsi,msg
mov rdx,len
syscall
mov rsi,arr
up:                         ;printing address
mov rdx,rsi
push rsi
call HtoA
syscall
mov rax,1                   ; printing :
mov rdi,1
mov rsi,msg2
mov rdx,len2
syscall
pop rsi
mov rdx,qword[rsi]
push rsi
call HtoA
syscall
mov rax,1                 ; next line
mov rdi,1
mov rsi,msg3
mov rdx,len3
syscall
pop rsi
add rsi,08
dec byte[count]
jnz up
mov rsi,arr                 ;copying arr to arr1
mov rdi,arr1
mov byte[count],5
up1:	mov rdx,qword[arr]
	mov qword[arr1],rdx
	add rsi,8
	add rdi,8
	dec byte[count]
	jnz up1
syscall
mov rsi,arr1
mov rdi,arr+2
mov byte[count],5
up2:	mov rdx,qword[rsi]
	mov qword[rdi],rdx
	add rsi,8
	add rdi,8
	dec byte[count]
	jnz up2
	syscall
mov rax,1                 ; printing msg1
mov rdi,1
mov rsi,msg1
mov rdx,len1
syscall
mov rsi,arr
mov byte[count],7
up3:	mov rdx,00
	mov rdx,qword[rsi]
	push rsi
	call HtoA
	mov rax,1                   ; printing :
	mov rdi,1
	mov rsi,msg2
	mov rdx,len2
	syscall
	pop rsi
	mov rdx,qword[rsi]
	push rsi
	call HtoA
	mov rax,1                 ; next line
	mov rdi,1
	mov rsi,msg3
	mov rdx,len3
	syscall
	pop rsi
	add rsi,8
	dec byte[count]
	jnz up3
	syscall
mov rax,60
mov rdi,3
syscall

HtoA:                         ;hexa to ascii conversion
mov rsi,result
mov byte[count1],16
up4:	
	rol rdx,04
	mov cl,dl
	and cl,0FH
	cmp cl,09
	jbe next
	add cl,07
next:
add cl,30H
mov byte[rsi],cl
inc rsi
dec byte[count1]
jnz up4
mov rax,1
mov rdi,1
mov rsi,result
mov rdx,16
syscall
ret




