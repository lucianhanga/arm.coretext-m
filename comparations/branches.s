@--------1---------2---------3---------4---------5---------6---------7---------8

            .data
a:          .word       11
            .text
            .global     main

main:       stmfd   sp!, {fp}

@ check if a is even or odd 
@
@ if (a & 1)
@   a+=3; 
@ else
@   a+=4;
@ 
            ldr     r0, =a          @ load the a address into r0
            ldr     r1, [r0]        @ load the a value into r1 
            
            tst     r1, #1          @ r1 AND #1 
                                    @ if result is 1 (true) - odd THEN branch
                                    @ if result is 0 (false) - even ELSE branch
            addne   r1, r1, #3      @ in gdb: TAKEN [Reason: !Z]
            addeq   r1, r1, #4      @         NOT taken [Reason: !(Z)]

            str     r1, [r0]        @ store back the value into var. a

end:        mov     r0, #0
            ldmfd   sp!, {pc}
