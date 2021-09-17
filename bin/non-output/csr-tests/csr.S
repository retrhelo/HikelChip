	.globl _entry
_entry: 

# basic tests
li a0, 0xff
csrrw a0, mscratch, a0

li a0, 0xa
csrrc a0, mscratch, a0

li a0, 0xf0
csrrs a0, mscratch, a0

# use different rs1 and rd
li a0, 0xff
csrrw a1, mscratch, a0

li a0, 0xa
csrrc a2, mscratch, a0

li a0, 0xf0
csrrs a3, mscratch, a0

# test read
csrr a0, mhartid

# test write
li a0, 0x114514
csrw mscratch, a0

.word 0x6b