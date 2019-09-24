@--------1---------2---------3---------4---------5---------6---------7---------8
@  
@ 


		.data

array1:	.word	0x00, 0x00, 0x00
		.word	0x00, 0x00, 0x00
fmt1:	.string "%08x %08x %08x\n"

		.balign	4, 0x00

array2:	.word		0x12345678, 0x87654321, 0xfedcba98
		.word		0x55443322, 0x11223344, 0xffeeccdd

fmt2:	.string		"%08x %08x %08x\n"


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
		ldr			r0, =fmt1
		ldr			r5,	=array1
		ldr			r1, [r5], #4
		ldr			r2, [r5], #4
		ldr			r3, [r5], #4
		bl			printf
		ldr			r0, =fmt1
		ldr			r5,	=array1
		ldr			r1, [r5], #4
		ldr			r2, [r5], #4
		ldr			r3, [r5], #4
		bl			printf

@ --------------- ldmda sample ----------------





ret:	mov			r0, #0					@ prepare the return code
		ldmfd		sp!, {lr}				@ recover the lr from stack
		mov			pc, lr					@ return from main			 

