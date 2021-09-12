package hikel

import chisel3._
import chisel3.util._

import hikel.Config._

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
		read.data := Mux(read.addr.orR, regfile(read.addr), 0.U)
	}

	when (io.write.rd_wen) {
		regfile(io.write.rd_addr) := io.write.rd_data
	}

	// hardwire x0 to zero
	regfile(0) := 0.U

	// for ysyx difftest
	if (YSYX_TEST_OUTPUT) {
		val difftest = Module(new DifftestArchIntRegState)
		difftest.io.clock := clock
		difftest.io.coreid := 0.U
		difftest.io.gpr := regfile
	}
}


import chisel3.stage.ChiselStage
object RegFileGenVerilog extends App {
	(new ChiselStage).emitVerilog(new RegFile, BUILD_ARG)
}