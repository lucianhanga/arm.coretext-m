@--------1---------2---------3---------4---------5---------6---------7---------8
@       
@  SubVector
@ 
@  Search a subvector within a vector.
@ 
@ 
@ 

            .text
            .global lh_vector_subvector
@ parameters
@   r0: address of the vector (pointer to an unsigned 32bit value)
@   r1: size of the vector
@   r2: address of the subvector (pointer to an unsigned 32bit value)
@   r3: size of the subvector
lh_vector_subvector:
            stmfd   sp!, {lr}       @ store the Link Register
            stmfd   sp!, {r4-r7}    @ store the non-volatile registers

            @ function parameters
p_arr       .req    r0
arr_size    .req    r1
p_sarr      .req    r2
sarr_size   .req    r3
            @ local variables



ret:        ldmfd   sp!, {r4-r7}    @ restore the nonvolatile registers
            ldmfd   sp!, {lr}       @ restore the Link Register
            mov     pc, lr          @ return to the caller
