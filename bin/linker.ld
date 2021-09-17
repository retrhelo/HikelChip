OUTPUT_ARCH(riscv)
ENTRY(_entry)

BASE_ADDRESS = 0x80000000;

SECTIONS {
	/* load the kernel at this address */
	. = BASE_ADDRESS;

	.text : {
		*(.text.entry)
		*.(.text .text.*)
	}
}