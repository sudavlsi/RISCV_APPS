/* Simple linker script for 32-bit RISC-V */

ENTRY(main)  /* Define the entry point */

/* Memory Layout */
MEMORY
{
    /* The flash memory region where the program code is stored */
    flash (rx) : ORIGIN = 0x80000000, LENGTH = 0x10000

    /* The RAM region where the data and BSS are placed */
    ram (rw) : ORIGIN = 0x90000000, LENGTH = 0x20000
}

/* Section Layout */
SECTIONS
{
    /* Text section (code) placed in flash memory */
    .text :
    {
        *(.text)        /* All .text sections from object files */
		  *(.rodata)      /* All .rodata (read-only data) sections */

     } > flash

    /* Data section (initialized variables) placed in RAM */
    .data : 
    {
        *(.data)        /* All .data sections from object files */

    } > ram

    /* BSS section (uninitialized variables) placed in RAM */
  .bss (NOLOAD) :
    {
        __bss_start = .;   /* Define the start of the .bss section */
        *(.bss)            /* All .bss sections from object files */
        *(COMMON)          /* Common BSS variables */
        __bss_end = .;     /* Define the end of the .bss section */
    } > ram
    /* Stack and heap (if needed) can be defined here */
    .stack :
    {
        . = ALIGN(16);
        *(.stack)
    } > ram

    /* End of memory, used for program size check or additional sections */
    _end = .;
}
_global_pointer_$ = 0x80000000; /* Set to a valid address in RAM */
/*tohost = 0x80000000;
fromhost = 0x80000010;*/
