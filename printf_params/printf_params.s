@--------1---------2---------3---------4---------5---------6---------7---------8
@  The assembly version of the printf with hex a 32bit value
@  
@  # include <stdio.h>
@  static char str[] = "value 0x%08x\n";
@  unsigned int	val1 = 0xffeeddcc;
@  int main() {
@	 printf(str, val1);
@	 return 0;	
@  }
@
@

			.data
str:		.string		"value 0x%08x"		@ printf fmt string
val:		.word		0xffeeddcc			@ the value supposed to be printed

			.text
			.global		main

main:		mov		r0, #0
			stmfd	sp!, {lr}		@push return address on the strack
			ldr		r3, =val
			ldr		r1, [r3]
			ldr		r0, =str
			bl		printf
			mov		r0, #0
			ldmfd	sp!, {lr}
			mov		pc, lr
			