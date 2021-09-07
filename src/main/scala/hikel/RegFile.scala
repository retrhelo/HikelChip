package hikel

import chisel3._
import chisel3.util._

import hikel.Config._

object RegFile {
	val NUM 	= 32 + Rob.NUM
	val ADDR 	= log2Ceil(NUM)
}

class RegFileRead extends Bundle {
	val rs1_addr 	= Input(UInt(RegFile.ADDR.W))
	val rs2_addr 	= Input(UInt(RegFile.ADDR.W))
	val rs1_data 	= Output(UInt(MXLEN.W))
	val rs2_data 	= Output(UInt(MXLEN.W))
}

class RegFileWrite extends Bundle {
	val rd_addr 	= Input(UInt(RegFile.ADDR.W))
	val rd_data 	= Input(UInt(MXLEN.W))
	val rd_wen 		= Input(Bool())
}

class RegFilePort extends Bundle {
	val read = new RegFileRead
	val write = new RegFileWrite
}

class RegFile extends Module {
	val io = IO(new RegFilePort)

	val regfile = Reg(Vec(RegFile.NUM, UInt(MXLEN.W)))
	io.read.rs1_data := Mux(io.read.rs1_addr.orR, 0.U, regfile(io.read.rs1_addr))
	io.read.rs2_data := Mux(io.read.rs2_addr.orR, 0.U, regfile(io.read.rs2_addr))

	when (io.write.rd_wen && io.write.rd_addr.orR) {
		regfile(io.write.rd_addr) := io.write.rd_data
	}
}


import chisel3.stage.ChiselStage
import hikel.Config.BUILD_ARG
object RegFileGenVerilog extends App {
	(new ChiselStage).emitVerilog(new RegFile, BUILD_ARG)
}