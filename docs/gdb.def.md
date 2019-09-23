#### GDB ####

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

gef> hexdump byte 0x21000 100   // show memory hexdump style from addr 100 bytes
gef> context                    // get back the summary
gef> memory watch 0x00021000 0x40 byte  // show the memory from addrd into context 
gef> memory unwatch 0x00021000          // remove memory from addr into context
