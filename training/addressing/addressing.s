@--------1---------2---------3---------4---------5---------6---------7---------8
@  
@ 
@
@


		.data
var1:	.word		0x12345678
		.space		4					@ allocate 4 bytes
var2:	.word		0xffeeddcc
		.skip		4					@ allocate 4 bytes
var3:	.word		0x01, 0x02, 0x03, 0x04
var4:	.byte		0xAA, 0xBB, 0xCC, 0xDD

msg:	.string		"var1: %08x var2: %08x\n"
msg2:	.string		"var2 second word: %08x\n"
msg3:	.string 	"var3: %08x  %08x  %08x\n"
msg4:	.string		"var4: %02x %02x %02x\n"

		.balign		4, 0x00
var5:	.word		0x11111111, 0x22222222, 0x33333333, 0x44444444
var5_d:	.space 		4*4, 0x00
msg5:	.string		"var5 before: %08x %08x\n"
msg5_d:	.string		"var5 after:  %08x %08x\n"

		.balign		4, 0x00
var6:	.word		0xaaaaaaaa, 0xbbbbbbbb, 0xcccccccc, 0xdddddddd
var6_d:	.space 		4*4, 0x00
msg6:	.string		"var6 before: %08x %08x\n"
msg6_d:	.string		"var6 after:  %08x %08x\n"

		.balign		4, 0x00
var7:	.word		0x11111111, 0x22222222, 0x33333333, 0x44444444
var7_d:	.space		4*4, 0x00	@ allocate 4 words and fill with 0 
msg7:	.string		"var7 destination: %08x %08x\n"

msg71:	.string		"var1: %08x; var2: %08x; var3: %08x\n"

		.text
		.global		main
main:	nop
		stmfd		sp!, {lr}

@ copy the value from var1 to var2 using the "REGISTER IMEDIATE"
		@ print the var1 and var2
		ldr			r0, =msg			@ load the first param for printf
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
		ldr			r0, =msg2			@ load the first param for printf
		ldr			r3, =var2
		ldr			r1, [r3]			@ the second paramter
		bl			printf				@ call the printf function

@ Addressing Mode: "SCALED REGISTER OFFSET"
		ldr			r0, =msg3
		ldr			r7, =var3
		mov			r6, #0					@ the index
		ldr			r1, [r7, r6, lsl #2]
		mov 		r6, #1
		ldr			r2, [r7, r6, lsl #2]
		mov 		r6, #2
		ldr			r3, [r7, r6, lsl #2]
		bl			printf					@ call the printf function

@ Addressing Mode: "REGISTER OFFSET"
		ldr			r0, =msg4
		ldr			r7, =var4				@ load the address of the matrix
		mov			r6, #0					@ index in the matrix
		ldrb		r1, [r7, r6]
		mov			r6, #1
		ldrb		r2, [r7, r6]
		mov			r6, #2
		ldrb		r3, [r7, r6]
		bl			printf

@ Addressing Mode: "IMEDIATE PRE-INDEXED"
		@ copy 4 words from the source to destination
		ldr			r0,	=var5
		ldr			r1, =var5_d
		ldr			r2, [r0]!				@ load the first value from source
		str			r2, [r1]!				@ store it at destination
		ldr			r2,	[r0, #1*4]!			@ load the next word - 4 bytes (2nd)
		str			r2,	[r1, #1*4]!			@ store the next 
		ldr			r2,	[r0, #1*4]!			@ load the next  (3rd)
		str			r2,	[r1, #1*4]!			@ load the next 
		ldr			r2,	[r0, #1*4]!			@ load the next  (4th)
		str			r2,	[r1, #1*4]!			@ load the next 
		@ print the first and the 4th word  from destination
		ldr			r0, =msg5				@ the fmt for printf
		ldr			r8, =var5_d
		ldr			r1, [r8]				@ first word from val5_d
		ldr			r2, [r8, #3*4]			@ last word from val5_d
		bl			printf

@ Addressing mode: "SCALED REGISTER PRE-INDEXED"
		ldr			r0, =msg71
		ldr			r5, =var7
		mov			r6, #1
		ldr			r1, [r5, r6, lsl #2]!	@ second item from the array
		ldr			r2, [r5, r6, lsl #2]!	@ third item from the array
		ldr			r3, [r5, r6, lsl #2]!	@ 4th item from the array
		bl			printf

@ Addressing mode: "IMEDIATE POST-INDEXED"
		ldr			r0,	=var6
		ldr			r1, =var6_d
		ldr			r2, [r0], #1*4			@ load the first value from source
		str			r2, [r1], #1*4			@ store it at destination
		ldr			r2, [r0], #1*4			@ load the first value from source
		str			r2, [r1], #1*4			@ store it at destination
		ldr			r2, [r0], #1*4			@ load the first value from source
		str			r2, [r1], #1*4			@ store it at destination
		ldr			r2, [r0], #1*4			@ load the first value from source
		str			r2, [r1], #1*4			@ store it at destination
		@ print the first and the 4th word  from destination
		ldr			r0, =msg6				@ the fmt for printf
		ldr			r8, =var6_d
		ldr			r1, [r8]				@ first word from val5_d
		ldr			r2, [r8, #3*4]			@ last word from val5_d
		bl			printf

@ Addressing mode: "SCALED REGISTER POST-INDEXED"
		ldr			r0,	=var7
		ldr			r1, =var7_d
		mov			r2, #1
		ldr			r5, [r0], r2, lsl #2	@ load the value from r0 and then
											@   update r0 <- r0 + r2<<2
		str			r5, [r1], r2, lsl #2	@ store the value to r1 and then 
											@   update r1 <- r1 + r2<2
		ldr			r5, [r0], r2, lsl #2	@  
		str			r5, [r1], r2, lsl #2	@ since there are haldwords handled
		ldr			r5, [r0], r2, lsl #2	@  shift with 1 (multiply by 2)
		str			r5, [r1], r2, lsl #2
		ldr			r5, [r0], r2, lsl #2
		str			r5, [r1], r2, lsl #2
		@ print the first and last halfword
		ldr			r0, =msg7				@ the fmt for printf
		ldr			r8, =var7_d
		ldr			r1, [r8]				@ first word from val5_d
		ldr			r2, [r8, #3*4]			@ last word from val5_d
		bl			printf

ret:	mov			r0, #0					@ prepare the return code
		ldmfd		sp!, {lr}				@ recover the lr from stack
		mov			pc, lr					@ return from main			 

