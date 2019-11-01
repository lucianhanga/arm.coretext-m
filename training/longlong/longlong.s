@--------1---------2---------3---------4---------5---------6---------7---------8
@      
@   Example of handling of DWORDS (64bit values) (in C long long)
@
@   How the 64bit values are handles using the ldrd and strd instructions
@
@ 
@ - so, to print a DWORD (long long; 64bit integer) using "%llx" 
@ load the LSB in r1 and MSB in r2 and call the printf function.
@ - loading from memory address a 64bit value can be done by:
@ ldrd rX, rY, <address>
@ rX should be an even register, e.g. r0, r2, r4, ....
@ rY is the successive register. e.g.  if rX is r2 then rY should be r3
@ however rY can be ignored from the syntax because the  assembler will know
@ which one is.

            .data
@  unsigned long long x = 0x8877665544332211;
@  in memory will look something  like:
@  x:
@         .word   1144201745
@         .word   -2005440939
@
val:
val_lo:     .word   0x44332211
val_hi:     .word   0x88776655
fmt:        .string "dword value: %llx\n"

            .balign 4, 0x00 
            @       LSB -------------------------------------> MSB
val2:       .byte   0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88

val3:       .hword  0x2211, 0x4433, 0x6655, 0x8877

            @         LSWord      MSWord
val5:       .word   0x11111111, 0x22222222
val6:       .word   0x33333333, 0x44444444
res:        .space  8

            .text
            .global main
main:       stmfd   sp!, {lr}       @ save the return address
            ldr     r3, =val
            ldrd    r2, [r3]        @ load double word in r2 and r3
           @ldrd    r2,r3,[r3]      @ same instruction as above 
            mov     r1, r2          @ move the LSB to r1
            mov     r2, r3          @ move the MSB to r2 
            ldr     r0, =fmt        @ load the format "%llx"
            bl      printf          @ call the print

            ldr     r3, =val2
            ldrd    r2, [r3]        @ load double word in r2 and r3
           @ldrd    r2,r3,[r3]      @ same instruction as above 
            mov     r1, r2          @ move the LSB to r1
            mov     r2, r3          @ move the MSB to r2 
            ldr     r0, =fmt        @ load the format "%llx"
            bl      printf          @ call the print

            ldr     r3, =val3
            ldrd    r2, [r3]        @ load double word in r2 and r3
           @ldrd    r2,r3,[r3]      @ same instruction as above 
            mov     r1, r2          @ move the LSB to r1
            mov     r2, r3          @ move the MSB to r2 
            ldr     r0, =fmt        @ load the format "%llx"
            bl      printf          @ call the print

            @ load two 64bit unsigned integers, add them and store the res.
            ldr     r0, =val5
            ldrd    r0, r1, [r0]
            ldr     r2, =val6
            ldrd    r2, r3, [r2]
            adds    r0, r0, r2
            adc     r1, r1, r3
            ldr     r3, =res
            strd    r0, r1, [r3]

            ldr     r3, =res
            ldrd    r2, [r3]        @ load double word in r2 and r3
           @ldrd    r2,r3,[r3]      @ same instruction as above 
            mov     r1, r2          @ move the LSB to r1
            mov     r2, r3          @ move the MSB to r2 
            ldr     r0, =fmt        @ load the format "%llx"
            bl      printf          @ call the print


ret:        mov     r0, #0
            ldmfd   sp!, {lr}       @ restore the return address 
            mov     pc, lr          @ exit the function 


