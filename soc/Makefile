# building simulating program for ysyxSoC

ID 		:= 210727
TARGET 	:= emu

VERILATOR = verilator

CSRC = \
	csrc/spiFlash.cpp \
	csrc/main.cpp 

VSRC = \
	vsrc/peripheral/spi/rtl/amba_define.v \
	vsrc/peripheral/spi/rtl/spi_clgen.v \
	vsrc/peripheral/spi/rtl/spi_defines.v \
	vsrc/peripheral/spi/rtl/spi_shift.v \
	vsrc/peripheral/spi/rtl/spi_top.v \
	vsrc/peripheral/spi/rtl/spi.v \
	vsrc/peripheral/spiFlash/spiFlash.v \
	vsrc/peripheral/uart16550/rtl/raminfr.v \
	vsrc/peripheral/uart16550/rtl/timescale.v \
	vsrc/peripheral/uart16550/rtl/uart_apb.v \
	vsrc/peripheral/uart16550/rtl/uart_defines.v \
	vsrc/peripheral/uart16550/rtl/uart_receiver.v \
	vsrc/peripheral/uart16550/rtl/uart_regs.v \
	vsrc/peripheral/uart16550/rtl/uart_rfifo.v \
	vsrc/peripheral/uart16550/rtl/uart_sync_flops.v \
	vsrc/peripheral/uart16550/rtl/uart_tfifo.v \
	vsrc/peripheral/uart16550/rtl/uart_transmitter.v \
	vsrc/ysyx_$(ID).v \
	vsrc/ysyxSoCFull.v

VSRC_FOLDER = \
	-Ivsrc/peripheral/spi/rtl \
	-Ivsrc/peripheral/spiFlash \
	-Ivsrc/peripheral/uart16550/rtl \
	-Ivsrc 

CFLAGS = -std=c++11 -Wall

VERILATOR_FLAGS = --x-assign unique --cc --exe --trace --assert -O3
VERILATOR_FLAGS += -CFLAGS "$(CFLAGS)"
VERILATOR_FLAGS += --build ysyxSoCFull.v
VERILATOR_FLAGS += --timescale "1ns/1ns"
VERILATOR_FLAGS += --top-module ysyxSoCFull

all: $(CSRC) $(VSRC)
	$(VERILATOR) $(VERILATOR_FLAGS) $(VSRC_FOLDER) -o $(TARGET) $(CSRC)