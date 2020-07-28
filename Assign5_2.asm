section .data
extern count,count1,count2,length,length1,length2,cnt,cnt1,cnt2
section .bss
extern fd,buffer,char
result: resb 10
section .text
global main1
main1:
global enter,space,occurence

enter:
mov byte[count],00
mov rsi,00
mov rsi,buffer
mov rcx,00
mov rcx,qword[length]
up1:
cmp byte[rsi],0x0A
jnz down1
inc byte[count]
down1:
inc rsi
dec rcx
jnz up1
mov dx,0
mov dx,word[count]
call htoa
ret

space:
mov byte[count1],00
mov rsi,00
mov rsi,buffer
mov rcx,00
mov rcx,qword[length1]
up2:
cmp byte[rsi],20H
jnz down2
inc byte[count1]
down2:
inc rsi
dec rcx
jnz up2
mov dx,0
mov dx,word[count1]
call htoa
ret

occurence:
mov rax,0
mov rdi,1
mov rsi,char
mov rdx,2
syscall

mov al,byte[char]
mov byte[count2],00
mov rsi,00
mov rsi,buffer
mov rcx,00
mov rcx,qword[length2]
up3:
cmp byte[rsi],al
jnz down3
inc byte[count2]
down3:
inc rsi
dec rcx
jnz up3
mov dx,0
mov dl,byte[count2]
call htoa
ret

mov rax,60
mov rdi,0
syscall

htoa:
mov rsi,result
mov byte[cnt],4
up:
rol dx,04
mov cl,dl
and cl,0FH
cmp cl,09
jbe next
add cl,07H
next:
add cl,30H
mov byte[rsi],cl
inc rsi
dec byte[cnt]
jnz up
mov rax,1
mov rdi,1
mov rsi,result
mov rdx,10
syscall
ret

