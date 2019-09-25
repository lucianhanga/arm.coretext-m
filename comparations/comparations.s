@--------1---------2---------3---------4---------5---------6---------7---------8

        .data
        .global     main
        .text
        
main:	stmfd   sp!, {lr}

        mov     r1, #0x0F
        mov     r2, #0x0E
        cmp     r1, r2


ret:    mov     r0, #0          @ prepare the return code
        ldmfd   sp!, {lr}       @ recover the lr from stack
        mov     pc, lr          @ return from main			 

@ literal pool
