
#### _ARM_ addressing modes ####

##### Imediate Offset #####

[//]: # (Comment in the md code)

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

##### Scaled Register Offset #####

[//]: # (Comment in the md code)

_Syntax_:

`[Rn, ±Rm, <shitf_op> #<shift>]`

The value of the **Rm** register is shifted with the **shift** value using the specified **shift_op** and then is added/substracted to the value of the register **Rn**. The result is an address where an item will loaded or stored.

_Samples_:

In the example below assume that the register **r0** is loaded with the address of hte matrix. The matrix contains 4 byte values. The **r1** can be seen as the index for navigating the matrix. Since there are 4 byte values, the index should be multiplied with 4 - or shifted to left with 2: `lsl #2`.

```asm
matrix:     .word   0x0000000A, 0x0000000B, 0x0000000C, 0x0000000D
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
