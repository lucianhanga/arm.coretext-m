@--------1---------2---------3---------4---------5---------6---------7---------8
@  
@ 


			.data

array1:		.word	0x00, 0x00, 0x00
			.word	0x00, 0x00, 0x00
fmt1:		.string "%08x %08x %08x\n"

			.balign	4, 0x00
array2:		.word		0x12345678, 0x87654321, 0xfedcba98
			.word		0x55443322, 0x11223344, 0xffeeccdd

fmt2:		.string		"%08x %08x %08x\n"

			.balign	4, 0x00
array_fwd:	.word	0x11111111, 0x22222222, 0x33333333, 0x44444444
			.word	0x55555555, 0x66666666, 0x77777777, 0x88888888
			.equ 	array_fwd_bsize,  . - array_fwd
array_rew:	.space	array_fwd_bsize,  0x00
fmt3:		.string "w: %08x  %08x  %08x  %08x  %08x  %08x  %08x  %08x\n"

		.text
		.global		main
main:	nop
		stmfd		sp!, {lr}

@ --------------- ldmia sample -------------

		ldr			r4,  =array2	@ load the addr. of the array2 
		ldmia		r4!, {r1-r3} 	@ multiple load the r1, r2, r3, with
									@ increment after and Rd update
display1:							@ display the values
		push		{r4}			@ preserve the r4;  might be overriten
		ldr			r0, =fmt2
					bl	printf
		pop			{r4}			@ recover the r4
		ldmia		r4,	{r1-r3}		@ multiple load the r1, r2, r3, with
									@ increment after
display2:							@ display the values
		ldr			r0, =fmt2
					bl	printf

@ --------------- stmia sample -------------

		@  load the registers with the bytes which need to be stored into the
		@  array.
		mov			r0, #0x11
		mov			r1, #0x22
		mov			r2, #0x33

		@ <op><variant> Rd{!}, <register_list>
		@ <op> ldr/str
		ldr			r4, =array1			@ load the array address
		stmia		r4!, {r0, r1, r2}	@ store at the address from r4
										@ and 'Increment After' the address
										@ with 3*4 bytes and store it back to r4
		stmia		r4, {r0, r1, r2}	@ continue storing the values of the 3
										@ registers further in the array
										@ but this time don't update the r4
		@ print the array
display3:
		ldr		r0, =fmt1
		ldr		r5,	=array1
		ldr		r1, [r5], #4
		ldr		r2, [r5], #4
		ldr		r3, [r5], #4
		bl		printf
		ldr		r0, =fmt1
		ldr		r5,	=array1
		ldr		r1, [r5], #4
		ldr		r2, [r5], #4
		ldr		r3, [r5], #4
		bl		printf

@ --------------- ldmda & stmda sample ----------------
@ copy two array starting from the end
label_ldmda:
		ldr		r0, =array_fwd				@ load in r0 the address of the
		add		r0, r0, #array_fwd_bsize	@ last element of the array_fwd
		sub		r0, r0, #4					@	 
		ldr		r1,	=array_rew				@ load in r1 the address of the
		add		r1, r1, #array_fwd_bsize	@ last element of the array_rew
		sub		r1, r1, #4					@
		@  make the transfer of data between the arrays
		ldmda	r0!, {r2-r5}		@ transfer 4 words arrays
		stmda	r1!, {r2-r5}
		ldmda	r0!, {r2-r5}		@ transfer another 4 words arrays
		stmda	r1!, {r2-r5}
display4:
		add		fp, sp, #4					@ prepare the fp and sp for param
		sub		sp, sp, #24					@ passing for printf
		ldr		r0, =fmt3
		ldr		r4, =array_rew
		ldmia	r4!, {r1-r3}				@ load the first 3 items on regs
		ldr		r5, [r4]
		str		r5, [sp]
		ldr		r5, [r4, #4]!
		str		r5, [sp, #4]
		ldr		r5, [r4, #4]!
		str		r5, [sp, #8]
		ldr		r5, [r4, #4]!
		str		r5, [sp, #12]
		ldr		r5, [r4, #4]!
		str		r5, [sp, #16]
		bl		printf
		sub		sp, fp, #4

ret:	mov		r0, #0					@ prepare the return code
		ldmfd	sp!, {lr}				@ recover the lr from stack
		mov		pc, lr					@ return from main			 

