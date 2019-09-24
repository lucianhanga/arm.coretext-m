#### GDB & ARM Toolkits ####

##### GCC Toolkit Tips ######

disassembly the binary 
```$ objdump -D  printf_params.o```

get the data section from the ELF file and display it as hexdump+ascii
`$ objdump -sj  .data  printf_params.o`
`$ readelf -x .data printf_params.o`


generate the assembly code 
`$ gcc -S -fverbose-asm -O0 -o printf_params.c.assembly printf_params.c`

##### GDB Basics  #####

######  eXamine: x ######

_Syntax_:
`x /FMT ADDRESS`

_Syntax **FMT**_:
`<repeat count><format><size>`

_Samples_:

`x/20wx 0x00021024`
Show 20 words (32bit) from the address and display them as hex values.

`x/8db 0x00021024`
Show 10 bytes from the address and display them as decimal values.

##### _GEF_ - GDB Enhanced Features #####

`gef> hexdump byte 0x21000 100`
Ahow memory hexdump style from addr 100 bytes

`gef> context`
get back/update the summary

`gef> memory watch 0x00021000 0x40 byte`
Show the memory from addrd into context 

`gef> memory unwatch 0x00021000`
Remove memory from addr into context

