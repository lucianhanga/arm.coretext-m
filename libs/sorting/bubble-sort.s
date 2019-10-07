//-------1---------2---------3---------4---------5---------6---------7---------8
//      
// Bubble Sort
//
//  It works by repatedly swapping the adjacent elemnts of an array if they are
//  in the old order. This procedure is repeted until in a round no swaps
//  occured, which means that all of the elements are in order.
// 
//  https://www.geeksforgeeks.org/sorting-algorithms/
//

            .text
            .global sort_bubble

@ parameters:
@       r0: the address of the vector (pointer to a unsigned 32bit value)
@       r1: the size of the vector (the size of the vector)
sort_bubble:
            stmfd   sp!, {lr}       @ store the return address (Link Register)
            stmfd   sp!, {r3-r10}   @ store the non-volative register

            .equ    false, 0
            .equ    true,  1
arr         .req    r0
arr_size    .req    r1
i           .req    r5
j           .req    r7
dirty       .req    r2              @ dirty flag which indicates that in the 
                                    @ round a swap happened.
            mov     dirty, #true    @ dirty <- TRUE
 
while_loop: cmp     dirty, #false   @ check the exit condition
            beq     e_while_loop_exit @ if NOT dirty exit the loop 
            mov     dirty, #false   @ clear the dirty flag dirty <- FALSE
            mov     i, #0

            mov     r3, arr_size
            sub     r3, r3, #1      @ r3 <- arr_size-1
swap_loop:  cmp     i, r3           @ check the exit condition
            bge     swap_loop_exit
            add     j, i, #1                @ the index of the adjacent element
            ldr     r4, [arr, i, lsl #2]    @load the element arr[i]
            ldr     r6, [arr, j, lsl #2]    @load the element arr[i+1]
            cmp     r4, r6                  @ compare and if arr[i] > arr[i+1]
            strgt   r6, [arr, i, lsl #2]    @ if true, cross store the registers
            strgt   r4, [arr, j, lsl #2]    @ making the swap
            movgt   dirty, #true
            add     i, i, #1                @ increment the loop counter/index
            b       swap_loop
swap_loop_exit:
            b       while_loop      @ close the while loop
while_loop_exit:

ret:
            ldmfd   sp!, {r3-r10}   @ restore the registers
            mov     r0, #0          @ return code 0
            ldmfd   sp!, {pc}       @ return to the caller
