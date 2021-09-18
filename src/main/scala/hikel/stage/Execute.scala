// Execute stage of hikelchip core
// In this stage CPU will do things below:
// 		* execute the instruciton

package hikel.stage

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

import hikel._
import hikel.Config._
import hikel.fufu._

class ExecutePortIn extends StagePortIn {
	val rs1_data 		= UInt(MXLEN.W)
	val rs2_data 		= UInt(MXLEN.W)
	val imm 			= UInt(IMM.W)

	val uop 			= UInt(5.W)

	val rd_addr 		= UInt(RegFile.ADDR.W)
	val csr_addr 		= UInt(CsrFile.ADDR.W)

	val rd_wen 			= Bool()
	val csr_use 		= Bool()
	val lsu_use 		= Bool()

	val mret 			= Bool()
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
		val reg_csr_addr 	= RegInit(0.U(CsrFile.ADDR.W))
		val reg_rd_wen 		= RegInit(false.B)
		val reg_csr_use 	= RegInit(false.B)
		val reg_lsu_use 	= RegInit(false.B)
		val reg_mret 		= RegInit(false.B)
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
			reg_mret 		:= io.in.mret
		}

		// connect to alu
		io.alu.in.in0 	:= reg_rs1_data
		io.alu.in.in1 	:= reg_rs2_data
		io.alu.in.op 	:= Cat(reg_uop(4) && !reg_csr_use, 
				reg_uop(3) && !reg_csr_use, 
				reg_uop(2, 0))

		// connect to next stage
		io.out.rd_addr 	:= reg_rd_addr
		io.out.csr_addr := reg_csr_addr
		io.out.rd_wen 	:= reg_rd_wen
		io.out.csr_use 	:= reg_csr_use
		io.out.lsu_use 	:= reg_lsu_use
		io.out.mret 	:= reg_mret

		io.out.data1 	:= Mux(reg_csr_use, reg_rs1_data, io.alu.res)
		io.out.data2 	:= Mux(reg_uop(3), reg_rs2_data, io.alu.res)

		// bypass for regfile redirection
		addSource(io.out.rd_wen, "exec_rd_wen")
		addSource(io.out.rd_addr, "exec_rd_addr")
		addSource(io.out.data1, "exec_rd_data")

		// bypass for csrfile redirection
		addSource(io.out.csr_use, "exec_csr_use")
		addSource(io.out.csr_addr, "exec_csr_addr")
		addSource(io.out.data2, "exec_csr_data")
	}
}