package hikel

import chisel3._
import chisel3.util._

object RegFile {
	val REG_NUM = 32
}

class RegFile(val xlen: Int) extends Module {
	import RegFile._

	val io = IO(new Bundle {
		val rs1 		= Input(UInt(log2Ceil(REG_NUM).W))
		val rs2 		= Input(UInt(log2Ceil(REG_NUM).W))
		val rd 			= Input(UInt(log2Ceil(REG_NUM).W))
		val reg_wen 	= Input(Bool())
		val rd_data 	= Input(UInt(xlen.W))

		val rs1_data 	= Output(UInt(xlen.W))
		val rs2_data 	= Output(UInt(xlen.W))
	})

	// val regfile = RegInit(VecInit((REG_NUM).U, 0.U(xlen.W)))
	val regfile = Mem(REG_NUM, UInt(xlen.W))
	regfile(0) := 0.U

	// read regfile
	io.rs1_data := Mux(io.rs1.orR, regfile(io.rs1), 0.U)
	io.rs2_data := Mux(io.rs2.orR, regfile(io.rs2), 0.U)

	// write to regfile
	when (io.reg_wen && io.rd.orR) {
		regfile(io.rd) := io.rd_data
	}
}

import chisel3.stage.ChiselStage

object RegFileGenVerilog extends App {
	(new ChiselStage).emitVerilog(new RegFile(64))
}