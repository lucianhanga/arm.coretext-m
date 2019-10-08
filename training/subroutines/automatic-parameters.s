@--------1---------2---------3---------4---------5---------6---------7---------8
@ 
@   Working with (Sub)Routines in ARM
@   Automatic Variables
@
@   In C the variables local to a block/function are called automatic variables
@   and their life time is limited to the block/function exeuction time.
@   These variables can be kept in registers or can be stored on the stack
@   depdending on their size. 
@
@   IMPORTANT:  If they are stored on the stack, it is important that the
@   stack pointer SP is restored before the end of the block or before exiting
@   from the function.
@  
@   This program will implement the following C function is ARM Assembly:
@
@   int doit() 
@   {
@       int x[20];
@       register int i; // try to keep i in a regiser
@       for(i=0; i<20; i++) x[i]=i;
@       return i;
@   }
@

            .data
            .global main
            .text
main:       nop
            stmfd   sp!, {lr}   @ save the return address

            bl      doit

exit:       mov     r0, #0          @ return value 0
            ldr     lr, [sp], #4    @ restore lr  (imediat with post-index)
            mov     pc, lr          @ return to the caler

 
            @ locale subroutine  definition
            .equ    size,  20
doit:       str     lr, [sp, #-4]!  @ store lr (imediat with pre-index)
            sub     sp, sp,#size<<2 @ allocate space for 20 elements

i           .req    r1              @ use r1 as loop index/counter
            mov     i, #0           @ initialize the index i<-0
loop:       cmp     i, #size        @ check the loop exit condition
            bge     loop_end        @ condition met; exit the loop
            str     i, [sp, i, lsl #2]  @ store i value into the stack at 
                                        @ the address fp + i<<2 using 
                                        @ scaled register offset
            add     i, i, #1        @ increment the index
            b       loop            @ close the loop
loop_end:
            add     sp, sp, #size<<2  @ restore the stack - remove 20 elements
doit_ret:   ldr     lr, [sp], #4    @ restore lr (imediat with post-index)
            mov     pc, lr

