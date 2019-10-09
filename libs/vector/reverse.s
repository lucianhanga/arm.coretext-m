@--------1---------2---------3---------4---------5---------6---------7---------8
@      
@   Reverse
@
@   Implement the function which gets as a parameter an array and revese the
@   elements of the array. 
@   e1, e2, e3, ...  en --->  en, ... e3, e2, e1
@  
@   IMPORTANT: this implementation is recursive, so take care on the stack size
@
@
@  parameters:
@       r0: the address of the vector (pointer to a unsigned 32bit value)
@       r1: the size of the vector (the size of the vector)
@
@  return value:
@       void 
@
            .text
            .global lh_vector_reverse
lh_vector_reverse:
            stmfd   sp!, {lr}       @ store the return address (Link Register)
            stmfd   sp!, {r4-r7}    @ store the non-volative register

            @ process function parameters and assign to local variables
arr         .req    r4
arr_size    .req    r5
temp        .req    r6
temp2       .req    r7
            mov     arr, r0
            mov     arr_size, r1

            cmp     arr_size, #1    @ check the exit condition
            ble     ret             @ conition met; exit (recursive) call
            @ do the eXchg
            sub     r1, arr_size, #1 @ r1 <- ra_arr_size - 1
            ldr     temp,  [arr]
            ldr     temp2, [arr, r1, lsl #2] 
            str     temp2, [arr]
            str     temp,  [arr, r1, lsl #2]

            @ prepare the recursive call
            add     r0, arr, #4     @ array pointer advance 1 element
            sub     r1, arr_size,#2 @ shave also an element from the back
            @ decrease with 2 because 1 in the front and one in the back
            bl      lh_vector_reverse @ recursive call

ret:        mov     r0, #0
            ldmfd   sp!, {r4-r7}    @ restore the non-volative register
            ldmfd   sp!, {lr}       @ restore the return address (Link Register)
            mov     pc, lr          @ return to caller
