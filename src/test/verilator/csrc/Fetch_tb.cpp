// Generate virtual ROM for Fetch to read

#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "VFetch.h"

constexpr int ROM_SIZE = 16;
uint32_t inst_rom[ROM_SIZE];

int load_inst(char *filename, uint32_t *buf, int size) {
	FILE *fp = fopen(filename, "rb");

	printf("open %s\n", filename);
	if (NULL == fp) {
		printf("failed\n");
		return -1;
	}

	// fetch file size
	return fread(buf, sizeof(uint32_t), ROM_SIZE, fp);
}

int main(int argc, char **argv) {
	char filename[32];
	printf("Please enter your filename~\n");
	fgets(filename, 32, stdin);

	// load instruction
	int read_cnt = load_inst(filename, inst_rom, ROM_SIZE);
	if (read_cnt < 0) {
		// fail to load
		printf("Fail to read from %s\n", filename);
		printf("read_cnt = %d\n", read_cnt);
		return -1;
	}

	// initialization
	Verilated::commandArgs(argc, argv);
	Verilated::traceEverOn(true);

	VFetch *top = new VFetch;
	VerilatedVcdC *tfp = new VerilatedVcdC;
	top->trace(tfp, 99);
	tfp->open("top.vcd");

	// enable module
	top->io_enable = 1;
	top->io_clear = 0;
	top->io_trap = 0;

	vluint64_t main_time = 0;
	vluint64_t const sim_time = 1000;
	while (!Verilated::gotFinish() && main_time < sim_time) {
		// clock tick
		if (0 == main_time % 10) {
			top->clock = 0;
		}
		else if (5 == main_time % 10) {
			top->clock = 1;
		}

		// connect to icache
		int offset = top->io_fetch_pc >> 2;
		top->io_fetch_ready = 1;
		if (offset < ROM_SIZE) {
			top->io_fetch_inst = inst_rom[offset];
			top->io_fetch_illegal = 0;
		}
		else {
			top->io_fetch_inst = 0;
			top->io_fetch_illegal = 1;
		}

		// disable jump
		top->io_change_pc = 0;

		// pass in pc
		top->io_in_pc = top->io_out_pc + 4;

		// disable exceptions
		top->io_in_excp = 0;
		top->io_in_code = 0;

		top->eval();
		tfp->dump(main_time);
		main_time ++;
	}

	// clean up
	tfp->close();
	delete top;
	delete tfp;

	return 0;
}