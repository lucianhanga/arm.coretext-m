@--------1---------2---------3---------4---------5---------6---------7---------8
@       
@   Insertion Sort
@ 
@    Sorts an array using the insertion technique. The array is considered 
@    composed of two parts sorted and unsorted. Sorted is at the beginning of
@    the array and initially has only one element: the first element of the
@    array. The unsorted array continues after the sorted array. The algorithm
@    takes one by one the elements of the unsorted array and tries to find
@    the place in the sorted array where they have to be inserted. Once 
@    the place found the elements after the place will be shifted forward with
@    one position and the element inserted in the place made.
@ 
@     example: suppose that we have [s]orted 1..4 and [u]nsorted 1..5
@     s1 s2 s3 s4 u1 u2 u3 u4 u5
@      
@     now is the time u1 to be inserted in the sorted one and it was found
@     that the u1 is biger then s2 but smaller than s3 which means that 
@     elements s3..s4 need to be shifted with one to right overwriting the u1
@     and the u1 should be inserted in the place made by shifting the u3.
@     
@     s1 s2 s3 s4 u1 u2 u3 u4 u5
@     tmp <-u1
@     s1 s2 ___ s3 s4 u2 u3 u4 u5
@     s1 s2 u1(tmp) s3 s4 u2 u3 u4 u5
@ 
@     int i;
@     int j;
@     for(i=1; i<n; i++) {
@       int tmp = arr[i];  // save the element value for move
@       for(j=0; j<i; j++) {
@         if(tmp<arr[j]) // if the element to be moved is smaller then the
@           break;       // arr[j] then stop because j is the place where to
@       }                // insert it.
@       // make place for the element, starting from the end
@       for(k=i-1;k>=j;k--)
@          arr[k+1]=arr[k];
@       // make the insertion
@       arr[j]=tmp;
@     }
@ 
@   https://www.geeksforgeeks.org/sorting-algorithms/
@ 

            .text
            .global lh_sort_insertion
@ parameters:
@       r0: the address of the vector (pointer to an unsigned 32bit value)
@       r1: the size of the vector (the number of elements  of the vector)
lh_sort_insertion:
            stmfd   sp!, {lr}       @ save the return address 
            @ function parameters
p_arr       .req    r0
arr_size    .req    r1
            @local variables
i           .req    r2
j           .req    r3
k           .req    r4
element     .req    r5
tmp         .req    r6
p_tmp2      .req    r7



            stmfd   sp!, {r4-r7}    @ save the non-volatile registers

            @start the algorithm
            mov     i, #1           @ first element is already in the sorted
loop_unsorted:
            cmp     i, arr_size     @ check the exit condition
            bge     loop_unsorted_end @ conition is met, exit the loop
            ldr     element, [p_arr, i, lsl #2] @ copy the element <- p_arr[i]

            @ now find the place where the element has to be inserted
            mov     j, #0
loop_sorted:
            cmp     j,i             @ check the exit condition
            bge     loop_unsorted_next @ if the condition is reached it means
                                    @ the element is big enough to stay on its
                                    @ place and does not need to be moved
                                    @ so move to the next element
            ldr     tmp, [p_arr, j, lsl #2] @ load the current sorted elem.
            cmp     element, tmp    @ check if element is bigger smaller 
                                    @ then the current sorted one and then
            blt     loop_sorted_end @ exit the sorted loop. position found: j
            add     j, j, #1
            b       loop_sorted
loop_sorted_end:
            @ at this point the element new position is in the index j
            @ the elements starting with j should be shifted to right
            @ for this we should start from last one [i-1] to first one: [j]
            mov     k, i
            add     p_tmp2, p_arr, i, lsl #2 @ the position of the element which
loop_make_space:
            cmp     k, j
            ble     loop_make_space_end
            ldr     tmp, [p_tmp2, #-4]!  @ load from [k-1] with pre decrement
            str     tmp, [p_tmp2, #+4]   @ store it to [k]
            sub     k, #1
            b       loop_make_space
loop_make_space_end:
            str     element, [p_arr, j, lsl #2]
loop_unsorted_next:
            add     i, i, #1
            b       loop_unsorted
loop_unsorted_end:


            ldmfd   sp!, {r4-r7}    @ restore the non-volatile register

ret:        mov     r0, #0          @ return value
            ldmfd   sp!, {lr}       @ recover the lr from the stack
            mov     pc, lr          @ return to the caller 

