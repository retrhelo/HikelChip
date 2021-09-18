	.section .text.entry
	.globl _entry
_entry:
	# setup trap handler
	la t0, trap_handler
	csrw mtvec, t0

	ecall

infinite_loop:
	j infinite_loop


	.section .text
	.globl trap_handler
	.align 4
trap_handler:
	add a0, zero, 14

	# well done, you've reached here
	.word 0x6b