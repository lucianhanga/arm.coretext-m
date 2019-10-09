@--------1---------2---------3---------4---------5---------6---------7---------8
@ 
@   Working with (Sub)Routines in ARM
@   Recursive Subroutines
@
@   In this example a function will be wrtitten which will reverse the order 
@   of a array using a recursive subroutine.
@
@   void array_reverse(unsigned int *array, 
@                      unsigned int array_size) {
@       if(array_size > 1) {
@           register unsigned int temp;
@           temp = array[0];
@           array[0] = array[array_size-1];
@           array[array_size -1] = temp;
@           array_reverse(array+1, array_size-2);
@       }
@   }
@
@

            .data
array1:     .word   11,22,33,44,55,66,77,88,99
            .equ    array1_size, (. - array1) >> 2
array2:     .word   11,22,33,44,55,66,77,88
            .equ    array2_size, (. - array2) >> 2
fmt:        .string "%02d "
fmt_nl:     .string "\n"
            .global main
            .text
main:       stmfd   sp!, {lr}


@ print the first array
            ldr     r0, =fmt
            ldr     r1, =array1
            mov     r2, #array1_size
            bl      print_array

@ do the reversing of the first array
            ldr     r0, =array1
            mov     r1, #array1_size
            bl      reverse_array

@ print the first array reversed
            ldr     r0, =fmt
            ldr     r1, =array1
            mov     r2, #array1_size
            bl      print_array

@  print the second array
            ldr     r0, =fmt
            ldr     r1, =array2
            mov     r2, #array2_size
            bl      print_array

@ do the reversing of the second array
            ldr     r0, =array2
            mov     r1, #array2_size
            bl      reverse_array

@ print the second array reversed
            ldr     r0, =fmt
            ldr     r1, =array2
            mov     r2, #array2_size
            bl      print_array

exit:       mov     r0, #0
            ldmfd   sp!, {lr}
            mov     pc, lr



@
@ subroutine reverse_array
@
@ r0 - pointer to the array
@ r1 - the size of the array
@
reverse_array:
            stmfd   sp!, {lr}       @ store the lr
            stmfd   sp!, {r4-r7}    @ store non-volatile
            @ process function parameters - assign to local variables
ra_arr      .req    r4
ra_arr_size .req    r5
ra_temp     .req    r6
ra_temp2    .req    r7
            mov     ra_arr, r0
            mov     ra_arr_size, r1

            cmp     ra_arr_size, #1 @ check the exit condition
            ble     ra_ret          @ conition met; exit (recursive) call
            @ do the eXchg
            sub     r1, ra_arr_size, #1 @ r1 <- ra_arr_size - 1
            ldr     ra_temp,  [ra_arr]
            ldr     ra_temp2, [ra_arr, r1, lsl #2] 
            str     ra_temp2, [ra_arr]
            str     ra_temp,  [ra_arr, r1, lsl #2]
            @ prepare the recursive call
            sub     r0, ra_arr, #4  @ array pointer advance 1 element
            sub     r1, ra_arr_size, #2 @ shave also an element from the back
            @ decrease with 2 because 1 in the front and one in the back
            bl      reverse_array   @ recursive call
ra_ret:     @ exit function
            mov     r0, #0
            ldmfd   sp!, {r4-r7}    @ restore non-volatile
            ldmfd   sp!, {lr}       @ retore the lr
            mov     pc, lr 

@
@  subroutine print_array
@ 
@
@ r0 - format of the printf
@ r0 - the address of the array
@ r1 - the size of the array
@
@ return 0 (actually it retuns void)
@
print_array:
            stmfd   sp!, {lr}       @ save the link register for return
            stmfd   sp!, {r4-r7}    @ save the non-volatile registers
pa_fmt          .req    r4
pa_arr          .req    r5
pa_arr_size     .req    r6
pa_i            .req    r7

            @ process parameters and assig them to local variables
            mov     pa_fmt, r0
            mov     pa_arr, r1
            mov     pa_arr_size, r2

            mov     pa_i, #0        @ initialize the loop index
pa_loop:    cmp     pa_i, pa_arr_size  @ check the exit condition
            bge     pa_loop_end     @ exit loop if condition is met

            mov     r0, pa_fmt      @ print the element at the index pa_i
            ldr     r1, [pa_arr, pa_i, lsl #2]
            bl      printf

            add     pa_i, pa_i, #1  @ increase the loop index
            b       pa_loop         @ close the loop
pa_loop_end:

            ldr     r0, =fmt_nl     @ print the new line too
            bl      printf

            mov     r0, #0          @ return code
pa_ret:     ldmfd   sp!, {r4-r7}    @ restore the non-volatile registers
            ldmfd   sp!, {lr}       @ restore the Link Register
            mov     pc, lr          @ return to caller
