section .data
msg: db "Enter value of a:"
len: equ $-msg
msg1: db "Enter value of b:"
len1: equ $-msg1
msg2: db "Enter value of c:"
len2: equ $-msg2
msg3: db " ",0x0A
len3: equ $-msg3
msg4: db "Root 1 is:"
len4: equ $-msg4
msg5: db "Root 2 is:"
len5: equ $-msg5
msg6: db "+i"
len6: equ $-msg6
msg7: db "The real roots are:"
len7: equ $-msg7
msg8: db "The imaginary roots are:",0x0A
len8: equ $-msg8
four: dq 4
two: dq 2
formatpf: db "%lf",10,0
formatpi: db "%d",10,0
formatsf: db "%lf",0
ff1: db "%lf +i %lf",10,0
ff2: db "%lf -i %lf",10,0


section .bss
a: resq 2
b: resq 2
c: resq 2
bsq: resq 2
ac4: resq 2
a2: resq 2
rr1: resq 2
rr2: resq 2
real: resq 2
img: resq 2
delta: resq 2
rdelta: resq 2
bminus: resq 2

%macro myprintf 1
mov rdi,formatpf
sub rsp,8
movsd xmm0,[%1]
mov rax,1
call printf
add rsp,8
%endmacro

%macro myscanf 1
mov rdi,formatsf
mov rax,0
sub rsp,8
mov rsi,rsp               ;r8 uses rsi internally
call scanf
mov r8,qword[rsp]
mov qword[%1],r8
add rsp,8
%endmacro

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
extern printf,scanf
scall 1,1,msg,len
myscanf a
;scall 0,1,a,10
scall 1,1,msg1,len1
myscanf b
;scall 0,1,b,10
scall 1,1,msg2,len2
myscanf c
;scall 0,1,c,10
finit
fldz                     ; b^2 calculation
fld qword[b]
fmul st0
fst qword[bsq]
fldz                     ; 4ac calculation
fadd qword[a]
fimul word[four]
fmul qword[c]
fst qword[ac4]
fldz                     ; -b calculation
fsub qword[b]
fst qword[bminus]
fldz                      ; 2a calculation
fadd qword[a]
fimul word[two]
fst qword[a2]
fldz                     ;delta calculation
fadd qword[bsq]
fsub qword[ac4]
fst qword[delta]
fsqrt
fst qword[rdelta]
btr qword[delta],63
jc imaginary
fldz                        ; -b+rdelta calculation
fadd qword[bminus]
fadd qword[rdelta]
fdiv qword[a2]
fst qword[rr1]
fldz
fadd qword[bminus]          ; -b-rdelta calculation
fsub qword[rdelta]
fdiv qword[a2]
fst qword[rr2]
scall 1,1,msg7,len7
scall 1,1,msg3,len3
scall 1,1,msg4,len4
myprintf rr1
;scall 1,1,msg3,len3
scall 1,1,msg5,len5
myprintf rr2
scall 1,1,msg3,len3
mov rax,60
mov rdi,0
syscall




imaginary:
scall 1,1,msg8,len8
scall 1,1,msg4,len4
fldz
fadd qword[bminus]
fdiv qword[a2]
fstp qword[real]
fld qword[delta]
fdiv qword[a2]
fstp qword[img]
mov rdi,ff1
sub rsp,8
movsd xmm0,[real]
movsd xmm1,[img]
mov rax,2
call printf
add rsp,8
;myprintf real
;scall 1,1,msg6,len6
;scall 1,1,msg3,len3
scall 1,1,msg5,len5
mov rdi,ff2
sub rsp,8
movsd xmm0,[real]
movsd xmm1,[img]
mov rax,2
call printf
add rsp,8
mov rax,60
mov rdi,0
syscall
