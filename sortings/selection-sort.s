@--------1---------2---------3---------4---------5---------6---------7---------8
@       
@
            .data
arr:        .word       12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word       82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
@arr:        .word       12, 03, 89
            .equ        arr_size, (. - arr) >> 2
fmt1:       .string     "UnSorted: "
fmt2:       .string     "Sorted:   "
fmt_vals:   .string     "  %02d"
fmt_end:    .string     "\n"

            .text
            .global     main
main:	    stmfd   sp!, {lr}       @ save the  lr register, because it might
                                    @ be overwritten by other func. calls.

            @ print the unsorted array
e_print_unsorted:
            ldr     r0, =fmt1
            bl      printf

            mov     r5, #0          @ loop counter
            ldr     r4, =arr        @ array pointer
e_print_unsorted_loop:
            cmp     r5, #arr_size   @ check for exit condition
            bge     e_print_unsorted_loop_end  @ exit condition met; exit now
            ldr     r0, =fmt_vals   @ load the fmt string for the print
            ldr     r1, [r4], #1<<2 @ load the array element to print
            push    {r4,  r5}       @ save the array pointer and loop index
            bl      printf
            pop     {r4, r5}        @ restore array pointer and loop index

            add     r5, r5,#1       @ increment the loop counter
            b       e_print_unsorted_loop   @ close the loop
e_print_unsorted_loop_end:
            ldr     r0, =fmt_end
            bl      printf


        @ sorting r0,r1,r2,r3,r4,r5

            push    {r1-r5}
p_arr       .req    r0              @ pointer to the arr array
i           .req    r3              @ the counter for the rounds loop
j           .req    r4              @ the counter for the unsorted array loop
i_min       .req    r5              @ the index which keeps the position of the
                                    @ smallest element in the unsorted

            ldr     p_arr, =arr     @ initialize the pointer p_arr
            mov     i, #0           @ initialize the rounds loop
e_loop_rounds:
            cmp     i, #arr_size-1  @ check the condition to exit the rounds 
            bge     e_loop_rounds_end @ loop
            mov     i_min, i        @ initialize the inext of min element
            mov     j, i            @ initialize the unsorted loop
            add     j, j, #1        @ j<-i+1
e_loop_unsorted:
            cmp     j, #arr_size    @ check the exit condition for the unsorted
            bge     e_loop_unsorted_end @ array loop

            ldr     r1, [p_arr, j, lsl #2]      @ load the value arr[j]
            ldr     r2, [p_arr, i_min, lsl #2]  @ load the value arr[i_min]
            cmp     r1, r2                      @ check if arr[j]<arr[i_min]
            strlt   r1, [p_arr, i_min, lsl #2]  @ if yes, then do the swap
            strlt   r2, [p_arr, j, lsl #2]      @ by cross storing registers

            add     j, j, #1        @ increment the j counter
            b       e_loop_unsorted @ close the unstored loop
e_loop_unsorted_end:
            @ at  this point the _in will have  the smallest value
            @ do the swap
            ldr     r1, [p_arr, i, lsl #2]      @ load the value arr[i]
            ldr     r2, [p_arr, i_min, lsl #2]  @ load  the value arr[i_min]
            str     r2, [p_arr, i, lsl #2]      @ swap the  values
            str     r1, [p_arr, i_min, lsl #2]  @ by storing the other way

            add     i, i, #1        @ increment the rounds loop counter: i
            b       e_loop_rounds   @ close the rounds loop
e_loop_rounds_end:
            pop     {r1-r5}



            @ print the sorted array
e_print_sorted:
            ldr     r0, =fmt2
            bl      printf

            mov     r5, #0          @ loop counter
            ldr     r4, =arr        @ array pointer
e_print_sorted_loop:
            cmp     r5, #arr_size   @ check for exit condition
            bge     e_print_sorted_loop_end  @ exit condition met; exit now
            ldr     r0, =fmt_vals   @ load the fmt string for the print
            ldr     r1, [r4], #1<<2 @ load the array element to print
            push    {r4,  r5}       @ save the array pointer and loop index
            bl      printf
            pop     {r4, r5}        @ restore array pointer and loop index

            add     r5, r5, #1      @ increment the loop counter
            b       e_print_sorted_loop   @ close the loop
e_print_sorted_loop_end:
            ldr     r0, =fmt_end
            bl      printf

ret:        mov     r0, #0          @ prepare the return code
            ldmfd   sp!, {lr}       @ recover the lr from stack
            mov     pc, lr          @ return from main			 


@ literal pool
