SECTIONS  
{
    . = 0x1000;
    .text : { *(.text) }
    . = 0x2000;
    .data : { *(.data) }
    . = 0x3000;
    .bss : {  _bstart = . ; *(.bss ) ;  _bend = . ; }
}
