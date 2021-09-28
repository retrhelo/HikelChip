# generate verilog code for simulation
sim-verilog:
	mill -i __.test.runMain hikel.SimTopGenVerilog

# below are works for testing code compiling

PREFIX = riscv64-unknown-elf-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc
LD = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy
OBJDUMP = $(PREFIX)objdump

ASFLAGS = -march=rv64i -mabi=lp64 -c

CSR_DIR = bin/non-output/csr-tests
CSR_SRC = \
	$(CSR_DIR)/csr.S \
	$(CSR_DIR)/exception.S \
	$(CSR_DIR)/ecall.S \
	$(CSR_DIR)/exception2.S 
SRC += $(CSR_SRC)

LSU_DIR = bin/non-output/riscv-tests/loadstore
LSU_SRC = \
	$(LSU_DIR)/load-after-store.S
SRC += $(LSU_SRC)

OBJ = $(addsuffix .o, $(basename $(SRC)))
BIN = $(addsuffix .bin, $(basename $(SRC)))

bin_test: $(BIN)

%.bin: %.o
	$(LD) -N -e _entry -Tbin/linker.ld $< -o $(addsuffix .out, $(basename $<))
	$(OBJCOPY) $(addsuffix .out, $(basename $<)) --strip-all -O binary $@
	$(OBJDUMP) -Da $(addsuffix .out, $(basename $<)) >$(addsuffix .txt, $(basename $<))
	rm $(addsuffix .out, $(basename $<))