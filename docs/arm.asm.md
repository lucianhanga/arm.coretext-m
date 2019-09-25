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
