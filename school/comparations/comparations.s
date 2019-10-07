@--------1---------2---------3---------4---------5---------6---------7---------8

        .data
fmt1:   .string     "r4 bigger (r4=%d r5=%d)\n"
fmt2:   .string     "r5 bigger (r4=%d r5=%d)\n"

        .global     main
        .text
        
main:	stmfd   sp!, {lr}

        mov     r1,#-1
        mov     r1,#-2

@ how to clear the NZCV flags
@ 0xF0000000  - clear the NZCF
@ 0x80000000  - clear the N
@ 0x40000000  - clear teh  Z
@ 0x20000000  - clear the   C
@ 0x10000000  - clear the    F

        mrs     r1, cpsr        @ transfer the contents of CPSR into r1 
        bic     r1, r1, #(0xF0000000) @ clear the NZCV flags 
        msr     cpsr_f, r1      @ transfer the r1 back to the CPSR

@ a negative in the ARM is represented as 2's Complement of the modulus number
@ e.g. for a 8 bit number: 0bxxxxxxxx
@ a=-10 => |a|=10=0b00001010  1sC|a|=0b11110101 2sC|a|=0b11110110 (2sC = 1sC+1)
@ the memory representation of the a=-10 would be 2sC|a|=0b1111011
@ so to exemplify the substraction and addition operations the following nrs.
@  10  0b00001010
@ -10  0b11110110  [ 0b00001010; 0b11110101; 0b11110110 ] 0xF6
@   9  0b00001001
@  -9  0b11110111  [ 0b00001001; 0b11110110; 0b11110111 ] 0xF7
@  

        @ clear all the flags
        mrs     r1, cpsr        @ transfer the contents of CPSR into r1 
        bic     r1, r1, #(0xF0000000) @ clear the NZCV flags 
        msr     cpsr_f, r1      @ transfer the r1 back to the CPSR
@ (-10) - (+9) = (-19) 0b11110110 +
@                      0b11110111
@                      -----------
@                 C=1  0b11101101         
@                    [ 0b11101101; 0b11101100; 0b00011100011; -19 ]
@                    [ 2sC         1sC         modulo          nr ]
@                    NF=1 ZF=0 CF=1 VF=0
sub1: 
        mov     r4, #-10        
        mov     r5, #9          
        subs    r3, r4, r5      @ NF=1 ZF=0 CF=1 VF=0

@ ----------------------------------------------------------------------------

        @ clear all the flags
        mrs     r1, cpsr        @ transfer the contents of CPSR into r1 
        bic     r1, r1, #(0xF0000000) @ clear the NZCV flags 
        msr     cpsr_f, r1      @ transfer the r1 back to the CPSR
@ (-10) - (-9) =
@ (-10) +   9  =  -1   0b11110110 +
@                      0b00001001
@                      -----------
@                 C=0  0b11111111        
@                    [ 0b11111111; 0b11111110; 0b00000001; -1 ]
@                    [ 2sC         1sC         modulo      nr ]
@                    NF=1 ZF=0 CF=0 VF=0
sub2: 
        mov     r4, #-10        
        mov     r5, #-9          
        subs    r3, r4, r5      @ NF=1 ZF=0 CF=0 VF=0

@ ----------------------------------------------------------------------------

        @ clear all the flags
        mrs     r1, cpsr        @ transfer the contents of CPSR into r1 
        bic     r1, r1, #(0xF0000000) @ clear the NZCV flags 
        msr     cpsr_f, r1      @ transfer the r1 back to the CPSR
@ (-9) - (-10) =  
@ (-9) +   10  =  1    0b11110111 +
@                      0b00001010
@                      -----------
@                 C=1  0b00000001 
@                    [ 0b00000001;  1 ]
@                    [ nr          nr ]
@                    NF=0 ZF=0 CF=1 VF=0
sub3: 
        mov     r4, #-9        
        mov     r5, #-10          
        subs    r3, r4, r5      @ NF=0 ZF=0 CF=1 VF=0

@ ----------------------------------------------------------------------------

        @ clear all the flags
        mrs     r1, cpsr        @ transfer the contents of CPSR into r1 
        bic     r1, r1, #(0xF0000000) @ clear the NZCV flags 
        msr     cpsr_f, r1      @ transfer the r1 back to the CPSR
@ (-9) - (-10) =  
@ (-9) +   10  =  1    0b11110111 +
@                      0b00001010
@                      -----------
@                 C=1  0b00000001 
@                    [ 0b00000001;  1 ]
@                    [ nr          nr ]
@                    NF=0 ZF=0 CF=1 VF=0
sub4: 
        mov     r4, #-9        
        mov     r5, #-10          
        subs    r3, r4, r5      @ NF=0 ZF=0 CF=1 VF=0

@ ----------------------------------------------------------------------------


@ some basic compare - more comparations in the programs from the same  folder

br4:    mov     r4, #0x0F
        mov     r5, #0x0E
        cmp     r4, r5          @ compare r4 and r5 and set the CPSR
        bgt     r4_bigger
        ldr     r0, =fmt2
        mov     r1, r4
        mov     r2, r5
        bl      printf
        b       ret
r4_bigger:
        ldr     r0, =fmt1
        mov     r1, r4
        mov     r2, r5
        bl      printf

ret:    mov     r0, #0          @ prepare the return code
        ldmfd   sp!, {lr}       @ recover the lr from stack
        mov     pc, lr          @ return from main			 

@ literal pool
