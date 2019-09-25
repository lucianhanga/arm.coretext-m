<a name="table-of-contents"></a>
#### Table of Contents ####

1. [GDB & ARM Toolkits](#gdb-arm-toolkits)
1.1. [GCC Toolkit Tips](#gcc-toolkit-tips)
1.2. [GDB Basics](#gdb-basics)
1.3. [_GEF_ - GDB Enhanced Features](#gef-gdb)

<a name="gdb-arm-toolkits"></a>
#### 1. GDB & ARM Toolkits ####

<a name="gcc-toolkit-tips"></a>
##### 1.1. GCC Toolkit Tips ######

disassembly the binary 
```$ objdump -D  printf_params.o```

get the data section from the ELF file and display it as hexdump+ascii
`$ objdump -sj  .data  printf_params.o`
`$ readelf -x .data printf_params.o`

generate the assembly code 
`$ gcc -S -fverbose-asm -O0 -o printf_params.c.assembly printf_params.c`

[[toc]](#table-of-contents)


<a name="gdb-basics"></a>
##### 1.2. GDB Basics #####

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

[[toc]](#table-of-contents)

<a name="gef-gdb"></a>
##### 1.3. _GEF_ - GDB Enhanced Features #####

`gef> hexdump byte 0x21000 100`
Ahow memory hexdump style from addr 100 bytes

`gef> context`
get back/update the summary

`gef> memory watch 0x00021000 0x40 byte`
Show the memory from addrd into context 

`gef> memory unwatch 0x00021000`
Remove memory from addr into context

[[toc]](#table-of-contents)
