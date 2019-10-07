<a name="table-of-contents"></a>
#### Table of Contents ####

1. [_ARM_ Addressing Modes](#arm-addressing-modes)
1.1. [Imediate Offset / Register Immediate](#immediate-offset)
1.2. [Scaled Register Offset / Offset Register](#scaled-register-offset)
1.3. [Immediate Pre-Indexed](#immediate-pre-indexed)
1.4. [Scaled Register Pre-Indexed / Register Pre-Indexed](#scaled-register-pre-indexed)
1.5. [Immediate Post-Indexed](#immediate-post-indexed)
1.6. [Scaled Register Post-Indexed / Register Post-Indexed](#scaled-register-post-indexed)
2. [SIMD Single Instruction Multiple Data](#single-instruction-multiple-data)
2.1. [ldmia & ldmfd](#ldmia-ldmfd)
2.2. [stmia & stmea](#stmia-stmea)
2.3. [stmda & stmed](#stmda-stmed)
2.4. [ldmda & ldmfa](#ldmda-ldmfa)
2.5. [the rest ...](#simd-the-rest)
3. [Condition Flags](#condition-flags)
3.1. [Condition Modifiers](#condition-modifiers)
4. [Routines](#routines)
4.1. [Calling SubRoutines](#calling_subroutines)


<a name="arm-addressing-modes"></a>
#### 1. _ARM_ Addressing Modes ####

<a name="immediate-offset"></a>
##### 1.1. Immediate Offset ##### 

_Syntax_:

`[Rn, #±<offset_12>]`

The imediat offset **offset_12** which can be positive or negative will be added to the value of the register **Rn**. The result is an address of the item which will be load/stored. 

If the `#±<offset_12>` is not specified meaning that the addressing would look: `[Rn]` the addressing is called **Register Immediate**.

_Samples_:

```asm
    @ Imediate Offset
    ldr     r0, [r1 + 2]        @ load in r0 the value from address r1+2
    str     r0, [r1 - 2]        @ store the 4 byte value from r0 to
                                @ the address r1-2
    @ Register Imediate
    ldr     r0, [r1]            @ load in r0 the value from address r1
    str     r0, [r1]            @  store the r0 at the address r1
```
[[toc]](#table-of-contents)


<a name="scaled-register-offset"></a>
##### 1.2. Scaled Register Offset #####

_Syntax_:

`[Rn, ±Rm, <shitf_op> #<shift>]`

The value of the **Rm** register is shifted with the **shift** value using the specified **shift_op** and then is added/substracted to the value of the register **Rn**. The result is an address where an item will loaded or stored.

_Samples_:

In the example below assume that the register **r0** is loaded with the address of hte matrix. The matrix contains 4 byte values. The **r1** can be seen as the index for navigating the matrix. Since there are 4 byte values, the index should be multiplied with 4 - or shifted to left with 2: `lsl #2`.

```asm
matrix:     .word   0xA000000A, 0xB000000B, 0xC000000C, 0xD000000D
```

```asm
    ldr     r0, =matrix             @ load the matrix address
    mov     r1, #0                  @ set the index to the first element
    ldr     r2, [r0, r1, lsl #2]    @ load the first element
    mov     r1, #1                  @ set the index to the second elemnt 
    ldr     r3, [r0, r1, lsl #2]    @ second element
    mov     r1, #2                  @ ... and so on ...
    ldr     r4, [r0, r1, lsl #2]
    mov     r1, #3
    ldr     r5, [r0, r1, lsl #2] 
```

If the `<shitf_op> #<shift>` is missing from the command then the mode is called: **Register Offset**:
_Syntax_:
`[Rn, ±Rm]`

_Samples_:

```asm
matrix_byte:    .byte   0x01, 0x02, 0x03, 0x04 
```

```asm
    ldr     r0, =matrix_byte    @ load the matrix address
    mov     r1, #0              @ set the index to the first element
    ldr     r2, [r0, r1]        @ load the first element
    mov     r1, #1              @ set the index to the second elemnt 
    ldr     r3, [r0, r1]        @ second element
    mov     r1, #2              @ ... and so on ...
    ldr     r4, [r0, r1]
    mov     r1, #3
    ldr     r5, [r0, r1] 
```
[[toc]](#table-of-contents)


<a name="immediate-pre-indexed"></a>
##### 1.3. Immediate Pre-Indexed #####

_Syntax_:

`[Rn, #±<offset_12>]!`

The imediat offset **offset_12** which can be positive or negative will be added to the value of the register **Rn**. The result is an address of the item which will be load/stored. After the load/store operation the calculated address will be stored in the **Rn** register. This addressing mode can be used to step through the elements in an array, _updating the pointer of the current array **before** each access._

_Samples_:

The following sample copies the values of the **var5** array into the  **var5_d** and it uses the **Imediate Pre-Indexed** addressing. 

```assembly
var5:	   .word	0x11111111, 0x22222222, 0x33333333, 0x44444444
var5_d:	   .space 	4*4, 0x00
```

```gas
    ldr     r0, =var5
    ldr     r1, =var5_d
    ldr     r2, [r0]            @ load the first value from source
    str     r2, [r1]            @ store it at destination
    ldr     r2, [r0, #1*4]!     @ load the next word - 4 bytes (2nd)
    str     r2, [r1, #1*4]!     @ store the next 
    ldr     r2, [r0, #1*4]!     @ load the next  (3rd)
    str     r2, [r1, #1*4]!     @ load the next 
    ldr     r2, [r0, #1*4]!     @ load the next  (4th)
    str     r2, [r1, #1*4]!     @ load the next 
```
[[toc]](#table-of-contents)


<a name="scaled-register-pre-indexed"></a>
##### 1.4. Scaled Register Pre-Indexed #####

_Syntax_:

`[Rn, ±Rm, <shitf_op> #<shift>]!`

```asm
    ldr     r5, =var7
    mov     r6, #1
    ldr     r1, [r5, r6, lsl #2]!	@ second item from the array
    ldr     r2, [r5, r6, lsl #2]!	@ third item from the array
    ldr     r3, [r5, r6, lsl #2]!	@ 4th item from the array
```

Also the short version of this command is  when the `<shitf_op> #<shift>` is not specified. Then the address is calculated as: **Rn** + **Rm** and its used in the load/store operation afterwards the new calculated address is stored in the **Rn** register. This particularization of the addressing mode is called:
**Register Pre-Indexed**
and it has the following syntax:
`[Rn, ±Rm]!`
[[toc]](#table-of-contents)



<a name="immediate-post-indexed"></a>
##### 1.5. Immediate Post-Indexed #####

_Syntax_:

`[Rn], #±<offset_12>`

First the value to/at the addess **Rn** will stored/loaded and then the imediat offset **offset_12** which can be positive or negative will be added to the value of the register **Rn**. The result is an address which will be store back to the address **Rn**.

If the `#±<offset_12>` is not specified meaning that the addressing would look: `[Rn]` the addressing is called **Register Immediate**. This was already coverd with the explanation for the **Imediat Offset** addressing explanation.

_Samples_:

The following sample copies the values of the **var6** array into the  **var6_d** and it uses the **Imediate Post-Indexed** addressing.

```asm
    ldr     r0, =var6
    ldr     r1, =var6_d
    ldr     r2, [r0], #1*4      @ load the first value from source
    str     r2, [r1], #1*4      @ store it at destination
    ldr     r2, [r0], #1*4      @ load the first value from source
    str     r2, [r1], #1*4      @ store it at destination
    ldr     r2, [r0], #1*4      @ load the first value from source
    str     r2, [r1], #1*4      @ store it at destination
    ldr     r2, [r0], #1*4      @ load the first value from source
    str     r2, [r1], #1*4      @ store it at destination
```
[[toc]](#table-of-contents)


<a name="scaled-register-post-indexed"></a>
##### 1.6. Scaled Register Post-Indexed #####

_Syntax_:

`[Rn], ±Rm, <shitf_op> #<shift>`

Frist the item is stored/loaded to/from the **Rn** register.  Then the value of the **Rm** register is shifted with the **shift** value using the specified **shift_op** and is added/substracted to the value of the register **Rn**. The resulted address is stored in the **Rn** register.

_Samples_:

```asm
    ldr     r0, =var7
    ldr     r1, =var7_d
    mov     r2, #1
    ld      r5, [r0], r2,lsl #2	@ load the value from r0 and then
                                @   updater0 <- r0 + r2<<2
    str     r5, [r1], r2,lsl #2	@ store the value to r1 and then 
                                @   updater1 <- r1 + r2<2
    ldr     r5, [r0], r2,lsl #2	@  
    str     r5, [r1], r2,lsl #2	@ since there are haldwords handled
    ldr     r5, [r0], r2,lsl #2	@  shift with 1 (multiply by 2)
    str     r5, [r1], r2,lsl #2
    ldr     r5, [r0], r2,lsl #2
    str     r5, [r1], r2,lsl #2
```
Also the short version of this command is  when the `<shitf_op> #<shift>` is not specified. Frist the item is stored/loaded to/from the **Rn** register.  Then the address is calculated as: **Rn** + **Rm** and the result is stored into **Rn** register. This particularization of the addressing mode is called:
**Register Post-Indexed**
and it has the following syntax:
`[Rn], ±Rm`
[[toc]](#table-of-contents)



<a name="single-instruction-multiple-data"></a>
#### 2. SIMD Single Instruction Multiple Data ####

<a name="ldmia-ldmfd"></a>
##### 2.1. ldmia & ldmfd #####

**ldmia** - load multiple _increment after_ 
**ldmfd** - load multiple _full descent_

Load registers from memory, starting with the specified address from **Rd** and increment the address *after* each load. If the **!** is present store the new calculated address in the **Rd** register.

_Pseudo code_:
$\ \ \ \ addr\ \leftarrow \ Rd$
$\ \ \ \ for\ all\ i \in\ register\_list\ do$
$\ \ \ \ \ \ \ \ i\leftarrow Mem[addr]$
$\ \ \ \ \ \ \ \ addr\leftarrow addr +\ 4$
$\ \ \ \ endfor$
$\ \ \ \ if\ !\ is\ present\ then$
$\ \ \ \ \ \ \ \ Rd\ \leftarrow \ addr$

_Sample_:
Load the register range **r1-r3** with the values from the **array2** and display them. Repeat the operation for the next three values from the **array2**.
```assembly
    ldr     r4,  =array2    @ load the addr. of the array2 
    ldmia   r4!, {r1-r3}    @ multiple load the r1, r2, r3, with
                            @ increment after and Rd update
display1:                   @ display the values
    push    {r4}            @ preserve the r4;  might be overriten
    ldr     r0, =fmt2
    bl      printf
    pop     {r4}            @ recover the r4
    ldmia   r4, {r1-r3}     @ multiple load the r1, r2, r3, with
                            @ increment after
display2:                   @ display the values
    ldr     r0, =fmt2
            bl	printf
```
[[toc]](#table-of-contents)



<a name="stmia-stmea"></a>
##### 2.2. stmia & stmea #####

**stmia** - store multiple _increment after_
**stmea** - store multiple _emptpy ascending_

Store registers to memory, starting with the specified address from **Rd** and increment the address *after* each load. If the **!** is present store the new calculated address in the **Rd** register.

_Pseudo code_:
$\ \ \ \ addr\ \leftarrow \ Rd$
$\ \ \ \ for\ all\ i \in\ register\_list\ do $
$\ \ \ \ \ \ \ \ Mem[addr] \leftarrow i $
$\ \ \ \ \ \ \ \ addr\leftarrow addr +\ 4 $
$\ \ \ \ endfor$
$\ \ \ \ if\ !\ is\ present\ then$
$\ \ \ \ \ \ \ \ Rd\ \leftarrow \ addr$

_Sample_: 
In the **array1** store twice the contents of the **r0**, **r1** and **r2**.
```assembly
    ldr     r4, =array1         @ load the array address
    stmia   r4!, {r0, r1, r2}   @ store at the address from r4
                                @ and 'Increment After' the address
                                @ with 3*4 bytes and store it back to r4
    stmia   r4, {r0, r1, r2}    @ continue storing the values of the 3
                                @ registers further in the array
                                @ but this time don't update the r4
```
[[toc]](#table-of-contents)



<a name="stmda-stmed"></a>
##### 2.3. stmda & stmed #####

**stmia** - store multiple _decrement after_
**stmea** - store multiple _emptpy descending_

Store registers to memory, starting with the specified address from **Rd** and *decrement* the address *after* each store. If the **!** is present store the new calculated address in the **Rd** register.

**Note**
Its important to peek atention to the order in which the registers from the list are stored into memory. If its **decrement before/after** then the last register is stored first and then the one before it and so on. If its **increment before/after** the first register is stoed in the memory and then the next one and so on.
The registers in the register_list should be in order, even if they are not consecutive. Otherwise the assembler will show a *warning*, ignore the  order they were specified and take them in the appropriate order:
```
load_store_multi.s:91: Warning: register range not in ascending order
```

_Pseudo code_:
$\ \ \ \ addr\ \leftarrow \ Rd$
$\ \ \ \ for\ all\ i \in\ register\_list\ do $
$\ \ \ \ \ \ \ \ Mem[addr] \leftarrow i $
$\ \ \ \ \ \ \ \ addr\leftarrow addr -\ 4 $
$\ \ \ \ endfor$
$\ \ \ \ if\ !\ is\ present\ then$
$\ \ \ \ \ \ \ \ Rd\ \leftarrow \ addr$

_Sample_: 

```assembly
    ldr     r0, =array_fwd              @ load in r0 the address of the
    add     r0, r0, #array_fwd_bsize    @ last element of the array_fwd
    sub     r0, r0, #4                  @	 
    ldr     r1,	=array_rew              @ load in r1 the address of the
    add     r1, r1, #array_fwd_bsize    @ last element of the array_rew
    sub     r1, r1, #4                  @
    @  make the transfer of data between the arrays
    ldmda   r0!, {r2-r5}                @ transfer 4 words btwreen arrays
    stmda   r1!, {r2-r5}
    ldmda   r0!, {r2-r5}                @ transfer another 4 words
    stmda   r1!, {r2-r5}
```
[[toc]](#table-of-contents)



<a name="ldmda-ldmfa"></a>
##### 2.4. ldmda & ldmfa #####

**ldmda** - load multiple _decrement after_
**ldmfa** - load multiple _full asscending_

Load registers from memory, starting with the specified address from **Rd** and decrement the address *after* each load. If the **!** is present store the new calculated address in the **Rd** register.

**Note**
Its important to peek atention to the order in which the registers from the list are loaded. If its **decrement before/after** then the last register is filled first and then the one before it and so on. If its **increment before/after** the first register is filled and then the next one and so on.
The registers in the register_list should be in order, even if they are not consecutive. Otherwise the assembler will show a *warning*, ignore the  order they were specified and take them in the appropriate order:
```
load_store_multi.s:91: Warning: register range not in ascending order
```
_Pseudo code_:
$\ \ \ \ addr\ \leftarrow \ Rd$
$\ \ \ \ for\ all\ i \in\ register\_list\ do$
$\ \ \ \ \ \ \ \ i\leftarrow Mem[addr]$
$\ \ \ \ \ \ \ \ addr\leftarrow addr -\ 4$
$\ \ \ \ endfor$
$\ \ \ \ if\ !\ is\ present\ then$
$\ \ \ \ \ \ \ \ Rd\ \leftarrow \ addr$

_Sample_: 

```assembly
    ldr     r0, =array_fwd              @ load in r0 the address of the
    add     r0, r0, #array_fwd_bsize    @ last element of the array_fwd
    sub     r0, r0, #4                  @	 
    ldr     r1,	=array_rew              @ load in r1 the address of the
    add     r1, r1, #array_fwd_bsize    @ last element of the array_rew
    sub     r1, r1, #4                  @
    @  make the transfer of data between the arrays
    ldmda   r0!, {r2-r5}                @ transfer 4 words btwreen arrays
    stmda   r1!, {r2-r5}
    ldmda   r0!, {r2-r5}                @ transfer another 4 words
    stmda   r1!, {r2-r5}
```
[[toc]](#table-of-contents)

<a name="simd-the-rest"></a>
##### 2.5. the rest ... #####

There are another four SIMD instructions which are similar with the ones specified above with only one small diference: the moment when the address is calculated.  **ia** - **increment after**, respectively **da** - **decrement after**, means that the address is calculated after the data transfer happened. 

In case of the remining instructions which have the subfix **ib** - **increment before**, respectively **db** - **decrement before**, the address is calculated before the data transfer. 

**ldmib** - load multiple _increment before_
**ldmed** - load multiple _empty descending_


**ldmdb** - load multiple _decrement before_
**ldmea** - load multiple _empty ascending_


**stmib** - store multiple _increment before_
**stmfa** - store multiple _full ascending_


**stmdb** - store multiple _decrement before_
**stmfd** - store multiple _full descending_

[[toc]](#table-of-contents)


<a name="condition-flags"></a>
#### 3. Condition Flags ####

**CPRS** register contains the bit flags 31-28 which can keep the result of the executed operations/instructions and they can also be used to control whether or not some insutrctions are executed. Also these flags can be used in the branch (jump) instructions. 

|31|30|29|28|27|26|25|24| 
|-|-|-|-|-|-|-|-|
|N|Z|C|V|Q|||J|

**N** - This bit is set to **1** if the signed result of an operation is *negative* and is set to **0** if the signed result of an operation is *positive* or *zero*.

**Z** - This bit is set to **1** if the result of an operation is *zero* and set to **0** if the result of an operation is *non-zero*.

**C** - This bit is **set** if an add operation results into a *carry out* of the most significant bit, or if an substract operation **DOES NOT** result in a *borrow*. For *shift* operations this bit is set to the **value** of the bit shifted out by the shifter.  **IMPORTANT** ARM uses an **inverted** carry flag for **borrow**.

**V** - This bit is **set** if for an addition or substraction an signed overflow occurs.

<a name="condition-modifiers"></a>
##### 3.1. Condition Modifiers #####

| \<cond\> | meaning | op |
|:-:|-|:-:|
| al | always (default condition) |
| eq | **Z** set ( equal in a *cmp* ) | signed |
| ne | **Z** clear ( not equal in a *cmp* ) | signed |
| ge | ( **N** set and **V** set )  OR  ( **N** clear and **V** clear ) | signed |
| gt | ( **Z** clear ) AND ( ( **N** clear and **V** clear ) OR ( **N** clear and **V** set ) ) | signed |
| le | (**Z** set ) OR  ( **N** clear and **V** set ) OR ( **N** set and **V** clear ) ) | signed |
| lt | ( **N** set and **V** clear )  OR  ( **N** clear  and **V** set ) | signed |
| hi | **Z** clear AND **C** set | unsigned |
| ls | **Z** set OR **C** clear | unsigned |


[[toc]](#table-of-contents)


<a name="routines"></a>
#### 4. Routines ####

All processor families have their own standard methods, or _function calling conventions_ which specify how arguments are passed to subroutines and how function values are returned.
The basic subroutine calling rules for the ARM processor are the following:
+ The first four arguments go in the registers **r0-r3** 
+ Any remaining arugments are pushed to the **Stack**
+ The return value, if exists, is stored in **r0** before return to caller

Some of the ARM processor register have special purposes that are dictated by the hardware design. Other have special purposes dictated by _programming conventions_. Programmers follow these conventions to make their subroutines compatible with each other. These conventions are a set of rules on how the registers should be used:

+ **Parameter Registers** are the registers **r0-r3** also know as _a1-a4_ arguments 1 to 4. Are used to pass the arguments into a subroutine and **a0** return the result value from a function. Them may also be used to hold intermediate values withing a routine.
Caller assumes they will be modified.

+ **Variable Registers** are the registers **r4-r11** also know as _v1-v8_ which can be used to hold local  _variables_. A routine **must** preserve (save and restore) them if they modified, by pushing them to the stack at the begging of the function (subroutine) and poped before the return.
The **r11** also know as **fp** (Frame Pointer) is used by the C compiler to track the _stack frame_.

+ **Intra-Procedure Scratch Register: r12** it is used by the C Library when calling dynamically linked functions. If the function does not make any C library function calls, then the r12 can be used to store local variables.

[[toc]](#table-of-contents)


<a name="calling_subroutines"></a>
#### 4.1. Calling SubRoutines ####

Besides the argument registers also the following registers invloved into subroutine calls:
|       |                |      |
|-------|----------------|------|
|**sp** | Stack Pointer  | (r13)|
|**lr** | Link Register  | (r14)|
|**pc** | Program Counter| (r15)|

When calling a subroutine, the caller must place the arguments in the _argument registers_ and possibly also on the _stack_. Placing the arguments at the appropriate locations is called **marshaling the arguments**. 

After marshaling, the caller executes the **bl** instruction which will modify the **pc** (program counter) and the **lr** (link register). The **bl** will copy the contents of the **pc** into **lr** then it loads the **pc** with the address of the first instruction of the routine that is beeing called.

If the subroutine has less then 4 parameters then the r0-r3 are used for parameters marshaling. The following example is a simple `printf` function call
with 4 arguments.
```C
    printf(formatstr, a, b, c)
```
In ARM assembly it will look similar with:

```asm
    ldr     r0, =formatstr
    ldr     r1, =a
    ldr     r1, [r1]
    ldr     r2, =b
    ldr     r2, [r2]
    ldr     r3, =c
    ldr     r3, [r3]
```

If there are more arguments the number or arguments which excede 4 will be pushed to the stack in reverse order.

```C
    printf(formatstr, a, b, c, d, e)
```
In ARM assembly it will look similar with:

```asm
    ldr     r0, =e              @ load the address of the last parameter
    ldr     r0, [r0]            @ load the value of the last parameter
    str     r0, [sp, #-4]!      @ decrement the SP with 4 and store the r0
    ldr     r0, =d              @ repeat the same thing with the argument 5
    ldr     r0, [r0]            @ 
    str     r0, [sp, #-4]!      @ 
    ldr     r0, =formatstr      @ the rest of parameters put them on stack
    ldr     r1, =a
    ldr     r1, [r1]
    ldr     r2, =b
    ldr     r2, [r2]
    ldr     r3, =c
    ldr     r3, [r3]
    bl      =printf             @ call the function
    add     sp, sp, #8          @ remove the params from the stack
```

Another, way to write the function call above is to take advantage of the _multiple load/store instructions_: **stmfd** and **ldmfd**.

```asm
    ldr     r0, =e              @ load the address of the last parameter
    ldr     r0, [r0]            @ load the value of the last parameter
    ldr     r1, =d              @ repeat the same thing with the argument 5
    ldr     r1, [r1]            @ 
    stmfd   sp!, {r0,r1}        @ store to stack the r0 and r1
    ldr     r0, =formatstr      @ the rest of parameters put them on stack
    ldr     r1, =a
    ldr     r1, [r1]
    ldr     r2, =b
    ldr     r2, [r2]
    ldr     r3, =c
    ldr     r3, [r3]
    bl      =printf             @ call the function
    add     sp, sp, #8          @ remove the params from the stack
```

[[toc]](#table-of-contents)
