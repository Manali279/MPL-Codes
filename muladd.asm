section .data
msg: db "Enter number 1:"
len: equ $-msg
msg1: db "Enter number 2:"
len1: equ $-msg1
msg2: db "Multiplication is:"
len2: equ $-msg2
msg3: db " ",0x0A
len3: equ $-msg3
msg4:db "1.Successive Addition",0x0A
    db "2.Add & Shift",0x0A
    db "3.Exit",0x0A
len4: equ $-msg4
msg5: db "Enter your choice:",0x0A
len5: equ $-msg5
count: db 00
count1: db 00
count2: db 08


section .bss
choice: resb 2
num1: resb 3
num2: resb 3
result: resb 2
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
scall 1,1,msg4,len4
scall 1,1,msg5,len5
scall 0,1,choice,2
cmp byte[choice],31H
je next1
cmp byte[choice],32H
je next2
cmp byte[choice],33H
je exit

next1:
scall 1,1,msg,len
scall 0,1,num1,3
scall 1,1,msg3,len3
scall 1,1,msg1,len1
scall 0,1,num2,3
scall 1,1,msg3,len3
scall 1,1,msg2,len2
scall 1,1,msg3,len3
mov dx,00
mov ax,00
mov rdi,num1
mov byte[count],2
mov bx,00
up:	rol bl,04
	mov dl,byte[rdi]
	cmp dl,39H
	jbe down
	sub dl,07
down:	sub dl,30H
	add bl,dl
	inc rdi
	dec byte[count]
	jnz up
	mov byte[count1],bl
mov rdi,num2
mov byte[count],2
mov bx,00
up1:	rol bl,04
	mov dl,byte[rdi]
	cmp dl,39H
	jbe down1
	sub dl,07
down1:	sub dl,30H
	add bl,dl
	inc rdi
	dec byte[count]
	jnz up1
	mov al,bl
	mov dx,00
up2:	add dx,ax
	dec byte[count1]
	jnz up2
	call HtoA
	scall 1,1,msg3,len3
	jmp main


next2:	scall 1,1,msg,len
	scall 0,1,num1,3
	scall 1,1,msg3,len3
	scall 1,1,msg1,len1
	scall 0,1,num2,3
	scall 1,1,msg3,len3
	scall 1,1,msg2,len2
	scall 1,1,msg3,len3
	mov dx,00
	mov ax,00
	mov rdi,num1
	mov byte[count],2
	mov bx,00
up4:	rol bl,04
	mov dl,byte[rdi]
	cmp dl,39H
	jbe down4
	sub dl,07
down4:	sub dl,30H
	add bl,dl
	inc rdi
	dec byte[count]
	jnz up4
	mov byte[count1],bl
	mov rdi,num2
	mov byte[count],2
	mov bx,00
up5:	rol bl,04
	mov dl,byte[rdi]
	cmp dl,39H
	jbe down5
	sub dl,07
down5:	sub dl,30H
	add bl,dl
	inc rdi
	dec byte[count]
	jnz up5
	mov ax,00
	mov ax,word[count1]
	mov cx,00
up6:	shr bx,01
	jnc carry1
	add cx,ax
carry1:	shl ax,1
	;clc
	dec byte[count2]
	jnz up6
	mov dx,cx
	call HtoA	
	scall 1,1,msg3,len3
	jmp main
	

exit:	mov rax,60
	mov rdi,3
	syscall

HtoA:                       ;hexa to ascii conversion
mov rsi,result
mov byte[count],4
up3:	
	rol dx,04
	mov cl,dl
	and cl,0FH
	cmp cl,09
	jbe down3
	add cl,07
down3:	add cl,30H
	mov byte[rsi],cl
	inc rsi
	dec byte[count]
	jnz up3
	scall 1,1,result,4
	ret
