package hikel

import chisel3._
import chisel3.util._

import Config._

import difftest._

object RegFile {
	val NUM 	= 32
	val ADDR 	= log2Ceil(NUM)
}

class RegFileRead extends Bundle {
	val addr 	= Input(UInt(RegFile.ADDR.W))
	val data 	= Output(UInt(MXLEN.W))
}

class RegFileWrite extends Bundle {
	val rd_addr 	= Input(UInt(RegFile.ADDR.W))
	val rd_data 	= Input(UInt(MXLEN.W))
	val rd_wen 		= Input(Bool())
}

class RegFilePort extends Bundle {
	val read = Vec(2, new RegFileRead)
	val write = new RegFileWrite
}

class RegFile extends Module {
	val io = IO(new RegFilePort)

	val regfile = Reg(Vec(RegFile.NUM, UInt(MXLEN.W)))

	// read
	for (i <- 0 until 2) {
		val read = io.read(i)
		read.data := regfile(read.addr)
	}

	when (io.write.rd_wen) {
		regfile(io.write.rd_addr) := io.write.rd_data
	}

	// hardwire x0 to zero
	regfile(0) := 0.U

	// difftest
	if (YSYX_DIFFTEST) {
		val difftest = Module(new DifftestArchIntRegState)
		difftest.io.clock 		:= clock
		difftest.io.coreid 		:= 0.U
		for (i <- 0 until RegFile.NUM) {
			difftest.io.gpr(i) 	:= regfile(i)
		}
	}
}