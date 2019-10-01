@--------1---------2---------3---------4---------5---------6---------7---------8

        .data
fmt1:   .string     "r4 bigger (r4=%d r5=%d)\n"
fmt2:   .string     "r5 bigger (r4=%d r5=%d)\n"

        .global     main
        .text
        
main:	stmfd   sp!, {lr}

br0:    mov     r4, #100        @ since r4 is bigger then r5 the sub does not 
        mov     r5, #99         @ use borrow which means that the CARRY flag is
        subs    r3, r4, r5      @ set. Remember: REVERSE CARRY!

br1:    mov     r4, #100        @ r4 is smaller then r5 the sub required a
        mov     r5, #99         @ borrow which means that the CARRY flag is
        subs    r3, r5, r4      @ cleared. Remember: REVERSE CARRY!
                                @ and also because the result is negative the
                                @ N Flag is set too.

br2:    mov     r4, #-9         @ r5-r4=-10--9=-1 negative so the N-Flag=1 and
        mov     r5, #-10        @ it does not need borrow which means C-Flag=0
        subs    r3, r5, r4      @
        
br3:    subs    r3, r4, r5      @ r5-r4=-9--10=1 positive so the N-Flag=0 and 
                                @ the C-Flag=1 because borrow happened.

br4:    mov     r4, #0x0F
        mov     r5, #0x0E
        cmp     r4, r5          @ compare r4 and r5 and set the CPSR
        bgt     r4_bigger
        ldr     r0, =fmt2
        mov     r1, r4
        mov     r2, r5
        bl      printf
        b       ret
r4_bigger:
        ldr     r0, =fmt1
        mov     r1, r4
        mov     r2, r5
        bl      printf

ret:    mov     r0, #0          @ prepare the return code
        ldmfd   sp!, {lr}       @ recover the lr from stack
        mov     pc, lr          @ return from main			 

@ literal pool
