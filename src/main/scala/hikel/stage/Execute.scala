// Execute stage of hikelchip core
// In this stage CPU will do things below:
// 		* execute the instruciton

package hikel.stage

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.RegFile
import hikel.csr.Csr
import hikel.fufu._

class ExecutePortIn extends StagePortIn {
	val rs1_data 		= UInt(MXLEN.W)
	val rs2_data 		= UInt(MXLEN.W)
	val imm 			= UInt(IMM.W)

	val uop 			= UInt(5.W)

	val rd_addr 		= UInt(RegFile.ADDR.W)
	val csr_addr 		= UInt(Csr.ADDR.W)

	val rd_wen 			= Bool()
	val csr_use 		= Bool()
	val lsu_use 		= Bool()
}

class ExecutePort extends StagePort {
	override lazy val in = Input(new ExecutePortIn)
	override lazy val out = Output(new CommitPortIn)

	val alu = Flipped(new AluPort)
}

class Execute extends Stage {
	override lazy val io = IO(new ExecutePort)

	withReset(rst) {
		val reg_rs1_data 	= RegInit(0.U(MXLEN.W))
		val reg_rs2_data 	= RegInit(0.U(MXLEN.W))
		val reg_imm 		= RegInit(0.U(IMM.W))
		val reg_uop 		= RegInit(0.U(5.W))
		val reg_rd_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_csr_addr 	= RegInit(0.U(Csr.ADDR.W))
		val reg_rd_wen 		= RegInit(false.B)
		val reg_csr_use 	= RegInit(false.B)
		val reg_lsu_use 	= RegInit(false.B)
		when (enable) {
			reg_rs1_data 	:= io.in.rs1_data
			reg_rs2_data 	:= io.in.rs2_data
			reg_imm 		:= io.in.imm
			reg_uop 		:= io.in.uop
			reg_rd_addr 	:= io.in.rd_addr
			reg_csr_addr 	:= io.in.csr_addr
			reg_rd_wen 		:= io.in.rd_wen
			reg_csr_use 	:= io.in.csr_use
			reg_lsu_use 	:= io.in.lsu_use
		}

		// connect to alu
		io.alu.in.in0 	:= reg_rs1_data
		io.alu.in.in1 	:= reg_rs2_data
		io.alu.in.op 	:= reg_uop

		// connect to next stage
		io.out.rd_addr 	:= reg_rd_addr
		io.out.csr_addr := reg_csr_addr
		io.out.rd_wen 	:= reg_rd_wen
		io.out.csr_use 	:= reg_csr_use
		io.out.lsu_use 	:= reg_lsu_use
		io.out.data1 	:= io.alu.res
		// currently data2 is not used
		io.out.data2 	:= 0.U
	}
}


import chisel3.stage.ChiselStage
object ExecuteGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Execute, BUILD_ARG)
}