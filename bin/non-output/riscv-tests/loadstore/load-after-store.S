	.section .text.entry
	.globl _entry
_entry:
	li t0, 0x80001000
	li t1, 0x1234
	sh t1, -4(t0)
	lh t2, -4(t0)

	beq t1, t2, success
	li a0, -1
	j end
success: 
	li a0, 0
end: 
	.word 0x6b

infinite:
	j infinite