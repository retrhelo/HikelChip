	.section .text.entry
	.globl _entry
_entry:
	# setup trap handler
	lla t0, trap_handler
	csrw mtvec, t0

	li a0, 127
	li a1, 1

	# let's put an illegal instruction here
	.word 0

	add a0, a0, a1

	# end of this program
	.word 0x6b

	.section .text
	.globl trap_handler
	.align 4
trap_handler:
	# no context saving since load/store are not done yet
	.word 0x6b	# first let's see if the programme can run into trap handler