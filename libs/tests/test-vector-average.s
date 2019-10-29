@--------1---------2---------3---------4---------5---------6---------7---------8
@
@ Test programm for the vector library: lh_vector_average
@
            .data

arr:        .word   16, 16
@arr:        .word   10, 11, 12, 13 ,14, 15, 16, 17, 18, 19, 20
@            .word   21, 22, 23, 24, 25, 26, 27, 28, 29, 30
            .equ    arr_size, (. - arr) >> 2
average:    .word   0
fmt_txt:    .string "array:    "
fmt_nr:     .string "%02d "
fmt_avr:    .string "average: %02d\n"

            .text
            .global main

main:       stmfd   sp!, {lr}
            @ print the main array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr
            mov     r3, #arr_size
            bl      lh_print_array
            @ do the average calculation
            ldr     r0, =arr
            mov     r1, #arr_size
            bl      lh_vector_average
            @ print the average
            mov     r1, r0
            ldr     r0, =fmt_avr
            bl      printf
ret:        mov     r0, #0
            ldmfd   sp!, {pc}
