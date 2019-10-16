<a name="table-of-contents"></a>
#### Table of Contents ####
1. [arm objdump](#arm_objdump)
1.1. [Dump the Sections](#dump_the_sections)
1.2. [Dump the Symbol Table](#dump_the_symbol_table)
2. [arm linker ](#arm_linker)
[2.1. Generic](#arm_linker_generic)
[2.2. About Linker Scripts](#arm_linker_about_linker_scripts)
[2.3. Linker Script Concepts](#arm_linker_script_concepts)
[2.4. Linker Script Format](#arm_linker_script_format)


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

To see the section use the following command:```$ arm-none-eabi-objdump -h```. Refer to the  ``objdump`` section in this document.

[[toc]](#table-of-contents)

<a name="arm_linker_script_format"></a>
##### 2.4. Linker Script Format #####

The simplest possible linker script has just the **SECTIONS** command and its used to describe the memory layout of  the output file.

To be able to show how t he **SECTIONS** command is working the following example will be taken:

```
           .data
array1:     .word   0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77 ,0x88
array1_size:.word   (. - array1) << 2

            .bss
var1:       .space  4

            .text 
            .global func1
            .global main
main:       stmfd   sp!, {lr}
            ldmfd   sp!, {lr}
            mov     r0, #0
            mov     pc, lr

func1:      stmfd   sp!, {lr}
ret:        ldmfd   sp!, {lr}
            mov     r0, #0
            mov     pc, lr

func2:      stmfd   sp!, {lr}
ret2:       ldmfd   sp!, {lr}
            mov     r0, #0
            mov     pc, lr

@ literal  pool
cvar1:      .word   0xFF
```
After the compilation using the default linker script:
```
$ arm-none-eabi-as -o file1.o file1.s
$ arm-none-eabi-ld -o file1 file1.o
$ arm-none-eabi-objdump -h file1 
file1:     file format elf32-littlearm
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000034  00008000  00008000  00008000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         00000024  00018034  00018034  00008034  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000004  00018058  00018058  00008058  2**0
                  ALLOC
  3 .ARM.attributes 00000012  00000000  00000000  00008058  2**0
                  CONTENTS, READONLY
```

If the **text** should be loaded at address `0x00100000` and the **data** should start at address `0x80000000` the following script should be used:
```
    SECTIONS  
    {
        . = 0x00100000;
        .text : { *(.text) }
        . = 0x80000000;
        .data : { *(.data) }
        .bss : { *(.bss ) }
    }
```

```
$ arm-none-eabi-ld -T file1.ld -o file1 file1.o
$ arm-none-eabi-objdump -t file1 

file1:     file format elf32-littlearm

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000034  00100000  00100000  00010000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         00000024  80000000  80000000  00020000  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000004  80000024  80000024  00020024  2**0
                  ALLOC
  3 .ARM.attributes 00000012  00000000  00000000  00020024  2**0
                  CONTENTS, READONLY
```

Below can be seen the difference after linking was executed using the **`-T file1.ld`** option. Check out the values of the **VMA** and **LMA**.

```
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000034  00008000  00008000  00008000  2**2
  0 .text         00000034  00100000  00100000  00010000  2**2

Idx Name          Size      VMA       LMA       File off  Algn
  1 .data         00000024  00018034  00018034  00008034  2**0
  1 .data         00000024  80000000  80000000  00020000  2**0
 
Idx Name          Size      VMA       LMA       File off  Algn
  2 .bss          00000004  00018058  00018058  00008058  2**0
  2 .bss          00000004  80000024  80000024  00020024  2**0
```

The first line inside the **SECTIONS**:  "`. = 0x10000;`" uses a special symbol **.** (dot) which is the **location counter**. If there is no address specified for an output section. The adress is set from the current location counter value. The location counter is then incremented by the size of hte output section. At the start of the  **SECTIONS** command the **location counter** is set to `0`. 

The next line: `.text : { *(.text) }` defines the output section `.text`. Inside the curly brackets after the output section name are enumerated all the input sections which should be placed into the specified output section. The expression `*(.text)` means all `.text` input sections in all input files.

Since the location counter is `0x10000` when the output section `.text` is defined, the linker will set the address of the `.text` section in the output file to be `0x10000`.

The remaining lines define the `.data` and `.bss` sections in the output file. The linker will place the `.data` output section at address `0x8000000`. After the linker places the `.data` output section, the value of the location counter will be `0x8000000` plus the size of the `.data` output section. The effect is that the linker will place the `.bss` output section immediately after the `.data` output section in memory.

[[toc]](#table-of-contents)
