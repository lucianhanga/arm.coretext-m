@--------1---------2---------3---------4---------5---------6---------7---------8
@
@ Test programm for the vector library: lh_vector_replace
@

            .data

arr:        .word   11, 12, 13, 14, 22, 33, 44, 11, 12, 13, 14, 22
            .word   33, 11, 12, 13, 14, 22, 33, 44, 10, 12, 14, 22
            .equ    arr_size, (. - arr) >> 2
arrs:       .word   11, 12, 13, 14
            .equ    arrs_size, (. - arrs) >> 2
arrr:       .word   55, 66, 77, 88
            .equ    arrr_size, (. - arrr) >> 2
fmt_txt:    .string "ArrayBefore: "
fmt_s:      .string "Search:      "
fmt_r:      .string "Replace:     "
fmt_txt2:   .string "ArrayAfter:  "
fmt_nr:     .string "%02d "
fmt_ret:    .string "return code  %d\n"

            .text
            .global main

main:       stmfd   sp!, {lr}

            @ print the initial array
            ldr     r0, =fmt_txt
            ldr     r1, =fmt_nr
            ldr     r2, =arr
            mov     r3, #arr_size
            bl      lh_print_array
            @ print the search array
            ldr     r0, =fmt_s
            ldr     r1, =fmt_nr
            ldr     r2, =arrs
            mov     r3, #arrs_size
            bl      lh_print_array
            @ print the replace array
            ldr     r0, =fmt_r
            ldr     r1, =fmt_nr
            ldr     r2, =arrr
            mov     r3, #arrr_size
            bl      lh_print_array
            @ call the replacing function
            ldr     r0, =arr
            mov     r1, #arr_size
            ldr     r2, =arrs
            mov     r3, #arrs_size
            ldr     r4, =arrr
            stmfd   sp!, {r4}
            bl      lh_vector_replace
            add     sp, sp, #4
            @ print the return code
            mov     r1, r0
            ldr     r0, =fmt_ret
            bl      printf
            @ print the backwards array
            ldr     r0, =fmt_txt2
            ldr     r1, =fmt_nr
            ldr     r2, =arr
            mov     r3, #arr_size
            bl      lh_print_array

ret:        mov     r0, #0
            ldmfd   sp!, {pc}
