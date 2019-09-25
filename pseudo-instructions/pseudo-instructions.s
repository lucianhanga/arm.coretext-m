@--------1---------2---------3---------4---------5---------6---------7---------8
@  
@ 


		.data
var1:	.word	0x11, 0x22, 0x33
mydata:	.word	0xff
		.text	
		.global		main
main:	stmfd		sp!, {lr}

@ load a in mediate which is small enough to be used by mov instruction
@ if not the compiler will create in the 'literal pool' an entry and it
@ will use a ldr command using the Imediate Offset addressing with
@ 'Rn' beeing 'pc' register.
@ if the imediate is an 8 bit value or value which is computed out of a 
@ 8-bit value, shifted, rotated and/or complemented (0/1 complement)
@ the complier will transform it into a 'mov' instruction, otherwise 
@ will use the 'ldr' and the 'literal pool'.

		ldr		r1, =0b11111111		@ mov	r1, #255
		ldr		r1, =0b111111111	@ ldr	r1, [pc, #24] ; 28
		ldr		r1, =0b111111110000 @ mov	r1, #16320
		ldr		r1, =mydata			@ ldr	r1, [pc, #20] ; 2c

@ the 'adr' instruction must have as argument a address from the same
@ segment in this case '.code and the instruction will be translated in
@ and add/sub relative to the 'pc' register. 
@ the 'adr' is more efficient then 'ldr' because does not require a load
@ from memory.
		adr		r2, a_mydata		@ add	r2, pc, #8

ret:	mov		r0, #0				@ prepare the return code
		ldmfd	sp!, {lr}			@ recover the lr from stack
		mov		pc, lr				@ return from main			 

@ literal pool
a_mydata:	.word	mydata

