@--------1---------2---------3---------4---------5---------6---------7---------8
@  
@ 
@
@


			.data
var1:		.word		0x12345678
			.space		4					@ allocate 4 bytes
var2:		.word		0xffeeddcc
			.skip		4					@ allocate 4 bytes
var3:		.word		0x01, 0x02, 0x03, 0x04

msg:		.string		"var1: %08x var2: %08x\n"
msg2:		.string		"var2 second word: %08x\n"
msg3:		.string 	"var3: %08x  %08x  %08x\n"

			.text
			.global		main
main:		nop
			stmfd		sp!, {lr}

@ copy the value from var1 to var2 using the "REGISTER IMEDIATE"
			@ print the var1 and var2
			ldr			r0, =msg			@ load the first parameter for printf
			ldr			r3, =var1		
			ldr			r1, [r3]			@ the second paramter
			ldr			r3, =var2
			ldr			r2, [r3]			@ the third
			bl			printf				@ call the printf function
			@copy the var1 value to var2
			ldr			r0, =var1
			ldr			r1, =var2
			ldr			r3, [r0]
			str			r3, [r1]
			@ print the var1 and var2
			ldr			r0, =msg			@ load the first parameter for printf
			ldr			r3, =var1		
			ldr			r1, [r3]			@ the second paramter
			ldr			r3, =var2
			ldr			r2, [r3]			@ the third
			bl			printf				@ call the printf function

@ copy the var1 to the second word from var2 using the "IMEDITE OFFSET"
			ldr			r0, =var1
			ldr			r1, =var2
			ldr			r3, [r0]
			str 		r3, [r1, #4]
			@ print the value from the second word of var2
			ldr			r0, =msg2			@ load the first parameter for printf
			ldr			r3, =var2
			ldr			r1, [r3]			@ the second paramter
			bl			printf				@ call the printf function


@ "SCALE REGISTER OFFSET"
			ldr			r0, =msg3
			ldr			r7, =var3
			mov			r6, #0					@ the index
			ldr			r1, [r7, r6, lsl #2]
			mov 		r6, #1
			ldr			r2, [r7, r6, lsl #2]
			mov 		r6, #2
			ldr			r3, [r7, r6, lsl #2]
			bl			printf					@ call the printf function

			mov			r0, #0
ret:		ldmfd		sp!, {pc}
