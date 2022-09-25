ENTRY(main)

MEMORY {
    FLASH(rx): ORIGIN=0x00000000, LENGTH=4K
    /* SRAM(rw): ORIGIN=0x00000000, LENGTH=16K */
}

SECTIONS
{
    .text : {
        * (.text)
        * (.rodata)
    } > FLASH

    /* .data : {
        * (.data)
    } SRAM AT> FLASH */
}
