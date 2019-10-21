@--------1---------2---------3---------4---------5---------6---------7---------8
@       
@  ReplaceVector
@ 
@  Search a subvector within a vector and replace it with another given
@  subvector.
@ 
@ 

            .text
            .global lh_vector_replace
@ parameters
@   r0: address of the vector (pointer to an unsigned 32bit value)
@   r1: size of the vector
@   r2: address of the subvector (pointer to an unsigned 32bit value)
@   r3: size of the subvector
@   <stack>: address of the replacement subvector. The size of the subvector
@       is the same like the size of the searchable subvector (r3)
@
@   ret:  -1   error bad  
@         >=0  how many times the replacepent happened
@
lh_vector_replace:
            stmfd   sp!, {lr}   @ store the Link Register
            stmfd   sp!, {r4-r6} @ store volatile registers
@   parameters
p_arr       .req    r0
arr_size    .req    r1
p_arrs      .req    r2
arrs_size   .req    r3
p_arrr      .req    r4
counter     .req    r6
            ldr     r4, [sp] @ load the 4th parameters in r4
            mov     r5, #0
            mov     counter, #0
loop:       stmfd   sp!, {r0-r4} @ store the regiters for call
            bl      lh_vector_search  @ call the search
            mov     r5, r0       @ save the result in r5 for further use
            ldmfd   sp!, {r0-r4} @ restore the registers after call
            cmp     r5, #-1
            @ call the replacement helper
            @ blne    replace_helper
            addne   r0, r0, r5, lsl #2  @ advance the p_arr over the first ...
            addne   r0, r0, r3, lsl #2  @ occurence of the string
            subne   r1, r1, r3          @ reduce the size of arr with arrs size
            addne   counter, counter, #1
            blne    loop
ret:
            mov     r0, counter
            ldmfd   sp!, {r4-r6} @ restore volatile registers
            ldmfd   sp!, {lr}   @ restore the Link Register (LR)
            mov     pc, lr      @ return from the function


replace_helper:
            stmfd   sp!, {lr}   @ store the Link Register
            stmfd   sp!, {r5-r7}    @save the registers are still needed
            mrs     r5, CPSR        @save the Status Flags
            stmfd   sp!, {r5}
            mov     r5, arrs_size
            mov     r6, #0
loop1:      cmp     r6, r5
            ldrlt   r7, [r4, r6, lsl #2]
            strlt   r7, [r0, r6, lsl #2]
            addlt   r6, r6, #1
            blt     loop1

            ldmfd   sp!, {r5}    @ restore the registers 
            msr     CPSR_f, r5   @ restore the status flags
            ldmfd   sp!, {r5-r7} @ restore the non-volatile registers
            ldmfd   sp!, {lr}    @ restore the Link Register (LR)
            mov     pc, lr       @ return from the function
