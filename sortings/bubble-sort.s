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

            .data
arr:        .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
            .equ    arr_size, (. - arr) >> 2

fmt1:       .string "UnSorted: "
fmt2:       .string "Sorted:   "
fmt_nr:     .string " %02d"
fmt_end:    .string "\n"

            .text
            .global main
main:       stmfd   sp!, {lr}       @ push to a Full Descending Stack

@ print the unsorted array
            ldr     r0, =fmt1
            bl      printf
e_print_unsorted:
            ldr     r2, =arr
            mov     r5, #0
e_print_unsorted_loop:
            cmp     r5, #arr_size
            bge     e_print_unsorted_loop_end
            ldr     r0, =fmt_nr
            ldr     r1, [r2], #1<<2
            stmfd   sp!, {r2, r5}   @ save the r2 and r5 to protect the call
            bl      printf
            ldmfd   sp!, {r2, r5}   @ load back the r2 and r5
            add     r5, r5, #1
            b       e_print_unsorted_loop
e_print_unsorted_loop_end:
            ldr     r0, =fmt_end
            bl      printf

@ do the sorting 
            .equ    false, 0
            .equ    true,  1
i           .req    r5
j           .req    r7
dirty       .req    r2              @ dirty flag which indicates that in the 
                                    @ round a swap happened.
            mov     dirty, #true    @ dirty <- TRUE
e_while_loop: 
            cmp     dirty, #false   @ check the exit condition
            beq     e_while_loop_exit @ if NOT dirty exit the loop 
            mov     dirty, #false   @ clear the dirty flag dirty <- FALSE
            mov     i, #0
            ldr     r3, =arr
e_swap_loop:  
            cmp     i, #arr_size-1  @ check the exit condition
            bge     e_swap_loop_exit
            add     j, i, #1        @ the index of the adjacent element
            ldr     r4, [r3, i, lsl #2] @load the element arr[i]
            ldr     r6, [r3, j, lsl #2] @load the element arr[i+1]
            cmp     r4, r6              @ compare and if arr[i] > arr[i+1]
            strgt   r6, [r3, i, lsl #2] @ if true, cross store the registers
            strgt   r4, [r3, j, lsl #2] @ making the swap
            movgt   dirty, #true
            add     i, i, #1        @ increment the loop counter/index
            b       e_swap_loop
e_swap_loop_exit:
            b       e_while_loop      @ close the while loop
e_while_loop_exit:

@ print the sorted array
            ldr     r0, =fmt2
            bl      printf
e_print_sorted:
            ldr     r2, =arr
            mov     r5, #0
e_print_sorted_loop:
            cmp     r5, #arr_size
            bge     e_print_sorted_loop_end
            ldr     r0, =fmt_nr
            ldr     r1, [r2], #1<<2
            stmfd   sp!, {r2, r5}   @ save the r2 and r5 to protect the call
            bl      printf
            ldmfd   sp!, {r2, r5}   @ load back the r2 and r5
            add     r5, r5, #1
            b       e_print_sorted_loop
e_print_sorted_loop_end:
            ldr     r0, =fmt_end
            bl      printf

ret:        mov     r0, #0
            ldmfd   sp!, {lr}       @ pop from a Full Descending Stack
            mov     pc, lr
