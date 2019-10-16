SECTIONS  
{
    .text 0x1000 : { *(.text) }
    .data 0x2000 : AT (ADDR (.text) +  SIZEOF(.text)) { *(.data)}
    .bss  0x3000 : { _bstart = . ; *(.bss ) ;  _bend = . ; }
}
