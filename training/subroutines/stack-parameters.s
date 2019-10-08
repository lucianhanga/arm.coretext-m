@--------1---------2---------3---------4---------5---------6---------7---------8
@ 
@   Working with (Sub)Routines in ARM
@   Stack Parametes
@ 
@   The arguments for a routine by convention are stored in the r0-r3 registers.  
@   However, when the number of parameters are exceding 4, then they have to be
@   pushed to stack (by convention) in the reverser order. 
@   example:  f(a,b,c,d,e,g,h) 
@   a,b,c,d will be put in the registers r0 <-- a, r1<-- b, ... 
@   the remaining e,g,h will be pushed on the stack in the reverse order,
@   namelly first h, then g and at the end e.
@ 
@   This example programm will call printf function with 9 parameters.
@ 


            .data
 fmt:       .string "The Matrix: %02x %02x %02x %02x %02x %02x %02x %02x"
 fmt_nl:    .string "\n"
 matrix:    .word   0x12, 0x22, 0x32, 0x42, 0x52, 0x62, 0x72, 0x82
            .global main
            .text
main:       stmfd   sp!, {lr}       @ store multimple registers full descend

            @ the fmt of the printf will be put in r0
            @ the values 0x12, 0x22, 0x32 will be put in registers too
            ldr     r0, =fmt
            ldr     r4, =matrix
            ldr     r1, [r4], #4    @ r1 <-- element 0
            ldr     r2, [r4], #4    @ imediat post increment - element 1
            ldr     r3, [r4], #4    @ imediat post increment - element 2
            @ at this point the r4 contains the address of the 4th element
            @ in the matrix: 0x42
            @ the remaining 5 numbers will be stored on the stack in the
            @ !!!reverse!!! order
            add     r4, r4, #4*4    @ advance the pointer to the last element
            ldr     r5, [r4], #-4   @ load element 7 (index starts at 0)
            str     r5, [sp, #-4]!  @ store iemdiate preindexed
            ldr     r5, [r4], #-4   @ load element 6 (index starts at 0)
            str     r5, [sp, #-4]!  @ store iemdiate preindexed
            ldr     r5, [r4], #-4   @ load element 5 (index starts at 0)
            str     r5, [sp, #-4]!  @ store iemdiate preindexed
            ldr     r5, [r4], #-4   @ load element 4 (index starts at 0)
            str     r5, [sp, #-4]!  @ store iemdiate preindexed
            ldr     r5, [r4], #-4   @ load element 3 (index starts at 0)
            str     r5, [sp, #-4]!  @ store iemdiate preindexed
            @ ready to call the printf
            bl      printf
            add     sp, sp, #5*4    @ rewind the stack to cleanup the space
                                    @ allocated for the parameters    
            ldr     r0, =fmt_nl
            bl      printf

@------- another version of the passing of the parameters above

            ldr     r0, =fmt
            ldr     r4, =matrix
            ldr     r1, [r4], #4    @ r1 <-- element 0
            ldr     r2, [r4], #4    @ imediat post increment - element 1
            ldr     r3, [r4], #4    @ imediat post increment - element 2

            ldr     r5, [r4], #4    @ imediat post increment - element 3
            ldr     r6, [r4], #4    @ imediat post increment - element 4
            ldr     r7, [r4], #4    @ imediat post increment - element 5
            ldr     r8, [r4], #4    @ imediat post increment - element 6
            ldr     r9, [r4], #4    @ imediat post increment - element 7
            stmfd   sp!, {r5-r9}    @ store multimple registers full descend
            @ ready to call the printf
            bl      printf
            add     sp, sp, #5*4    @ rewind the stack to cleanup the space
                                    @ allocated for the parameters    
            ldr     r0, =fmt_nl
            bl      printf


ret:        mov     r0, #0
            ldmfd   sp!, {pc}       @ load multiple registers full descend 


