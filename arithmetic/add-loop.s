@--------1---------2---------3---------4---------5---------6---------7---------8
@       
@       #include<stdio.h>
@
@       int main() {
@           int i;
@           int sum;
@           sum = 0;
@           for(i=0; i < 10; i++)  {
@               sum += i;
@           }
@           printf("the sum is: %d", sum);
@
            .data
sum:        .word       0
fmt:        .string     "The sum is %d\n"

            .text
            .global     main
main:	    stmfd   sp!, {lr}       @ save the  lr register, because it might
                                    @ be overwritten by other func. calls.

            mov     r1, #0          @ set the register which keeps the sum on 0

            mov     r0, #0          @ initialize the loop counter (index)
loop:       cmp     r0, #100        @ check the exit condition
            bgt     exit_loop
            @ do the loop code
            add     r1, r1, r0      @ add the counter to the sum

            @ update  the loop counter (index) & loop
            add     r0, r0, #1      @ update  the loop counter (index)
            b       loop            @ close the loop
exit_loop:  
            @ store the result
            ldr     r0, =sum
            str     r1, [r0]
 
            @ print the result 
            ldr     r0, =fmt
            ldr     r2, =sum
            ldr     r1, [r2]
            bl      printf


ret:        mov     r0, #0          @ prepare the return code
            ldmfd   sp!, {lr}       @ recover the lr from stack
            mov     pc, lr          @ return from main			 

@ literal pool
