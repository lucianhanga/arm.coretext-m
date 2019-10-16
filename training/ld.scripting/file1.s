
            .data
array1:     .word   0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77 ,0x88
array1_size:.word   (. - array1) << 2

            .bss
var1:       .space  4

            .text 
            .global func1
            .global main
main:       stmfd   sp!, {lr}
            ldmfd   sp!, {lr}
            mov     r0, #0
            mov     pc, lr

func1:      stmfd   sp!, {lr}
ret:        ldmfd   sp!, {lr}
            mov     r0, #0
            mov     pc, lr

func2:      stmfd   sp!, {lr}
ret2:       ldmfd   sp!, {lr}
            mov     r0, #0
            mov     pc, lr

@ literal  pool
cvar1:      .word   0xFF
