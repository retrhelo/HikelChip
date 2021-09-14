# generate verilog code for simulation
sim-verilog:
	mill -i __.test.runMain hikel.SimTopGenVerilog

# below are works for testing code compiling

PREFIX = riscv64-unknown-elf-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy
OBJDUMP = $(PREFIX)objdump

ASFLAGS = -c -march=rv32i -mabi=ilp32

CSR_DIR = bin/non-output/csr-tests
CSR_SRC = \
	$(CSR_DIR)/csr.S \
	$(CSR_DIR)/csri.S

SRC += $(CSR_SRC)
OBJ = $(addsuffix .o, $(basename $(SRC)))
BIN = $(addsuffix .bin, $(basename $(SRC)))

bin_test: $(BIN)

%.bin: %.o
	$(OBJCOPY) $< --strip-all -O binary $@