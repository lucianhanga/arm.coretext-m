
                .data 1
array2:         .word   0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77 ,0x88
array2_size:    .word   (. - array2) << 2

            .text 1
            .global func2

func2:      stmfd   sp!, {lr}
            mov     r0, #1      @ just some code ...
            mov     r1, r0
ret:        ldmfd   sp!, {lr}
            mov     pc, lr


                .data 22
array22:        .word   0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77 ,0x88
array22_size:   .word   (. - array22) << 2


            .text 22
            .global func22

func22:     stmfd   sp!, {lr}
            mov     r0, #1      @ just some code ...
            mov     r1, r0
ret22:      ldmfd   sp!, {lr}
            mov     pc, lr
