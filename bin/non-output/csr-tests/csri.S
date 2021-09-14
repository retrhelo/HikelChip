# basic tests

csrrwi a0, mscratch, 0x1f

csrrci a0, mscratch, 0xa

csrrsi a0, mscratch, 0x10

csrrwi a1, mscratch, 0x1f
csrrci a2, mscratch, 0x0a
csrrsi a3, mscratch, 0x10

csrwi mscratch, 0x1c

.word 0x6b