// General wrapper for SimTop, providing an easy way to load programs.

#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <csignal>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "VSimTop.h"

constexpr uint32_t ROM_SIZE = 1024;
uint32_t inst_rom[ROM_SIZE];

constexpr int CYCLE = 10;

int load_inst(char *filename, uint32_t *buf, int size) {
	printf("loading %s into ROM\n", filename);
	FILE *fp = fopen(filename, "rb");

	if (NULL == fp) {
		return -1;
	}

	// fetch file size
	return fread(buf, sizeof(uint32_t), ROM_SIZE, fp);
}

VSimTop *top = nullptr;
VerilatedVcdC *tfp = nullptr;

// close simulation by pressing Ctrl-C
void term_handler(int signum) {
	tfp->close();

	delete top;
	delete tfp;

	exit(0);
}

int main(int argc, char **argv) {
	uint64_t loop = 10;

	printf("argc = %d\n", argc);
	// pass filename from commandline
	if (argc >= 3) {
		loop = atoi(argv[2]);
		if (0 == loop) {
			printf("invalid loop number\n");
			loop = 10;
		}
	}
	if (argc >= 2) {
		// let's load file
		int read_cnt = load_inst(argv[1], inst_rom, ROM_SIZE);
		if (read_cnt < 0) {
			// fail to load
			printf("fail to load from %s\n", argv[1]);
			printf("read_cnt = %d\n", read_cnt);
			exit(-1);
		}
	}
	else {
		printf("help: %s filename cycle\n", argv[0]);
		exit(-1);
	}

	// register signal handler
	signal(SIGTERM, term_handler);

	// initialization
	Verilated::commandArgs(argc, argv);
	Verilated::traceEverOn(true);

	top = new VSimTop;
	tfp = new VerilatedVcdC;
	top->trace(tfp, 99);
	tfp->open("top.vcd");

	// let's start
	for (uint64_t i = 0; i < loop * CYCLE; i ++) {	// endless loop but with a counter
		// generate clock signal
		if (0 == i % CYCLE) {
			top->clock = 0;
		}
		else if (5 == i % CYCLE) {
			top->clock = 1;
		}
		// assert reset signal for 2 cycles
		if (i < CYCLE * 2) {
			top->reset = 1;
		}
		else {
			top->reset = 0;
		}

		// read from ROM
		constexpr uint32_t START_ADDR 	= 0x80000000;
		constexpr uint32_t END_ADDR 	= START_ADDR + ROM_SIZE * sizeof(uint32_t);
		if (top->io_pc >= START_ADDR && top->io_pc < END_ADDR) {
			uint32_t offset = top->io_pc - START_ADDR;
			top->io_inst = inst_rom[offset >> 2];
			top->io_icache_illegal = 0;

			if (top->io_inst == 0x6b) {
				printf("An error occurs!\n");
				tfp->dump(i + CYCLE / 2);
				tfp->close();
				delete tfp;
				delete top;
				exit(-1);
			}
		}
		else {
			top->io_inst = 0;
			top->io_icache_illegal = 1;
		}
		top->io_icache_ready = 1;	// rom is always ready

		top->eval();
		tfp->dump(i);
	}

	printf("simulation terminated...\n");
	tfp->close();
	delete tfp;
	delete top;

	return 0;
}