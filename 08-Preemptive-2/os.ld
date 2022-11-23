/* Copied from the Script for -z combreloc and heavily hacked up by jrw */
/* Copyright (C) 2014-2020 Free Software Foundation, Inc.
   Copying and distribution of this script, with or without modification,
   are permitted in any medium without royalty provided the copyright
   notice and this notice are preserved.  */

OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv", "elf32-littleriscv")
OUTPUT_ARCH(riscv)

MEMORY
{
   /* qemu-system-risc32 virt machine */
   RAM (rwx)  : ORIGIN = 0x80000000, LENGTH = 128M 
}

ENTRY(_start) /* this will cause an error if the symbol _start is not present */

SECTIONS
{
	. = ORIGIN(RAM);

	PROVIDE(__ram_origin__ = ORIGIN(RAM));
	PROVIDE(__ram_end__ = ORIGIN(RAM) + LENGTH(RAM));

	.text : 
	{
		. = ALIGN(4096);
		__text_start = .;
		KEEP(*(.text.crt0))		/* this is why _start comes before any other function */
		*(.text.*)
		__text_end = .;
	}

	.rodata :
	{
		. = ALIGN(0x1000);
		__rodata_start = .;
		*(.rodata.*)
		*(.srodata.*)
		__rodata_end = .;
	}

	.data : 
	{ 
		. = ALIGN(4096);
		__data_start = .;
		*(.data.*) 
		*(.sdata*) 				/* small data objects */
		__data_end = .; 
	}

	.bss : 
	{
		. = ALIGN(4096);
		__bss_start__ = .;
		*(.sbss*) 			/* small data objects */
		*(.bss*) 
		__bss_end__ = .;
	}

	_end = .; 
}
