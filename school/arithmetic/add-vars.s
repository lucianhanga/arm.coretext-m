@--------1---------2---------3---------4---------5---------6---------7---------8
@       
@       #include<stdio.h>
@       static int x = 5;
@       static int y = 8;
@       int main() {
@           int sum;
@           sum = x + y;
@           printf("The sum is: %d\n", sum);
@           return 0;
@       }
@       
@       
@
            .data
x:          .word       5
y:          .word       8
sum:        .word       0
fmt:        .string     "The sum is %d\n"

            .text
            .global     main
main:	    stmfd   sp!, {lr}       @ save the  lr register, because it might
                                    @ be overwritten by other func. calls.

            @ do the math and save the result in 'sum'
            ldr     r0, =x
            ldr     r1, [r0]        @ load the value of x in r1
            ldr     r0, =y
            ldr     r2, [r0]        @ load the value  of y in r2
            add     r1, r1, r2      @ add x and y and store in r1
            ldr     r0, =sum
            str     r1, [r0]        @ save the result in sum

            @ print the result 
            ldr     r0, =fmt
            ldr     r2, =sum
            ldr     r1, [r2]
            bl      printf


ret:        mov     r0, #0          @ prepare the return code
            ldmfd   sp!, {lr}       @ recover the lr from stack
            mov     pc, lr          @ return from main			 

@ literal pool
