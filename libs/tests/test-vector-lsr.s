@--------1---------2---------3---------4---------5---------6---------7---------8
@
@ Test programm for the vector library: lh_vector_lsr
@

            .data

arr:        .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
            .equ    arr_size, (. - arr) >> 2

arr1:       .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
            .equ    arr_size1, (. - arr1) >> 2

arr2:       .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
            .equ    arr_size2, (. - arr2) >> 2

arr3:       .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
            .equ    arr_size3, (. - arr3) >> 2

arr4:       .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
            .equ    arr_siz4, (. - arr4) >> 2

arr5:       .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
            .equ    arr_size5, (. - arr5) >> 2


fmt_txt:    .string "Vector:  "
fmt_nr:     .string "%02x "
fmt_empty:  .string "\n"
            .text
            .global main

main:       stmfd   sp!, {lr}

            @ print the array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr
            mov     r3, #arr_size
            bl      lh_print_array
            @ call shift to left with 3 element
            ldr     r0, =arr
            mov     r1, #arr_size
            mov     r2, #3
            mov     r3, #0
            bl      lh_vector_lsr
            @ print the array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr
            mov     r3, #arr_size
            bl      lh_print_array

            @ print emptyy
            ldr     r0, =fmt_empty
            bl      printf

            @ print the array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr1
            mov     r3, #arr_size1
            bl      lh_print_array
            @ call shift to left with 16 element
            ldr     r0, =arr1
            mov     r1, #arr_size1
            mov     r2, #16
            mov     r3, #0
            bl      lh_vector_lsr
            @ print the array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr1
            mov     r3, #arr_size1
            bl      lh_print_array

            @ print emptyy
            ldr     r0, =fmt_empty
            bl      printf

            @ print the array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr2
            mov     r3, #arr_size2
            bl      lh_print_array
            @ call shift to left with all element
            ldr     r0, =arr2
            mov     r1, #arr_size2
            mov     r2, #arr_size2
            mov     r3, #0
            bl      lh_vector_lsr
            @ print the array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr2
            mov     r3, #arr_size2
            bl      lh_print_array

            @ print emptyy
            ldr     r0, =fmt_empty
            bl      printf

            @ print the array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr3
            mov     r3, #arr_size3
            bl      lh_print_array
            @ call shift to left with 4 element and fill with 0xFF
            ldr     r0, =arr3
            mov     r1, #arr_size3
            mov     r2, #4
            mov     r3, #0xFF
            bl      lh_vector_lsr
            @ print the array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr3
            mov     r3, #arr_size3
            bl      lh_print_array


ret:        mov     r0, #0
            ldmfd   sp!, {pc}

