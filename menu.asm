section .data
msg:db "1.hex to bcd",0x0A
    db "2.bcd to hex",0x0A
    db "3.Exit",0x0A
len: equ $-msg
msg1: db "Enter your choice:",0x0A
len1: equ $-msg1
msg2: db "Enter a number:"
len2: equ $-msg2
msg3: db " ",0x0A
len3: equ $-msg3
count: db 00
count1: db 00
count2: db 05
arr: dw 0x0001,0x000A,0x0064,0x03E8,0x2710

section .bss
choice: resb 2
num: resb 6
num1: resb 1
num2: resb 9
result: resb 9
%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro


section .text
global main
main:
scall 1,1,msg,len
scall 1,1,msg1,len1
scall 0,1,choice,2
cmp byte[choice],31H
je next1
cmp byte[choice],32H
je next2
cmp byte[choice],33H
je exit

next1:
scall 1,1,msg2,len2
scall 0,1,num,6
mov rdi,num
mov byte[count],4
mov bx,00
up:	rol bx,4              ;AtoH 
	mov dl,byte[rdi]
	cmp dl,39H
	jbe next
	sub dl,07
next:	sub dl,30H
	add bl,dl
	inc rdi
	dec byte[count]
	jnz up
	syscall

	mov eax,00
	mov eax,ebx
	mov ebx,00
	mov bx,0x0A
up1:	mov dx,00
	div bx
	push dx
	inc byte[count1]
	cmp eax,00
	jne up1
up2:	mov dx,00	
	pop dx
	cmp dl,09H
	jbe down
	add dl,07H
down:	add dl,30H	
	mov byte[num1],dl
	scall 1,1,num1,1
	dec byte[count1]
	jnz up2
	scall 1,1,msg3,len3
	jmp main


next2:scall 1,1,msg2,len2            ;bcd to hex
	scall 0,1,num2,9
	mov rdi,num2
	mov byte[count],8
	mov rbx,00
up3:	rol rbx,4              ;AtoH 
	mov dl,byte[rdi]
	cmp dl,39H
	jbe next3
	sub dl,07H
next3:	sub dl,30H
	add bl,dl
	inc rdi
	dec byte[count]
	jnz up3

	mov rdx,00
	mov ecx,ebx
	mov rax,00
	mov rsi,arr
up4:	mov ebx,00
	mov bx,word[rsi]
	mov rax,00
	mov al,cl
	and al,0FH
	mul bx
	add edx,eax
	ror ecx,4
	add rsi,2
	dec byte[count2]
	jnz up4
	call HtoA
	scall 1,1,msg3,len3
	jmp main

	 
	
exit:	mov rax,60
	mov rdi,0
	syscall



HtoA:                         ;hexa to ascii conversion
mov rsi,result
mov byte[count1],8
up5:	
	rol edx,04
	mov cl,dl
	and cl,0FH
	cmp cl,09
	jbe next6
	add cl,07H
next6:	add cl,30H
	mov byte[rsi],cl
	inc rsi
	dec byte[count1]
	jnz up5
	scall 1,1,result,8
	ret
