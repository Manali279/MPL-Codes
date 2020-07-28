section .data
arr: dd 101.11,102.22,103.33,104.44,105.55
cnt: dw 05
cnt2: dw 00
cnt3: dw 00
dec: dw 100
count: db 00
msg: db "Mean is:"
len: equ $-msg
msg1: db "."
len1: equ $-msg1
msg2: db " ",0x0A
len2: equ $-msg2
msg3: db "Variance is:"
len3: equ $-msg3
msg4: db "Standard Deviation is:"
len4: equ $-msg4

section .bss
mean: resb 4
var: resb 4
sd: resb 4
buffer: resb 10
result: resb 10
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
finit                                                        ;stack creation
fldz                                                         ;load 0 to st[0]
mov rsi,arr                                                   
mov byte[cnt2],5
up:  fadd dword[rsi]             ;mean calculation           ;add to st[0]
     add rsi,4                                               ;pointing next no. of array
     dec byte[cnt2]                                          ;nos. in array
     jnz up                                                     
     fidiv word[cnt]                                         ;divide with n
     fst dword[mean]                                         ;mean stored to stack
     scall 1,1,msg,len
     call print
     scall 1,1,msg1,len1
     mov dl,byte[buffer]                                     ;value from print stored to dl
     call HtoA
     scall 1,1,msg2,len2
     scall 1,1,msg3,len3
     mov rsi,arr
     mov byte[cnt2],5
     fldz                                                    ;load stack to zero
up2: fldz                                                    ;load top value to zero
     fadd dword[rsi]                                         ;add array element to top of stack
     fsub dword[mean]                                        ;sub mean from st[0]  
     fmul st0                                                ;square of st[0]
     fadd                                                    ;add to st[0]
     add rsi,4
     dec byte[cnt2]
     jnz up2
     fidiv word[cnt]
     fst dword[var]
     call print
     scall 1,1,msg1,len1
     mov dl,byte[buffer]
     call HtoA
     scall 1,1,msg2,len2
     scall 1,1,msg4,len4
     fldz
     fld dword[var]                                           ;load variance to st[0]    
     fsqrt                                                    ;square root of var
     fst dword[sd]                                            ;store to sd
     call print
     scall 1,1,msg1,len1
    mov dl,byte[sd]
     call HtoA
     scall 1,1,msg2,len2
     mov rax,60
     mov rdi,3
     syscall




print:    fimul word[dec]    
          fbstp [buffer]
          mov rsi,buffer+9
          mov byte[cnt3],9
up1:      push rsi
          mov dl,byte[rsi]
          call HtoA
          pop rsi
          dec rsi
          dec byte[cnt3]
          jnz up1
          ret
          
HtoA:                       ;hexa to ascii conversion
mov rsi,result
mov byte[count],2
up3:	
	rol dl,04
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
	scall 1,1,result,2
	ret
	

