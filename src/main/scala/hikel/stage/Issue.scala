// The Issue stage of hikelchip core
// In this stage CPU will do:
// 		* solve data conflicts
// 		* decide on branch and jump

package hikel.stage

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

import hikel._
import hikel.Config._
import hikel.fufu._

class IssuePortIn extends StagePortIn {
	val rs1_addr 		= UInt(MXLEN.W)
	val rs1_use 		= Bool()
	val rs2_addr 		= UInt(MXLEN.W)
	val rs2_use 		= Bool()
	val imm 			= UInt(IMM.W)

	val uop 			= UInt(5.W)

	val rd_addr 		= UInt(RegFile.ADDR.W)
	val csr_addr 		= UInt(CsrFile.ADDR.W)

	val rd_wen 			= Bool()
	val csr_use 		= Bool()
	val lsu_use 		= Bool()
	val jb_use 			= Bool()

	val mret 			= Bool()
}

class IssuePort extends StagePort {
	override lazy val in = Input(new IssuePortIn)
	override lazy val out = Output(new ExecutePortIn)

	// connect to regfile
	val regfile_read 	= Flipped(Vec(2, new RegFileRead))

	// connect to CSR
	val csrfile_read 	= Flipped(new CsrFileRead)

	// connect BrCond
	val brcond = Output(new BrCondPort)

	val lsu_write = Output(Bool())
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
		val reg_csr_addr 	= RegInit(0.U(CsrFile.ADDR.W))
		val reg_rd_wen 		= RegInit(false.B)
		val reg_csr_use 	= RegInit(false.B)
		val reg_lsu_use 	= RegInit(false.B)
		val reg_jb_use 		= RegInit(false.B)
		val reg_mret 		= RegInit(false.B)
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
			reg_mret 		:= io.in.mret
		}

		// connect to regfile
		io.regfile_read(0).addr := reg_rs1_addr
		io.regfile_read(1).addr := reg_rs2_addr

		val exec_rd_wen 	= WireInit(false.B)
		val exec_rd_addr 	= WireInit(0.U(RegFile.ADDR.W))
		val exec_rd_data 	= WireInit(0.U(MXLEN.W))
		val commit_rd_wen 	= WireInit(false.B)
		val commit_rd_addr 	= WireInit(0.U(RegFile.ADDR.W))
		val commit_rd_data 	= WireInit(0.U(MXLEN.W))
		addSink(exec_rd_wen, "exec_rd_wen")
		addSink(exec_rd_addr, "exec_rd_addr")
		addSink(exec_rd_data, "exec_rd_data")
		addSink(commit_rd_wen, "commit_rd_wen")
		addSink(commit_rd_addr, "commit_rd_addr")
		addSink(commit_rd_data, "commit_rd_data")

		// redirect
		val rs1_data = {
			val rs1_redir = reg_rs1_use && 0.U =/= reg_rs1_addr
			val exec_conflict = rs1_redir && exec_rd_wen && 
					exec_rd_addr === reg_rs1_addr
			val commit_conflict = rs1_redir && commit_rd_wen && 
					commit_rd_addr === reg_rs1_addr
			Mux(exec_conflict, exec_rd_data, 
					Mux(commit_conflict, commit_rd_data, 
					io.regfile_read(0).data))
		}
		val rs2_data = {
			val rs2_redir = reg_rs2_use && 0.U =/= reg_rs2_addr
			val exec_conflict = rs2_redir && exec_rd_wen && 
					exec_rd_addr === reg_rs2_addr
			val commit_conflict = rs2_redir && commit_rd_wen && 
					commit_rd_addr === reg_rs2_addr
			val rs2 = Mux(exec_conflict, exec_rd_data, 
					Mux(commit_conflict, commit_rd_data, 
					io.regfile_read(1).data))
			Mux(reg_rs2_use, rs2, reg_imm)
		}

		// connect to CSR
		io.csrfile_read.addr 	:= reg_csr_addr
		val csr_valid = io.csrfile_read.valid
		val csr_rdata = {	// redirection
			val exec_csr_use 	= WireInit(false.B)
			val exec_csr_addr 	= WireInit(0.U(CsrFile.ADDR.W))
			val exec_csr_data 	= WireInit(0.U(MXLEN.W))
			addSink(exec_csr_use, "exec_csr_use")
			addSink(exec_csr_addr, "exec_csr_addr")
			addSink(exec_csr_data, "exec_csr_data")
			val exec_conflict = exec_csr_use && exec_csr_addr === reg_csr_addr

			val commit_csr_use 		= WireInit(false.B)
			val commit_csr_addr 	= WireInit(0.U(CsrFile.ADDR.W))
			val commit_csr_data 	= WireInit(0.U(MXLEN.W))
			addSink(commit_csr_use, "commit_csr_use")
			addSink(commit_csr_addr, "commit_csr_addr")
			addSink(commit_csr_data, "commit_csr_data")
			val commit_conflict = commit_csr_use && commit_csr_addr === reg_csr_addr

			// do redirection
			Mux(exec_conflict, exec_csr_data, 
					Mux(commit_conflict, commit_csr_data, io.csrfile_read.data))
		}

		val csr_mask = WireInit(0.U(MXLEN.W))
		val csr_uop = WireInit(0.U(5.W));
		{
			val cmd = reg_uop(1, 0)
			val mask = Mux(reg_rs1_use, rs1_data, reg_imm)
			val csr_clear = CsrFile.CSR_CLEAR === cmd

			csr_mask := Mux(csr_clear, ~mask, mask)
			csr_uop := Cat(false.B, CsrFile.CSR_WRITE === cmd, 
					Mux(csr_clear, Alu.AND, Alu.OR))
		}

		// connect to BrCond
		io.brcond.in0 := rs1_data
		io.brcond.in1 := rs2_data
		io.brcond.pc := io.out.pc
		io.brcond.imm := reg_imm
		io.brcond.uop := reg_uop
		io.brcond.sel := reg_jb_use

		// connect to next stage
		io.out.rs1_data 	:= Mux(reg_csr_use, csr_rdata, 
				Mux(reg_rs1_use && !reg_jb_use, rs1_data, io.out.pc))
		io.out.rs2_data 	:= Mux(reg_csr_use, csr_mask, 
				Mux(reg_jb_use, 4.U, rs2_data))
		io.out.imm 			:= reg_imm
		io.out.uop 			:= Mux(reg_csr_use, csr_uop, Mux(reg_jb_use, Alu.ADD, reg_uop))
		io.out.rd_addr 		:= reg_rd_addr
		io.out.csr_addr 	:= reg_csr_addr
		io.out.rd_wen 		:= reg_rd_wen
		io.out.csr_use 		:= reg_csr_use
		io.out.lsu_use 		:= reg_lsu_use
		io.out.mret 		:= reg_mret

		io.lsu_write 		:= reg_lsu_use && io.out.uop(4)
	}
}