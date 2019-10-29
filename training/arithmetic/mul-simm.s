@--------1---------2---------3---------4---------5---------6---------7---------8
@  
@   simmulate the mul and smul for 32bit values with the result on 32bit     
@      
@   unsigned multiplication:
@ 
@   res <-- 0
@   while n != 0; do
@       if n is odd; then
@           res <- res + m
@       endif
@       res <- res << 2
@       n   <- n   >> 2
@   end while
@
            .data
x:          .word       0xff
y:          .word       0xff
ures_hi:    .word       0
ures_lo:    .word       0
sres_hi:    .word       0
sres_lo:    .word       0
fmt1:      .string     "Product: 0x%0x x 0x%0x = "
fmt2:       .string     "0x%x 0x%x\n"

            .text
            .global     main
main:	    stmfd   sp!, {lr}       @ save the  lr register, because it might
                                    @ be overwritten by other func. calls.

m_hi        .req    r4
m_lo        .req    r0
n           .req    r1
r_hi        .req    r2
r_lo        .req    r3

            @ 32bit x 32bit = 64bit unsigned multiplication
            @ 
            @     111
            @    1001
            @  --------
            @     111
            @    1110
            @   11100
            @  111000+
            @     111
            @ -------
            @  111111   == 0x3f
            @
            
            ldr     m_lo, =x        @ load the address of x
            ldr     m_lo, [m_lo]    @ load the value of x
            ldr     n, =y           @ load the address of y
            ldr     n, [n]          @ load the value of y
            mov     r_hi, #0        @ initialize the result hi
            mov     r_lo, #0        @ initialize the result lo
            mov     m_hi, #0        @ initialize the m_hi with 0

umul_loop:  cmp     n, #0           @ check if n is zero - end condition
            beq     umul_end        @ condition was met - exit loop
            tst     n, #1           @ check if the lsb(n)==1
            addnes  r_lo, r_lo, m_lo @ if yes r_lo <- r_lo + m_lo
            tst     n, #1           @ check again  if lsb(n)==1 - might be dif
            adcne   r_hi ,r_hi,m_hi @  if yes r_hi <- r_hi + m_hi + CF
            lsls    m_lo, m_lo, #1  @ m_lo << 1
            lsl     m_hi, m_hi      @ m_hi << 1
            adcne   m_hi, m_hi ,#0  @ add CF if set
            lsr     n, n, #1        @ n >> 1
            b       umul_loop       @ close the loop   
umul_end:   ldr     r5, =ures_hi    @ load the address of the ures high byte
            str     r_hi, [r5]      @ store the high value of the ures
            ldr     r5, =ures_lo    @ load the address of hte ures low byte
            str     r_lo, [r5]      @ store the low value of the ures

            @display the result
            ldr     r0, =fmt1
            ldr     r1, =x
            ldr     r1, [r1]
            ldr     r2, =y
            ldr     r2, [r2]
            bl      printf
            ldr     r0, =fmt2
            ldr     r1, =ures_hi
            ldr     r1, [r1]
            ldr     r2, =ures_lo
            ldr     r2, [r2]
            bl      printf

ret:        mov     r0, #0          @ prepare the return code
            ldmfd   sp!, {lr}       @ recover the lr from stack
            mov     pc, lr          @ return from main			 

@ literal pool
