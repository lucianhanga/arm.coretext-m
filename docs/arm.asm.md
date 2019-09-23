#### Table of Contents

1. [_ARM_ Addressing Modes](#arm-addressing-modes)
1.1. [Imediate Offset / Register Immediate](#immediate-offset)
1.2. [Scaled Register Offset / Offset Register](#scaled-register-offset)
1.3. [Immediate Pre-Indexed](#immediate-pre-indexed)
1.4. [Scaled Register Pre-Indexed / Register Pre-Indexed](#scaled-register-pre-indexed)
1.5. [Immediate Post-Indexed](#immediate-post-indexed)
1.6. [Scaled Register Post-Indexed / Register Post-Indexed](#scaled-register-post-indexed)

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
