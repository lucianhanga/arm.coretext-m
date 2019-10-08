@--------1---------2---------3---------4---------5---------6---------7---------8
@      
@   Post-Test Loops
@
@   The pre-test loop is a loop in which the exit test is done AFTER the block
@   of the loop body is executed. If the test evaluates to TRUE then the loop 
@   is executed all over again. Otherwise it exits and continue the execution.
@
@   IMPORTANT: In Post-Test Loops the loop body is ALWAYS executed at least 
@   once.
@
@   This is equivalent with a C do-while loop:
@
@   i=0
@   do {
@       printf("%02d ", i)
@       i++;
@   } while (i<1024)
@

            .data
fmt:        .string "%04d   "
            .text
            .global main
main:       stmfd   sp!, {lr}

i           .req    r1

            mov     r2, #1<<10  @ r2 <- 10; for checking the exit condition
            mov     i, #0       @ initialize the loop counter/index

loop:       @ ----- loop body -----
            ldr     r0, =fmt    
            stmfd   sp!, {r1,r2} @ save the r0 and r1; (r0-r3) are volatile
            bl      printf
            ldmfd   sp!, {r1,r2} @ restore the r0 and r1

            add     i, i, #1     @ increment the loop counter 
            @ ----- end of loop body ------

            cmp     i, r2       @ check the exit condition 
            blt     loop        @ close the loop
loop_end:

ret:        mov     r0, #0
            ldmfd   sp!, {lr}

