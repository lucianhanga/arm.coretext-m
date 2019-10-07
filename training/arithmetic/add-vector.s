@--------1---------2---------3---------4---------5---------6---------7---------8
@       
@
            .data
sum:        .word       0
vector1:    .word       0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70, 0x80
vector2:    .word       0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08
            .equ        vectors_size, (. - vector2) >> 2
vector3:    .space      vectors_size << 2 , 0x88
fmt1:       .string     "Vector: "
fmt_vals:   .string     "  %08x"
fmt2:       .string     "\n"

            .text
            .global     main
main:	    stmfd   sp!, {lr}       @ save the  lr register, because it might
                                    @ be overwritten by other func. calls.

            ldr     r0, =vector1
            ldr     r1, =vector2
            ldr     r2, =vector3
          
            mov     r5, #0          @ initialize the for loop index/counter
for_loop:   
            cmp     r5, #vectors_size   @ check exit condition
            beq     for_loop_exit   @ end of loop

            ldr     r3, [r0], #1<<2 @ load the element and advance the pointer
            ldr     r4, [r1], #1<<2 @ load the element and advance the pointer
            add     r3, r3, r4      @ add the elements 
            str     r3, [r2], #1<<2 @ store the value into the result vector

            add     r5, r5, #1      @ update the loop counter
            b       for_loop
for_loop_exit:

            @ print vector
            ldr     r0, =fmt1
            bl      printf

            ldr     r2, =vector3
            mov     r5, #0
for_loop2:             
            cmp     r5, #vectors_size   @ check exit condition
            beq     for_loop2_exit  @ end of loop

            ldr     r0, =fmt_vals
            ldr     r1, [r2], #1<<2 @ loop through the vector 
            push    {r2, r5}        @ save on the stack the r2 and r5
            bl      printf
            pop     {r2, r5}        @ recover from the stask the r2 and r5

            add     r5, r5, #1
            b       for_loop2
for_loop2_exit:
            ldr     r0, =fmt2
            bl      printf

ret:        mov     r0, #0          @ prepare the return code
            ldmfd   sp!, {lr}       @ recover the lr from stack
            mov     pc, lr          @ return from main			 

@ literal pool
