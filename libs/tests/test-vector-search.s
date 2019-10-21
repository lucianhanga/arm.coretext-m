@--------1---------2---------3---------4---------5---------6---------7---------8
@
@ Test programm for the vector library: lh_vector_search
@
            .data

arr:        .word   10, 11, 12, 13 ,14, 15, 16, 17, 18, 19, 20
            .word   21, 22, 23, 24, 25, 26, 27, 28, 29, 30
            .equ    arr_size, (. - arr) >> 2
sarr1:      .word   10, 11, 12
            .equ    sarr1_size, (. - sarr1) >> 2
sarr2:      .word   10, 11, 13
            .equ    sarr2_size, (. - sarr2) >> 2
sarr3:      .word   28, 29, 30
            .equ    sarr3_size, (. - sarr3) >> 2
sarr4:      .word   10, 11, 12, 13 ,14, 15, 16, 17, 18, 19, 20
            .word   21, 22, 23, 24, 25, 26, 27, 28, 29, 30
            .equ    sarr4_size, (. - sarr4) >> 2
sarr5:      .word   28, 29, 31
            .equ    sarr5_size, (. - sarr5) >> 2

fmt_txt:    .string "array:    "
fmt2_txt:   .string "subarray: "
fmt_nr:     .string "%02d "
fmt_ret:    .string "lh_vector_search ret: %d\n"

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
            @ do the search of sub-vector in vector
            ldr     r0, =arr
            mov     r1, #arr_size
            ldr     r2, =sarr1
            mov     r3, #sarr1_size
            bl      lh_vector_search
            @ print the comparation result
            mov     r1, r0
            ldr     r0, =fmt_ret
            bl      printf

            @ print the sub array 2
            ldr     r0, =fmt2_txt
            ldr     r1, =fmt_nr
            ldr     r2, =sarr2
            mov     r3, #sarr2_size
            bl      lh_print_array
            @ do the search of sub-vector in vector
            ldr     r0, =arr
            mov     r1, #arr_size
            ldr     r2, =sarr2
            mov     r3, #sarr2_size
            bl      lh_vector_search
            @ print the comparation result
            mov     r1, r0
            ldr     r0, =fmt_ret
            bl      printf

            @ print the sub array 3
            ldr     r0, =fmt2_txt
            ldr     r1, =fmt_nr
            ldr     r2, =sarr3
            mov     r3, #sarr3_size
            bl      lh_print_array
            @ do the search of sub-vector in vector
            ldr     r0, =arr
            mov     r1, #arr_size
            ldr     r2, =sarr3
            mov     r3, #sarr3_size
            bl      lh_vector_search
            @ print the comparation result
            mov     r1, r0
            ldr     r0, =fmt_ret
            bl      printf

            @ print the sub array 4
            ldr     r0, =fmt2_txt
            ldr     r1, =fmt_nr
            ldr     r2, =sarr4
            mov     r3, #sarr4_size
            bl      lh_print_array
            @ do the search of sub-vector in vector
            ldr     r0, =arr
            mov     r1, #arr_size
            ldr     r2, =sarr4
            mov     r3, #sarr4_size
            bl      lh_vector_search
            @ print the comparation result
            mov     r1, r0
            ldr     r0, =fmt_ret
            bl      printf

            @ print the sub array 5
            ldr     r0, =fmt2_txt
            ldr     r1, =fmt_nr
            ldr     r2, =sarr5
            mov     r3, #sarr5_size
            bl      lh_print_array
            @ do the search of sub-vector in vector
            ldr     r0, =arr
            mov     r1, #arr_size
            ldr     r2, =sarr5
            mov     r3, #sarr5_size
            bl      lh_vector_search
            @ print the comparation result
            mov     r1, r0
            ldr     r0, =fmt_ret
            bl      printf

ret:        mov     r0, #0
            ldmfd   sp!, {pc}
