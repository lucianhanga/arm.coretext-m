@--------1---------2---------3---------4---------5---------6---------7---------8
@      
@   Shift Left
@ 
@   The function shifts the elements of the vector to the left (from the last)
@   element, towards the first element and fills in the remained empty space
@   with the value from r3. The elements which are shifted out are lost. 
@
@   Parameters:
@       r0: the address of the vector (pointer to a unsigned 32bit value)
@       r1: the size of the vectors (number of elements)
@       r2: the elements which are to be shifted.
@       r3: the value used to fill  the empty spaces.

            .text
            .global lh_vector_lsl

lh_vector_lsl:
            stmfd   sp!, {lr}       @ store the return address (Link Register)
            stmfd   sp!, {r4-r7}    @ store the non-volative register

            @ parameters 
p_arr       .req    r0
arr_size    .req    r1
shift       .req    r2
fill        .req    r3
            @ local automatic parameters
p_arr_i     .req    r4      @ the source pointer
p_arr_j     .req    r5      @ the destination pointer
temp        .req    r6      @ register used  for moving values
p_arr_end   .req    r7      @ end of the matrix pointer

            @ prepare the source and destination pointers
            mov     p_arr_j, p_arr      @ the source is the start of the array
            add     p_arr_i, p_arr_j, shift, lsl #2 @ the destination
            add     p_arr_end, p_arr, arr_size, lsl #2 @ the end of the array
            @ start hte loop which does the shifting
loop:       cmp     p_arr_i, p_arr_end  @ check the exit loop condition
            ldrlt   temp, [p_arr_i], #4 @ if looping then execute ldr
            strlt   temp, [p_arr_j], #4 @ if looping then execute str
            blt     loop                @ if looping close the loop

            @ fill in the empty spaces with the value from fill
loop2:      cmp     p_arr_j, p_arr_end
            strlt   fill, [p_arr_j], #4
            blt     loop2

ret:        mov     r0, #0
            ldmfd   sp!, {r4-r7}    @ restore the non-volative register
            ldmfd   sp!, {lr}
            mov     pc, lr


