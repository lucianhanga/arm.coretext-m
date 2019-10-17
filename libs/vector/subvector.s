@--------1---------2---------3---------4---------5---------6---------7---------8
@       
@  SubVector
@ 
@  Search a subvector within a vector.
@ 
@ 
@ 

            .text
            .global lh_vector_subvector
@ parameters
@   r0: address of the vector (pointer to an unsigned 32bit value)
@   r1: size of the vector
@   r2: address of the subvector (pointer to an unsigned 32bit value)
@   r3: size of the subvector
@
@   ret:  -1   the substring was not found 
@         >=0  the substring was found and the return value is the index
@
lh_vector_subvector:
            stmfd   sp!, {lr}       @ store the Link Register
            stmfd   sp!, {r4-r10}   @ store the non-volatile registers
            @ function parameters
p_arr       .req    r0
arr_size    .req    r1
p_sarr      .req    r2
sarr_size   .req    r3
            @ local variables
i_end       .req    r4
i           .req    r5
j           .req    r6
val1        .req    r7
val2        .req    r8
rcode       .req    r9
i_j         .req    r10


            cmp     sarr_size, arr_size @ if the subvec. bigger than the vec.
            movgt   r0, #-1             @ return -1
            bgt     ret                 @ exit function

            sub     i_end, arr_size, sarr_size
            mov     i, #0           @ beginning of the outer array
i_loop:     cmp     i, i_end        @ check if the outer array is finished
            movgt   r0, #-1         @ if it exits from here ret: -1; no match
            bgt     ret             @ return from the function.
            mov     j, #0           @ beginning of the inner array
j_loop:     cmp     j, sarr_size    @ check the exit condition for inner loop
            movge   r0, i           @ if exit from here the match was found: i
            bge     ret             @ exit the inner loop and function
            add     i_j, i, j       @ calculate the index for out vec
            ldr     val1, [p_arr, i_j, lsl #2] @ load the value from out vec
            ldr     val2, [p_sarr, j, lsl #2]  @ load the value from innen
            cmp     val1, val2      @ compare the values
            movne   rcode, #-1      @ if not-equal rcode  <- -1
            bne     j_loop_exit     @ if not-equal exit the inner loop
            add     j, j, #1        @ increase the j index
            b       j_loop          @ close the inner loop
j_loop_exit:
            add     i, i, #1        @ increaze the i index
            b       i_loop          @ close the outer loop
i_loop_exit:

ret:        ldmfd   sp!, {r4-r10}   @ restore the nonvolatile registers
            ldmfd   sp!, {lr}       @ restore the Link Register
            mov     pc, lr          @ return to the caller
