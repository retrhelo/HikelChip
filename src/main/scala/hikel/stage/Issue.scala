// The Issue Stage of 5-stage hikelchip RISC-V64 core
// In this stage CPU will do things below:
// 		* solve the problem of data conflicts(redirection)
// 		* decide on branch instruction

package hikel.stage

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.RegFile
import hikel.AluExt

class IssuePortIn extends StagePortIn {
	val rs1_addr 	= Input(UInt(RegFile.ADDR.W))
	val rs1_data 	= Input(UInt(MXLEN.W))
	val rs2_addr 	= Input(UInt(RegFile.ADDR.W))
	val rs2_data 	= Input(UInt(MXLEN.W))

	val rd_addr 	= Input(UInt(RegFile.ADDR.W))
	val rd_wen 		= Input(Bool())

	val imm 		= Input(UInt(IMM.W))
	val use_imm 	= Input(Bool())

	val uop 		= Input(UInt(UOP.W))

	// jal/jalr/branch
	val jb_ext 		= Input(new JumpBranchExt)

	// alu
	val alu_ext 	= Input(new AluExt)
}

class IssuePort extends StagePort {
	override lazy val in = new IssuePortIn
	override lazy val out = Flipped(new ExecutePortIn)

	// for data redirection
	val exec_rd_addr 	= Input(UInt(RegFile.ADDR.W))
	val exec_rd_wen 	= Input(Bool())
	val exec_rd_data 	= Input(UInt(MXLEN.W))
	val write_rd_addr 	= Input(UInt(RegFile.ADDR.W))
	val write_rd_wen 	= Input(Bool())
	val write_rd_data 	= Input(UInt(MXLEN.W))

	// for jal/jalr/branch
	val change_pc 		= Output(Bool())
	val new_pc 			= Output(UInt(MXLEN.W))
}

class Issue extends Stage {
	override lazy val io = IO(new IssuePort)

	withReset(rst) {
		val reg_rs1_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_rs1_data 	= RegInit(0.U(MXLEN.W))
		val reg_rs2_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_rs2_data 	= RegInit(0.U(MXLEN.W))
		when (enable) {
			reg_rs1_addr 	:= io.in.rs1_addr
			reg_rs1_data 	:= io.in.rs1_data
			reg_rs2_addr 	:= io.in.rs2_addr
			reg_rs2_data 	:= io.in.rs2_data
		}

		val rs1_use 		= 0.U =/= reg_rs1_addr
		val rs2_use 		= 0.U =/= reg_rs2_addr

		val reg_rd_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_rd_wen 		= RegInit(false.B)
		when (enable) {
			reg_rd_addr 	:= io.in.rd_addr
			reg_rd_wen 		:= io.in.rd_wen
		}

		val reg_uop 		= RegInit(0.U(UOP.W))
		when (enable) {
			reg_uop 		:= io.in.uop
		}

		val reg_imm 		= RegInit(0.U(IMM.W))
		val reg_use_imm 	= RegInit(false.B)
		when (enable) {
			reg_imm 		:= io.in.imm
			reg_use_imm 	:= io.in.use_imm
		}
		// sext imm
		val imm64 = Cat(Fill(MXLEN - IMM, reg_imm(IMM-1)), reg_imm)

		// redirect
		val real_rs1_data 	= Wire(UInt(MXLEN.W))
		val real_rs2_data 	= Wire(UInt(MXLEN.W));
		{
			val exec_conflict = rs1_use && 
					(reg_rs1_addr === io.exec_rd_addr) && 
					io.exec_rd_wen
			val write_conflict = rs1_use && 
					(reg_rs1_addr === io.write_rd_addr) && 
					io.write_rd_wen
			real_rs1_data := Mux(exec_conflict, io.exec_rd_data, 
					Mux(write_conflict, io.write_rd_data, reg_rs1_data))
		}
		{
			val exec_conflict = rs2_use && 
					(reg_rs2_addr === io.exec_rd_addr) && 
					io.exec_rd_wen
			val write_conflict = rs2_use && 
					(reg_rs2_addr === io.write_rd_addr) && 
					io.write_rd_wen
			real_rs2_data := Mux(exec_conflict, io.exec_rd_data, 
					Mux(write_conflict, io.write_rd_data, reg_rs2_data))
		}

		// decide on jump/branch
		val reg_jb_ext = RegInit({
			val tmp = Wire(new JumpBranchExt)
			tmp.jal 	:= false.B
			tmp.jalr 	:= false.B
			tmp.branch 	:= false.B
			tmp
		})
		when (enable) {
			reg_jb_ext := io.in.jb_ext
		}

		// branch
		val do_branch = Wire(Bool());
		{
			val not 	= reg_uop(0)
			val sign 	= reg_uop(1)
			val lt 		= reg_uop(2)
			val do_lt = Mux(sign, real_rs1_data.asSInt < real_rs2_data.asSInt, 
					real_rs1_data < real_rs2_data)
			val do_eql = real_rs1_data === real_rs2_data

			do_branch := not ^ Mux(lt, do_lt, do_eql)
		}

		// generate jb signals
		io.change_pc := reg_jb_ext.jal || reg_jb_ext.jalr || do_branch
		io.new_pc := Mux(reg_jb_ext.jalr, io.out.in0 & ~1.U, io.out.pc + imm64)

		// ALU
		val reg_alu_ext 	= RegInit({
			val tmp = Wire(new AluExt)
			tmp.arith 	:= false.B
			tmp.word 	:= false.B
			tmp.shmt 	:= 0.U
			tmp
		})
		when (enable) {
			reg_alu_ext 	:= io.in.alu_ext
		}

		// output
		io.out.in0 	:= real_rs1_data
		io.out.in1 	:= Mux(reg_use_imm, imm64, real_rs2_data)

		io.out.rd_addr 	:= reg_rd_addr
		io.out.rd_wen 	:= reg_rd_wen

		io.out.uop 		:= reg_uop

		io.out.alu_ext 	:= reg_alu_ext
	}
}

class JumpBranchExt extends Bundle {
	val jal 	= Bool()
	val jalr 	= Bool()
	val branch 	= Bool()
}


import chisel3.stage.ChiselStage
object IssueGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Issue, BUILD_ARG)
}