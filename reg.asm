section .data
msg: db "In real mode!!",0x0A
len: equ $-msg
msg1: db "In protected mode!!",0x0A
len1: equ $-msg1
msg2: db "Machine Status Word is:"
len2: equ $-msg2
msg3: db " ",0x0A
len3: equ $-msg3
msg4: db ":"
len4: equ $-msg4
msg5: db "GDT(Base Address:Limit):"
len5: equ $-msg5
msg6: db "LDT(Base Address):"
len6: equ $-msg6
msg7: db "IDT(Base Address:Limit):"
len7: equ $-msg7
msg8: db "Task Register(Base Address):"
len8: equ $-msg8

count: db 00

section .bss
msw: resb 16
gdt: resb 48
idt: resb 48
ldt: resb 16
tr: resb 16
result:resb 5
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
mov rdx,00
smsw [msw]
bt dword[msw],0
jnc next
scall 1,1,msg3,len3
scall 1,1,msg1,len1
mov dx,word[msw]
scall 1,1,msg2,len2
call HtoA
scall 1,1,msg3,len3
mov dx,00
scall 1,1,msg5,len5       ;GDT
sgdt [gdt]
mov dx,word[gdt+4]
call HtoA
mov dx,00
mov dx,word[gdt+2]
call HtoA
scall 1,1,msg4,len4
mov dx,00
mov dx,word[gdt]
call HtoA
scall 1,1,msg3,len3
mov dx,00
scall 1,1,msg6,len6      ;LDT
sldt [ldt]
mov dx,00
mov dx,word[ldt]
call HtoA
scall 1,1,msg3,len3
scall 1,1,msg7,len7      ;IDT
sidt [idt]
mov dx,word[idt+4]
call HtoA
mov dx,00
mov dx,word[idt+2]
call HtoA
scall 1,1,msg4,len4
mov dx,00
mov dx,word[idt]
call HtoA
scall 1,1,msg3,len3
scall 1,1,msg8,len8     ;Task Register
str [tr]
mov dx,00
mov dx,word[tr]
call HtoA
scall 1,1,msg3,len3

mov rax,60
mov rdi,0
syscall


next:	scall 1,1,msg,len
	mov rax,60
	mov rdi,0
	syscall

HtoA:                       ;hexa to ascii conversion
mov rsi,result
mov byte[count],16
up4:	
	rol dx,04
	mov cl,dl
	and cl,0FH
	cmp cl,09
	jbe down4
	add cl,07
down4:	add cl,30H
	mov byte[rsi],cl
	inc rsi
	dec byte[count]
	jnz up4
	scall 1,1,result,4
	
	ret

