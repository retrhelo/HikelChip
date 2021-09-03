// The Write-Back Stage of 5-stage hikelchip RISC-V64 core
// In this stage CPU will do one of these things:
// 		* write result of Execute back to regfile
// And we are designing this stage to be EXTENSIVE to future 
// out-of-order instruction execution feature. 

package hikel.stage

import chisel3._
import chisel3.util._

import hikel.Config._

class WritePortIn extends Bundle {
	// write back information
	val rd_data 	= Input(UInt(MXLEN.W))
	val rd_addr 	= Input(UInt(log2Ceil(REG_NUM).W))
	val rd_wen 		= Input(Bool())

	// out-of-order execution
}

class WritePort extends StagePort {
	val in = new WritePortIn

	val rd_data = Output(UInt(MXLEN.W))
	val rd_addr = Output(UInt(log2Ceil(REG_NUM).W))
	val rd_wen = Output(Bool())

	// To indicate if all instructions are committed, thus 
	// the CPU is okay for trap handling. 
	val empty = Output(Bool())
}

class Write extends Stage {
	override lazy val io = IO(new WritePort)

	// As we don't implement fifo and out-of-order execution now, 
	// we should hardwire empty to true
	io.empty := true.B

	withReset(rst) {
		// pipeline registers
		val reg_rd_data 	= RegInit(0.U(MXLEN.W))
		val reg_rd_addr 	= RegInit(0.U(MXLEN.W))
		val reg_rd_wen 		= RegInit(false.B)

		// update registers
		when (enable) {
			reg_rd_data 	:= io.in.rd_data
			reg_rd_addr 	:= io.in.rd_addr
			reg_rd_wen 		:= io.in.rd_wen
		}

		io.rd_data 	:= reg_rd_data
		io.rd_addr 	:= reg_rd_addr
		io.rd_wen 	:= reg_rd_wen
	}
}


import chisel3.stage.ChiselStage
import hikel.Config.BUILD_ARG
object WriteGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Write, BUILD_ARG)
}