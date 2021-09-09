// Testbench for ALU

#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <ctime>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "VAlu.h"

#define ROUNDS 		1000

int main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);
	Verilated::traceEverOn(true);

	VAlu *top = new VAlu;
	VerilatedVcdC *tfp = new VerilatedVcdC;
	top->trace(tfp, 99);
	tfp->open("top.vcd");

	srand(time(NULL));	// use random numbers for testing
	for (int i = 0; i < ROUNDS; i ++) {
		int64_t a = rand();
		int64_t b = rand();
		int64_t result;
		int op = i & 0x7;

		// int word = rand() % 2;
		int word = rand() % 2;
		int arith = rand() % 2;

		// connect to ALU
		top->io_in_op = (word << 4) | (arith << 3) | op;
		top->io_in_in0 = a;
		top->io_in_in1 = b;

		top->eval();

		switch (op) {
			case 0x0: 	// add
				if (arith) {
					result = a - b;
				}
				else {
					result = a + b;
				}
				break;
			case 0x2: 	// slt
				if (a < b) {
					result = 1;
				}
				else {
					result = 0;
				}
				break;
			case 0x3: 	// sltu
				if ((uint64_t)a < (uint64_t)b) {
					result = 1;
				}
				else {
					result = 0;
				}
				break;
			case 0x4: 	// xor
				result = a ^ b;
				break;
			case 0x6: 	// or
				result = a | b;
				break;
			case 0x7: 	// and
				result = a & b;
				break;
			case 0x1: 	// sll
				b = b % 64;
				result = a << b;
				break;
			case 0x5: 	// srl
				b = b % 64;
				if (arith) {
					result = a >> b;
				}
				else {
					result = (uint64_t)a >> (b % 64);
				}
				break;
		}

		if (word) {
			result = (int32_t)result;
		}

		tfp->dump(i);

		if (result != top->io_res) {
			printf("[%d] error! result = %lx, res = %lx\n", 
				i, result, top->io_res
			);
			printf("a = %lx, b = %lx\n", a, b);
			printf("op = %d, word = %d, arith = %d\n", 
				op, word, arith
			);
			tfp->dump(i+1);
			break;
		}
	}

	tfp->close();
	delete top;
	delete tfp;

	return 0;
}