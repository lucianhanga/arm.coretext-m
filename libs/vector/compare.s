@--------1---------2---------3---------4---------5---------6---------7---------8
@      
@   Compare
@ 
@   This function compares two arrays of the same size and checks if they are
@   identical. 
@
@   Parameters:
@       r0: the address of the vector (pointer to a unsigned 32bit value)
@       r1: the address of the second vector
@       r2: the size of the vectors (number of elements)
@
@   Return value:
@       r0 <-- 1 : NOT identical
@       r0 <-- 0 : IDENTICAL
@
@   

            .text
            .global lh_vector_compare
lh_vector_compare:
            stmfd   sp!, {lr}       @ store the return address (Link Register)
            stmfd   sp!, {r4-r5}    @ store the non-volative register

            @ since the registers which hold the parametres will not be 
            @ altered because of some other calls within this call, just
            @ make some aliases and keep the parametrers in the original regs.
arr1        .req    r0
arr2        .req    r1
size        .req    r2
            mov     arr1, r0
            mov     arr2, r1
            mov     size, r2
i           .req    r3              @ loop index
elm1        .req    r4
elm2        .req    r5
            mov     i, #0           @ initialize the loop counter
loop:       cmp     i, size         @ check the exit condition
            bge     loop_exit
            ldr     elm1, [arr1],#4 @ load the element and then advance
            ldr     elm2, [arr2],#4 @ load the element and then advance
            cmp     elm1, elm2      @ bit compare the elements 
            movne   r0, #1          @ if not equal prepare the return code 1
            bne     ret             @ exit the loop and return 1
            add     i, i, #1        @ increment the counter
            b       loop            @ close the loop
loop_exit:
            mov     r0, #0
ret:        ldmfd   sp!, {r4-r5}    @ restore the non-volative register
            ldmfd   sp!, {lr}       @ restore the return address (Link Register)
            mov     pc, lr          @ return to caller
