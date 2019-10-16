<a name="table-of-contents"></a>
#### Table of Contents ####
1. [arm objdump](#arm_objdump)
1.1. [Dump the Sections](#dump_the_sections)
1.2. [Dump the Symbol Table](#dump_the_symbol_table)
2. [arm linker ](#arm_linker)
[2.1. Generic](#arm_linker_generic)
[2.2. About Linker Scripts](#arm_linker_about_linker_scripts)
[2.3. Linker Script Concepts](arm_linker_script_concepts)


<a name="arm_objdump"></a>
####1. arm objdump ####

The **arm-none-eabi-objdump** tool displays information from one or more object files. The parameters of the tool control what type of information is displayed by the tool.

<a name="dump_the_sections"></a>
##### 1.1. Dump the sections #####

```
$ arm-none-eabi-objdump -h file2.o 

file2.o:     file format elf32-littlearm
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000028  00000000  00000000  00000034  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         00000048  00000000  00000000  0000005c  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000000  00000000  00000000  000000a4  2**0
                  ALLOC
  3 .ARM.attributes 00000012  00000000  00000000  000000a4  2**0
                  CONTENTS, READONLY
```
And the sections dump for en e executable:
```
$ arm-none-eabi-objdump -h file2

file2:     file format elf32-littlearm
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000034  00008000  00008000  00008000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         0000006c  00018034  00018034  00008034  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  2 .ARM.attributes 00000012  00000000  00000000  000080a0  2**0
                  CONTENTS, READONLY
```
Also when the information should refer only to a specific section, the following comand could be used:

```
$ arm-none-eabi-objdump -h -j .data file2.o 
file2.o:     file format elf32-littlearm

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  1 .data         00000048  00000000  00000000  0000005c  2**0
                  CONTENTS, ALLOC, LOAD, DATA
```

[[toc]](#table-of-contents)

<a name="dump_the_symbol_table"></a>
##### 1.2. Dump the symbol table #####

To dump the symbol table use the **-t** ot **--syms** parameters. There are two formats of the output depending on the file beeing dumped. The most common output format, usually seen with ELF based files looks like:

```arm
$arm-none-eabi-objdump --syms  file2

file2:     file format elf32-littlearm

SYMBOL TABLE:
00008000 l    d  .text	00000000 .text
00018028 l    d  .data	00000000 .data
00000000 l    d  .ARM.attributes	00000000 .ARM.attributes
00000000 l    df *ABS*	00000000 file2.o
00018028 l       .data	00000000 array2
00018048 l       .data	00000000 array2_size
0000800c l       .text	00000000 ret
0001804c l       .data	00000000 array22
0001806c l       .data	00000000 array22_size
00008020 l       .text	00000000 ret22
00008014 g       .text	00000000 func22
00018070 g       .data	00000000 _bss_end__
00018070 g       .data	00000000 __bss_start__
00018070 g       .data	00000000 __bss_end__
00000000         *UND*	00000000 _start
00018070 g       .data	00000000 __bss_start
00008000 g       .text	00000000 func2
00018070 g       .data	00000000 __end__
00018070 g       .data	00000000 _edata
00018070 g       .data	00000000 _end
00080000 g       .data	00000000 _stack
00018028 g       .data	00000000 __data_start
```
The  columns/fields have the following meaning:
+ First Column/Field is a 32bit hex value which represents the **symbol's  value** but also is refered to it's **address**. 

+ Second Column/Field is a set of characters and spaces indicating the flag bits which are set to the symbol divided in  7 groups:
    +  scope of the symbol
        + **l** - local
        + **g** - global
        + **u** - unique global
        + **a** - neither in local or global space (symbol used for debugging)
        + **!** - both global and local (most probably a bug in the code)
    + **w** - The symbol is **week**, ortherwise **strong** in which case is just a space
    + **C** - The symbol is a **Constructor**, otherwise a regular symbol in which case its just a space.
    + **W** - A **Warning**, otherwise a space for normal symbol.
    + **I|i** - Is a indirect reference to another symbol **I**. A function which has to be evaluated during reloc processing  **i**, or a normal symbol in which case is a space.
    + **d|D** - the symbol is a debugging symbol **d**, or a dynamic symobol **D** or a normal symbol (a space).
    + **F|f|O** - The symbol os the name of a function **F**, or is a file **f** or an object **O** or just a normal symbol - space.   
+ Third Column is:
    + the section with which the symbol is associated: **.data**, **.text**, **.bss**, ... 
    + or **\*ABS\*** if the section is absolute, for instance if its not connected to any other section.
    + or **\*UND\*** if the section is referd in the file beeing dumped but not defined there.
+ The 4th Column is a number which for common symbols is the alignment and for other symbols is the size. 
+ The last column is the **Name of the Symbol**.

[[toc]](#table-of-contents)


<a name="arm_linker"></a>
####2. arm linker ####

<a name="arm_linker_generic"></a>
##### 2.1. Generic #####

This document is based on:  [GNU Linker from STMicroelectronics](https://www.st.com/content/ccc/resource/technical/document/user_manual/group1/09/b1/3b/15/39/41/44/08/UserManual_GNU_Linker/files/UserManual_GNUCC_Linker.pdf/jcr:content/translations/en.UserManual_GNUCC_Linker.pdf) User Manual.

**ld**  combines a number of objects and archive files, relocates their data and ties up symbol references. Usually is the last step in the compiling a program.
**ld** accepts Linker Command Language files (**linker scripts**), to provide explicit and total control over the linking process. It controls the following resources:
+ input files
+ file formats
+ output file layout
+ addresses of sections
+ placement of common blocks

[[toc]](#table-of-contents)

<a name="arm_linker_about_linker_scripts"></a>
##### 2.2. About Linker Scripts #####

Every link process is controled by a **linker script**.  Even if the **linker script** is not mentioned in the **ld** command there is the default one. To see the default linkler script file:
```
$ arm-none-eabi-ld --verbose 
Lucians-MacBook-Air:ld-scrips lucianhanga$ arm-none-eabi-ld --verbose
GNU ld (GNU Tools for Arm Embedded Processors 8-2019-q3-update) 2.32.0.20190703
  Supported emulations:
   armelf
using internal linker script:
==================================================
/* Script for -z combreloc: combine and sort reloc sections */
/* Copyright (C) 2014-2019 Free Software Foundation, Inc.
   Copying and distribution of this script, with or without modification,
   are permitted in any medium without royalty provided the copyright
   notice and this notice are preserved.  */
...
```
The main purpose of the **linker script** is to describe how the **sections** in the input files should be mapped into the output file, and to control the **memory layout** of the output file.

[[toc]](#table-of-contents)

<a name="arm_linker_script_concepts"></a>
##### 2.3. Linker Script Concepts #####

The linker combines input files into a single output file. The output file and the input files are in a special data format called **object** file format. Each **object** file has besides other things a list of  **sections**.v The input object files have  **input sections** and the output object has a list of **output sections**. 
Each **section** has a name, size and most of the sections have an associated a bock of data called **section contents**. If the section is marked as **loadable** it will be loaded into memory when the output file is run. A section with no contents may be **allocatable** meaning that memory should be allocated but nothing should be loaded there. If a section is not loadable nor allocatable may contain debugging information.
Every **loadable** or **allocatable** section has two addresses:
+ **VMA** (Virtual Memmory Address) - This address is the address the section will have when the file is run.
+ **LMA** (Load Memory Address) - This is the address whre the section is going to be loaded.

Most of the time these adresses are identical. A tipical example when they are different is then the data section is loaded into ROM, and then copied into RAM when the program starts. In this scenario the ROM address is the LMA and the RAM address is the VMA.

To see the section use the following command:
```
$ arm-none-eabi-objdump -h file2.o 

file2.o:     file format elf32-littlearm
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000028  00000000  00000000  00000034  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         00000048  00000000  00000000  0000005c  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000000  00000000  00000000  000000a4  2**0
                  ALLOC
  3 .ARM.attributes 00000012  00000000  00000000  000000a4  2**0
                  CONTENTS, READONLY
```
And the sections dump for en e executable:
```
$ arm-none-eabi-objdump -h file2

file2:     file format elf32-littlearm
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000034  00008000  00008000  00008000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         0000006c  00018034  00018034  00008034  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  2 .ARM.attributes 00000012  00000000  00000000  000080a0  2**0
                  CONTENTS, READONLY
```


[[toc]](#table-of-contents)
