package hikel

import chisel3._
import chisel3.util._

import hikel.Config.{MXLEN, REG_NUM}

class RegFilePort extends Bundle {
	val rs1_addr 	= Input(UInt(log2Ceil(REG_NUM).W))
	val rs2_addr 	= Input(UInt(log2Ceil(REG_NUM).W))
	val rd_addr 	= Input(UInt(log2Ceil(REG_NUM).W))
	val wen 		= Input(Bool())
	val rd_data 	= Input(UInt(MXLEN.W))
	val rs1_data 	= Output(UInt(MXLEN.W))
	val rs2_data 	= Output(UInt(MXLEN.W))
}

class RegFile extends Module {
	val io = IO(new RegFilePort)

	val regfile = Reg(Vec(REG_NUM, UInt(MXLEN.W)))
	io.rs1_data := Mux(io.rs1_addr.orR, 0.U, regfile(io.rs1_addr))
	io.rs2_data := Mux(io.rs2_addr.orR, 0.U, regfile(io.rs2_addr))

	when (io.wen && io.rd_addr.orR) {
		regfile(io.rd_addr) := io.rd_data
	}
}


import chisel3.stage.ChiselStage
import hikel.Config.BUILD_ARG
object RegFileGenVerilog extends App {
	(new ChiselStage).emitVerilog(new RegFile, BUILD_ARG)
}