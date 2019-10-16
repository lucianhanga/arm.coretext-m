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
            .global lh_vector_lsr

lh_vector_lsr:
            stmfd   sp!, {lr}       @ store the return address (Link Register)
            @ parameters 
p_arr       .req    r0
arr_size    .req    r1
shift       .req    r2
fill        .req    r3
p_arr_i     .req    r4              @ the source pointer
p_arr_j     .req    r5              @ the destination pointer
temp        .req    r6
            stmfd   sp!, {r4-r7}    @ save the non-volatile registers
            @ prepare the source and destination pointers
            add     p_arr_j, p_arr, arr_size, lsl #2 @ set destination as last 
            sub     p_arr_i, p_arr_j, shift, lsl #2  @ set the source 
loop:       cmp     p_arr_i, p_arr          @ check the exit loop condition
            ldrgt   temp, [p_arr_i, #-4]!   @ if looping then execute ldr
            strgt   temp, [p_arr_j, #-4]!   @ if looping then execut ldr
            bgt     loop            @ if looping close the loop
loop2:      cmp     p_arr_j, p_arr  @ empty spaces will with 'fill' value
            strgt   fill, [p_arr_j, #-4]!   @ sotre 'fill'
            bgt     loop2           @ close the loop

ret:        mov     r0, #0
            ldmfd   sp!, {r4-r7}    @ restore the non-volatile registers
            ldmfd   sp!, {lr}
            mov     pc, lr


