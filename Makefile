ID = 210727

# generate verilog code for simulation
sim-verilog:
	mill -i __.test.runMain hikel.SimTopGenVerilog
	sed -i 's/io_memAXI_0_w_bits_data,/io_memAXI_0_w_bits_data[3:0],/g' ./build/SimTop.v
	sed -i 's/io_memAXI_0_r_bits_data,/io_memAXI_0_r_bits_data[3:0],/g' ./build/SimTop.v
	sed -i 's/io_memAXI_0_w_bits_data =/io_memAXI_0_w_bits_data[0] =/g' ./build/SimTop.v
	sed -i 's/ io_memAXI_0_r_bits_data;/ io_memAXI_0_r_bits_data[0];/g' ./build/SimTop.v

soc-verilog:
	mill -i __.test.runMain hikel.SocTopGenVerilog
	sed -i 's/ysyx_$(ID)_SocTop/ysyx_$(ID)/g' build/SocTop.v
	cp build/SocTop.v soc/vsrc/ysyx_$(ID).v
	make -C soc

# below are works for testing code compiling

PREFIX = riscv64-unknown-elf-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc
LD = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy
OBJDUMP = $(PREFIX)objdump

ASFLAGS = -march=rv64i -mabi=lp64

CSR_DIR = bin/non-output/csr-tests
CSR_SRC = \
	$(CSR_DIR)/csr.S \
	$(CSR_DIR)/exception.S \
	$(CSR_DIR)/ecall.S \
	$(CSR_DIR)/exception2.S 
SRC += $(CSR_SRC)

OBJ = $(addsuffix .o, $(basename $(SRC)))
BIN = $(addsuffix .bin, $(basename $(SRC)))

bin_test: $(BIN)

%.bin: %.o
	$(LD) -N -e _entry -Tbin/linker.ld $< -o $(addsuffix .out, $(basename $<))
	$(OBJCOPY) $(addsuffix .out, $(basename $<)) --strip-all -O binary $@
	$(OBJDUMP) -Da $(addsuffix .out, $(basename $<)) >$(addsuffix .txt, $(basename $<))
	rm $(addsuffix .out, $(basename $<))