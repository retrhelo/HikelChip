# Tests for CLINT and timer interrupt

	.section .text.entry
	.globl _entry
_entry: 
	# setup mtvec
	la a0, trap_vec
	csrw mtvec, a0

	# clear timer interrupt pending bit 
	li a0, 0x0200bff8
	ld a1, 0(a0)
	addi a1, a1, 1000
	li a0, 0x02004000
	sd a1, 0(a0)

	# enable interrupt
	csrwi mstatus, 0x8

	# wait for timer interrupt
loop:
	j loop
	
	.globl trap_vec
	.align 4
trap_vec: 
	# save trapframe
	addi sp, sp, -64
	sd a0, 0(sp)
	sd a1, 8(sp)
	sd a2, 16(sp)
	sd a3, 24(sp)
	sd a4, 32(sp)
	sd a5, 40(sp)
	sd a6, 48(sp)
	sd a7, 56(sp)

	# handle the trap
	call trap_handler

	# restore trapframe
	ld a0, 0(sp)
	ld a1, 8(sp)
	ld a2, 16(sp)
	ld a3, 24(sp)
	ld a4, 32(sp)
	ld a5, 40(sp)
	ld a6, 48(sp)
	ld a7, 56(sp)

	addi sp, sp, 64

	# return to the context
	mret

	.globl trap_handler
trap_handler:
	.word 0x6b