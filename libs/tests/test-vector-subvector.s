@--------1---------2---------3---------4---------5---------6---------7---------8
@
@ Test programm for the vector library: lh_vector_subvector
@
            .data

arr:        .word   10, 11, 12, 13 ,14, 15, 16, 17, 18, 19, 20
            .word   21, 22, 23, 24, 25, 26, 27, 28, 29, 30
            .equ    arr_size, (. - arr) >> 2
sarr1:      .word   10, 11, 12
            .equ    sarr1_size, (. - sarr1) >> 2
sarr2:      .word   10, 11, 13
            .equ    sarr2_size, (. - sarr2) >> 2
fmt_txt:    .string "array:    "
fmt2_txt:   .string "subarray: "
fmt_nr:     .string "%02d "
fmt_ret:    .string "lh_vector_subvector ret: %d\n"

            .text
            .global main

main:       stmfd   sp!, {lr}
            @ print the main array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr
            mov     r3, #arr_size
            bl      lh_print_array
            @ print the sub array
            ldr     r0, =fmt2_txt
            ldr     r1, =fmt_nr
            ldr     r2, =sarr1
            mov     r3, #sarr1_size
            bl      lh_print_array

ret:        mov     r0, #0
            ldmfd   sp!, {pc}
