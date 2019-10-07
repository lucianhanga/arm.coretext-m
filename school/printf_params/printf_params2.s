@--------1---------2---------3---------4---------5---------6---------7---------8
@  The assembly version of the printf with more 
@
@
@  


		.data
fmt:	.ascii	"0x%08x 0x%08x 0x%08x 0x%08x " 	@ continue string on the next
		.asciz	"0x%08x 0x%08x 0x%08x 0x%08x\n"	@ line and endit with zero

val1:	.word	0x11111111	@ the values supposed to be printed
val2:	.word	0x22222222	@ the values supposed to be printed
val3:	.word	0x33333333	@ the values supposed to be printed
val4:	.word	0x44444444	@ the values supposed to be printed
val5:	.word	0x55555555	@ the values supposed to be printed
val6:	.word	0x66666666	@ the values supposed to be printed
val7:	.word	0x77777777	@ the values supposed to be printed
val8:	.word	0x88888888	@ the values supposed to be printed

		.text
		.global		main

main:	mov		r0, #0
		stmfd	sp!, {lr}		@ push return address on the strack

@ printf function accepts only the first 4 parameters in registers and the
@ rest ar pushed on the stack as follows:
@ 		r0 <- fmt string address
@ 		r1 <- param1
@		r2 <- param2
@		r2 <- param3
@		[sp]     <- param4
@		[sp, #4] <- param5
@       [sp, #8] <- param6
@       ...
@
@ NOTICE: when stack is allocated for parameters passing is allocated always 
@ in multiple of 2 words. I noticed this decompiling a C printf program.
@
		add 	fp, sp, #4		@ fp points to the element after sp (down)
		sub		sp, sp, #24		@ allocate 6 words on the stack
		@ prepare parameters
		ldr		r0, =fmt		@ r0 <- fmt string address
		ldr		r4, =val1
		ldr		r1, [r4]		@ r1 <- param2
		ldr		r4, =val2
		ldr		r2, [r4]		@ r2 <- param3
		ldr		r4, =val3
		ldr		r3, [r4]		@ r3 <- param4
		ldr		r4, =val4
		ldr		r5, [r4]
		str		r5, [sp]		@ param5
		ldr		r4, =val5
		ldr		r5, [r4]
		str		r5, [sp, #4]	@ param6
		ldr		r4, =val6
		ldr		r5, [r4]
		str		r5, [sp, #8]	@ param7
		ldr		r4, =val7
		ldr		r5, [r4]
		str		r5, [sp, #12]	@ param8
		ldr		r4, =val8
		ldr		r5, [r4]
		str		r5, [sp, #16]	@ param9
		@ call the printf
		bl		printf
		sub		sp,	fp, #4		@ recover the sp from the fp (r11)

		mov		r0, #0
		ldmfd	sp!, {pc}		@ pop the return address from the stack
			