@--------1---------2---------3---------4---------5---------6---------7---------8
@
@ Test programm for the vector library: lh_vector_compare
@

            .data

arr1:       .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
            .equ    arr1_size, (. - arr1) >> 2
arr2:       .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
            .equ    arr2_size, (. - arr2) >> 2
arr3:       .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 50
            .equ    arr3_size, (. - arr3) >> 2
arr4:       .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
            .equ    arr4_size, (. - arr4) >> 2
fmt_txt:    .string "array1:  "
fmt_txt2:   .string "array2:  "
fmt_nr:     .string "%02d "
fmt_equal:  .string "Identical\n"
fmt_no:     .string "Different\n"

            .text
            .global main

main:       stmfd   sp!, {lr}

@ run the function test for identical arrays
            @ print the array1
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr1
            mov     r3, #arr1_size
            bl      lh_print_array
            @ print the array2
            ldr     r0, =fmt_txt2
            ldr     r1, =fmt_nr
            ldr     r2, =arr2
            mov     r3, #arr2_size
            bl      lh_print_array
            @ call the compare function
            ldr     r0, =arr1
            ldr     r1, =arr2
            mov     r2, #arr1_size
            bl      lh_vector_compare
            @ check the return code
            tst     r0, #0
            bne     not_identical
            ldr     r0, =fmt_equal
            bl      printf
            b       next_test
not_identical:
            ldr     r0, =fmt_no
            bl      printf     
next_test:
@ run the function test for identical arrays
            @ print the array1
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr3
            mov     r3, #arr3_size
            bl      lh_print_array
            @ print the array2
            ldr     r0, =fmt_txt2
            ldr     r1, =fmt_nr
            ldr     r2, =arr4
            mov     r3, #arr4_size
            bl      lh_print_array
            @ call the compare function
            ldr     r0, =arr3
            ldr     r1, =arr4
            mov     r2, #arr3_size
            bl      lh_vector_compare
            @ check the return code
            cmp     r0, #0
            bne     not_identical2
            ldr     r0, =fmt_equal
            bl      printf
            b       next_test2
not_identical2:
            ldr     r0, =fmt_no
            bl      printf


next_test2:

ret:        mov     r0, #0
            ldmfd   sp!, {pc}
