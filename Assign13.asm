 .MODEL TINY                                                          ;code is near and segment is near
.286                                                                  ;for 80286
ORG 100H                                                              ;first 256 bytes stored for PSP(Program segment prefix)


CODE SEGMENT
     ASSUME CS:CODE,DS:CODE,ES:CODE                                   ;initially all pointed to code segment
        OLD_IP DW 00                                                  
        OLD_CS DW 00
JMP INIT

MY_TSR:
        PUSH AX                                                       ;push data
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        PUSH DI
        PUSH ES

        MOV AX,0B800H              ;Address of Video RAM              ;gives exact location where the clock to be placed
        MOV ES,AX
        MOV DI,3650

        MOV AH,02H            ;To Get System Clock
        INT 1AH               ;CH=Hrs, CL=Mins,DH=Sec                    
        MOV BX,CX             ;stored into register

        MOV CL,2              ;same as hex to ascii
LOOP1:  ROL BH,4
        MOV AL,BH
        AND AL,0FH
        ADD AL,30H            ;3 lines below give bg color
        MOV AH,17H
        MOV ES:[DI],AX
        INC DI                ;blinking of clock
        INC DI
        DEC CL
        JNZ LOOP1

        MOV AL,':'         
        MOV AH,97H
        MOV ES:[DI],AX
        INC DI
        INC DI

        MOV CL,2
LOOP2:  ROL BL,4
        MOV AL,BL
        AND AL,0FH
        ADD AL,30H
        MOV AH,17H
        MOV ES:[DI],AX
        INC DI
        INC DI
        DEC CL
        JNZ LOOP2

        MOV AL,':'
        MOV AH,97H
        MOV ES:[DI],AX

        INC DI
        INC DI

        MOV CL,2
        MOV BL,DH

LOOP3:  ROL BL,4
        MOV AL,BL
        AND AL,0FH
        ADD AL,30H
        MOV AH,17H
        MOV ES:[DI],AX
        INC DI
        INC DI
        DEC CL
        JNZ LOOP3

        POP ES                 ;pops all content except bx,es
        POP DI
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX

   JMP MY_TSR    ;REMOVE FOR STATIC

INIT:
        MOV AX,CS              ;Initialize data (CS and DS contains old code segment)
        MOV DS,AX

        CLI                    ;Clear Interrupt Flag

        MOV AH,35H             ;Get Interrupt vector Data and store it
        MOV AL,08H
        INT 21H                ;syscall type only interrupt in 80286(call kernel to execute command)

        MOV OLD_IP,BX          ;ip address from bx stored to variable
        MOV OLD_CS,ES          ;cs from es stored to variable

        MOV AH,25H             ;Set new Interrupt vector
        MOV AL,08H
        LEA DX,MY_TSR          ;load effective address of MY_TSR in IVT(we go to MY_TSR)
        INT 21H

        MOV AH,31H             ;Make program Transient
        MOV DX,OFFSET INIT
        STI                     ;set interrupt flag
        INT 21H

CODE ENDS

END
