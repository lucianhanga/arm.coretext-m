@--------1---------2---------3---------4---------5---------6---------7---------8
@
@ Test programm for the vector library: lh_vector_reverse
@

            .data

arr:        .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62, 51
            .equ    arr_size, (. - arr) >> 2
arr2:       .word   12, 03, 89, 16, 22, 19, 67, 04, 12, 98, 02, 55
            .word   82, 23, 19, 46, 12, 29, 77, 24, 42, 18, 62
            .equ    arr2_size, (. - arr2) >> 2
fmt_txt:    .string "Forwards:  "
fmt_txt2:   .string "Backwards: "
fmt_nr:     .string "%02d "

            .text
            .global main

main:       stmfd   sp!, {lr}

@ run the function test for an even array
            @ print the forward array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr
            mov     r3, #arr_size
            bl      lh_print_array
            @ call the revering function
            ldr     r0, =arr
            mov     r1, #arr_size
            bl      lh_vector_reverse
            @ print the backwards array
            ldr     r0, =fmt_txt2
            ldr     r1, =fmt_nr
            ldr     r2, =arr
            mov     r3, #arr_size
            bl      lh_print_array

@ run the function test for an odd array
            @ print the forward array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr2
            mov     r3, #arr2_size
            bl      lh_print_array
            @ call the revering function
            ldr     r0, =arr2
            mov     r1, #arr2_size
            bl      lh_vector_reverse
            @ print the backwards array
            ldr     r0, =fmt_txt2
            ldr     r1, =fmt_nr
            ldr     r2, =arr2
            mov     r3, #arr2_size
            bl      lh_print_array

ret:        mov     r0, #0
            ldmfd   sp!, {pc}
