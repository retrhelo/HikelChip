// The Execute Stage of 5-stage hikelchip RISC-V64 core
// In this stage CPU will do these things:
// 		* execute an arithmetic or a logical instruction
// 		* load from LSU
// 		* read from CSR

package hikel.stage

import chisel3._

import hikel.Config._
import hikel.RegFile
import hikel.{AluExt, AluPort}

class ExecutePortIn extends StagePortIn {
	val in0 		= Input(UInt(MXLEN.W))	// rs1 or imm(rs1)
	val in1 		= Input(UInt(MXLEN.W))	// rs2 or imm

	val rd_addr 	= Input(UInt(RegFile.ADDR.W))
	val rd_wen 		= Input(Bool())

	// Micro-Op
	val uop 		= Input(UInt(UOP.W))

	// ALU
	val alu_ext 	= Input(new AluExt)

	// CSR

	// LSU
}

class ExecutePort extends StagePort {
	override lazy val in = new ExecutePortIn
	override lazy val out = Flipped(new WritePortIn)

	// connect to ALU
	val alu = Flipped(new AluPort)

	// connect to CSR

	// connect to LSU
}

class Execute extends Stage {
	override lazy val io = IO(new ExecutePort)

	withReset(rst) {
		val reg_in0 	= RegInit(0.U(MXLEN.W))
		val reg_in1 	= RegInit(0.U(MXLEN.W))
		when (enable) {
			reg_in0 	:= io.in.in0
			reg_in1 	:= io.in.in1
		}

		val reg_rd_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_rd_wen 		= RegInit(false.B)
		when (enable) {
			reg_rd_addr 	:= io.in.rd_addr
			reg_rd_wen 		:= io.in.rd_wen
		}

		val reg_uop 		= RegInit(UInt(UOP.W))
		when (enable) {
			reg_uop 		:= io.in.uop
		}

		// ALU
		val reg_alu_ext 	= RegInit({
			val tmp 	= Wire(new AluExt)
			tmp.arith 	:= false.B
			tmp.word 	:= false.B
			tmp.shmt 	:= 0.U
			tmp
		})
		when (enable) {
			reg_alu_ext 	:= io.in.alu_ext
		}

		// connect ALU
		io.alu.in.in0 		:= reg_in0
		io.alu.in.in1 		:= reg_in1
		io.alu.in.op 		:= reg_uop
		io.alu.in.ext 		:= reg_alu_ext

		// connect to output
		io.out.rd_addr 		:= reg_rd_addr
		io.out.rd_wen 		:= reg_rd_wen
		io.out.data1 		:= io.alu.result
	}
}


import chisel3.stage.ChiselStage
object ExecuteGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Execute, BUILD_ARG)
}