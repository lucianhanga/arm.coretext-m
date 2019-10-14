//-------1---------2---------3---------4---------5---------6---------7---------8
//      
// Selection Sort
//
//    Sorts an array by repeatedly finding the  minimum element (ascending 
//    sorting) from the unsorted part and putting it at the beginning. The
//    algorithm maintains two subarrays in a given array:
//      - The subarray which is already sorted 
//      - Remaining subarray which is unsorted
//    example arr  = 12 14 29 17 09 56 98 11 10 06 88 01 
//    The ordered subarray has at first 0 elements and search through the
//    unordered one the minimum which is 01 and swap it the first element in
//    unordered array, here would be 12. Then the array will look:
//      arr = 01  14 29 17 09 56 98 11 10 06 88 12
//    Next iterration would be:
//      arr = 01 06   29 17 09 56 98 11 10 14 88 12
//   and so on ...
//
//  https://www.geeksforgeeks.org/sorting-algorithms/
//


            .text
            .global     lh_sort_selection
@ parameters
@       r0: the address of the vector (pointer to an unsigned 32bit value)
@       r1: the size of the vector (the number of  elements of  the vector)
lh_sort_selection:
            stmfd   sp!,  {lr}      @ save the return address
            @ function parameters
p_arr       .req    r0              @ address of the vector
arr_size    .req    r1
            @ local variables
i           .req    r3              @ the counter for the rounds loop
j           .req    r4              @ the counter for the unsorted array loop
i_min       .req    r5              @ the index which keeps the position of the
                                    @ smallest element in the unsorted

            push    {r4-r8}         @ save thre volatile registers


            mov     r8, arr_size
            sub     r8, r8, #1      @ r8 <- arr_size - 1
            mov     i, #0           @ initialize the rounds loop
loop_rounds:
            cmp     i, r8           @ check the condition to exit the rounds 
            bge     loop_rounds_end @ loop
            mov     i_min, i        @ initialize the inext of min element
            mov     j, i            @ initialize the unsorted loop
            add     j, j, #1        @ j<-i+1
loop_unsorted:
            cmp     j, arr_size     @ check the exit condition for the unsorted
            bge     loop_unsorted_end @ array loop

            ldr     r6, [p_arr, j, lsl #2]      @ load the value arr[j]
            ldr     r7, [p_arr, i_min, lsl #2]  @ load the value arr[i_min]
            cmp     r6, r7                      @ check if arr[j]<arr[i_min]
            strlt   r6, [p_arr, i_min, lsl #2]  @ if yes, then do the swap
            strlt   r7, [p_arr, j, lsl #2]      @ by cross storing registers

            add     j, j, #1        @ increment the j counter
            b       loop_unsorted @ close the unstored loop
loop_unsorted_end:
            @ at  this point the _in will have  the smallest value
            @ do the swap
            ldr     r7, [p_arr, i, lsl #2]      @ load the value arr[i]
            ldr     r8, [p_arr, i_min, lsl #2]  @ load  the value arr[i_min]
            str     r8, [p_arr, i, lsl #2]      @ swap the  values
            str     r7, [p_arr, i_min, lsl #2]  @ by storing the other way

            add     i, i, #1        @ increment the rounds loop counter: i
            b       loop_rounds   @ close the rounds loop
loop_rounds_end:
            pop     {r4-r8}

ret:        mov     r0, #0          @ prepare the return code
            ldmfd   sp!, {lr}       @ recover the lr from stack
            mov     pc, lr          @ return from main			 


@ literal pool
