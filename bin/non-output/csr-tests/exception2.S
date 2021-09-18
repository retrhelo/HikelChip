	.section .text.entry
	.globl _entry
_entry:
	# setup trap handler
	la t0, trap_handler
	csrw mtvec, t0

	li a0, 127
	li a1, 1

	ecall

	add a0, a0, a1

	# end of this program
	.word 0x6b

	.section .text
	.globl trap_handler
	.align 4
trap_handler:
	# change mepc to jump ebreak
	csrr t1, mepc
	addi t1, t1, 4
	csrw mepc, t1

	mret

	# the program shouldn't reach here
infinite_loop: 
	j infinite_loop