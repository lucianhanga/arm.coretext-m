@--------1---------2---------3---------4---------5---------6---------7---------8
@  
@ 

        .data
        .global     main
        .text

main:	stmfd   sp!, {lr}

        mov     r1, #1
        mov     r2, #1

        add     r0, r1, r2

        @ Logical Shift Left of 'operand two'
op1:    add     r0, r1, r2, lsl #8  @ lsl of r2 with 8 bits -> 0x100 
                                    @ add to r1 -> 0x101
        
        @ Logical Shift Right of 'operand two'
        mov     r1, #1
        mov     r2, #0x100
op2:    add     r0, r1, r2, lsr #8  @ lsr of r2 with 8 bits -> 0x01 and
                                    @ add it to r1 -> 0x02

        @ ROtate Right of 'operand two'
        mov     r1, #1
        mov     r2, #1
op3:    add     r0, r1, r2, ror #1  @ ror of r2 with 1 bit -> 0x80000000
                                    @ add it to r1 -> 0x80000001

        @ Rotate Right by by one bit with eXtend
        @ CF --> MSB .... LSB --> CF
        mov     r1, #1
        mov     r2, #0
op4:    add     r3, r1, r2, rrx     @ rrx of the r2 with 1 bit -> 0x80000001 and
                                    @ CF <- 0 and add it to r1 ->0x02
                                    @ !NOTE! when I ran this through the debug
                                    @ the CF remained 1. Need to investigate!!! 

ret:    mov     r0, #0          @ prepare the return code
        ldmfd   sp!, {lr}       @ recover the lr from stack
        mov     pc, lr          @ return from main			 



@ literal pool
