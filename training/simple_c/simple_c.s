@--------1---------2---------3---------4---------5---------6---------7---------8
@  The C "Hello World" written in ARM ASM 
@  
@  # include <stdio.h>
@  static char str[] = "Hello World!!!\n";
@  int main() {
@	 printf(str);
@	 return 0;	
@  }
@
@

			.data
str:		.string		"Hello World\n"		@define a null-terminated string

			.text
			.global		main

main:		nop
			stmfd	sp!, {lr}		@push return address on the strack
			ldr		r0, =str
			bl		printf
			mov		r0, #0
			ldmfd	sp!, {lr}
			mov		pc, lr


			