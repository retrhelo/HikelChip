// The Issue stage of hikelchip core
// In this stage CPU will do:
// 		* solve data conflicts
// 		* decide on branch and jump

package hikel.stage

import chisel3._
import chisel3.util._

import hikel._
import hikel.Config._
import hikel.csr._
import hikel.fufu._

class IssuePortIn extends StagePortIn {
	val rs1_addr 		= UInt(MXLEN.W)
	val rs1_use 		= Bool()
	val rs2_addr 		= UInt(MXLEN.W)
	val rs2_use 		= Bool()
	val imm 			= UInt(IMM.W)

	val uop 			= UInt(5.W)

	val rd_addr 		= UInt(RegFile.ADDR.W)
	val csr_addr 		= UInt(Csr.ADDR.W)

	val rd_wen 			= Bool()
	val csr_use 		= Bool()
	val lsu_use 		= Bool()
	val jb_use 			= Bool()
}

class IssuePort extends StagePort {
	override lazy val in = Input(new IssuePortIn)
	override lazy val out = Output(new ExecutePortIn)

	// connect to regfile
	val regfile_read 	= Flipped(Vec(2, new RegFileRead))

	// connect BrCond
	val brcond = Output(new BrCondPort)

	// redirect
	val exec_rd_addr 	= Input(UInt(RegFile.ADDR.W))
	val exec_rd_wen 	= Input(Bool())
	val exec_rd_data 	= Input(UInt(MXLEN.W))
	val commit_rd_addr 	= Input(UInt(RegFile.ADDR.W))
	val commit_rd_wen 	= Input(Bool())
	val commit_rd_data 	= Input(UInt(MXLEN.W))
}

class Issue extends Stage {
	override lazy val io = IO(new IssuePort)

	withReset(rst) {
		val reg_rs1_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_rs1_use 	= RegInit(false.B)
		val reg_rs2_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_rs2_use 	= RegInit(false.B)
		val reg_imm 		= RegInit(0.U(IMM.W))
		val reg_uop 		= RegInit(0.U(5.W))
		val reg_rd_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_csr_addr 	= RegInit(0.U(Csr.ADDR.W))
		val reg_rd_wen 		= RegInit(false.B)
		val reg_csr_use 	= RegInit(false.B)
		val reg_lsu_use 	= RegInit(false.B)
		val reg_jb_use 		= RegInit(false.B)
		when (enable) {
			reg_rs1_addr 	:= io.in.rs1_addr
			reg_rs1_use 	:= io.in.rs1_use
			reg_rs2_addr 	:= io.in.rs2_addr
			reg_rs2_use 	:= io.in.rs2_use
			reg_imm 		:= io.in.imm
			reg_uop 		:= io.in.uop
			reg_rd_addr 	:= io.in.rd_addr
			reg_csr_addr 	:= io.in.csr_addr
			reg_rd_wen 		:= io.in.rd_wen
			reg_csr_use 	:= io.in.csr_use
			reg_lsu_use 	:= io.in.lsu_use
			reg_jb_use 		:= io.in.jb_use
		}

		// connect to regfile
		io.regfile_read(0).addr := reg_rs1_addr
		io.regfile_read(1).addr := reg_rs2_addr

		// redirect
		val rs1_data = {
			val rs1_redir = reg_rs1_use && 0.U =/= reg_rs1_addr
			val exec_conflict = rs1_redir && io.exec_rd_wen && 
					io.exec_rd_addr === reg_rs1_addr
			val commit_conflict = rs1_redir && io.commit_rd_wen && 
					io.commit_rd_addr === reg_rs1_addr
			val rs1 = Mux(exec_conflict, io.exec_rd_data, 
					Mux(commit_conflict, io.commit_rd_data, 
					io.regfile_read(0).data))

			Mux(reg_rs1_use, rs1, io.out.pc)
		}
		val rs2_data = {
			val rs2_redir = reg_rs2_use && 0.U =/= reg_rs2_addr
			val exec_conflict = rs2_redir && io.exec_rd_wen && 
					io.exec_rd_addr === reg_rs2_addr
			val commit_conflict = rs2_redir && io.commit_rd_wen && 
					io.commit_rd_addr === reg_rs2_addr
			val rs2 = Mux(exec_conflict, io.exec_rd_data, 
					Mux(commit_conflict, io.commit_rd_data, 
					io.regfile_read(1).data))

			Mux(reg_rs2_use, rs2, reg_imm)
		}

		// connect to BrCond
		io.brcond.in0 := rs1_data
		io.brcond.in1 := rs2_data
		io.brcond.pc := io.out.pc
		io.brcond.imm := reg_imm
		io.brcond.uop := reg_uop
		io.brcond.sel := reg_jb_use

		// connect to next stage
		io.out.rs1_data 	:= rs1_data
		io.out.rs2_data 	:= rs2_data
		io.out.imm 			:= reg_imm
		io.out.uop 			:= reg_uop
		io.out.rd_addr 		:= reg_rd_addr
		io.out.csr_addr 	:= reg_csr_addr
		io.out.rd_wen 		:= reg_rd_wen
		io.out.csr_use 		:= reg_csr_use
		io.out.lsu_use 		:= reg_lsu_use
	}
}


import chisel3.stage.ChiselStage
object IssueGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Issue, BUILD_ARG)
}