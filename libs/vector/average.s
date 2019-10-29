@--------1---------2---------3---------4---------5---------6---------7---------8
@       
@  Average
@ 
@  Calculate the integer average of the elements of the vector
@ 
@ 
@ 

            .text
            .global lh_vector_average
@ parameters
@   r0: address of the vector (pointer to an unsigned 32bit value)
@   r1: size of the vector
@   ret:  the average of the vector elements
@
lh_vector_average:
            stmfd   sp!, {lr}       @ store the Link Register
            stmfd   sp!, {r4-r5}    @ store the non-volatile registers
            @ function parameters
p_arr       .req    r0
arr_size    .req    r1
            @ local variables
i           .req    r2
sum_hi      .req    r3
sum_lo      .req    r4
element     .req    r5

            @ calculate the sum of all elements
            mov     sum_hi, #0      @ initialize the sum
            mov     sum_lo, #0 
            mov     i, #0           @ initialize the vector loop counter
i_loop:     cmp     i, arr_size     @ check the exit condition
            bge     i_loop_exit     @ exit condition was met 
            ldr     element, [r0, i, lsl #2]; @ load the element
            add     sum_lo, sum_lo, element @ add the element
            adc     sum_hi, sum_hi, #0  @ if a carry take it in account
            add     i, i, #1        @ increaze the i index
            b       i_loop          @ close the outer loop
i_loop_exit:
            @ do the division
            


            mov     r0,  sum_lo     @ prepare the return value
ret:        ldmfd   sp!, {r4-r5}    @ restore the nonvolatile registers
            ldmfd   sp!, {lr}       @ restore the Link Register
            mov     pc, lr          @ return to the caller
