// The Decode Stage of hikelchip core
// In this stage CPU will do things below: 
// 		* decode input instruction
// 		* raise ILLEGAL_INSTRUCTION exception if the inst is

package hikel.stage

import chisel3._
import chisel3.util._

import hikel._
import hikel.Config._
import hikel.decode._
import hikel.csr.machine._

class DecodePortIn extends StagePortIn {}

class DecodePort extends StagePort {
	override lazy val in = Input(new DecodePortIn)
	override lazy val out = Output(new IssuePortIn)
}

class Decode extends Stage {
	override lazy val io = IO(new DecodePort)

	// RISC-V use addi zero, zero, 0 as its `nop` instruction
	val NOP = "h0000_0013".U(INST.W)

	withReset(rst) {
		val reg_inst 	= RegInit(NOP)
		when (enable) {
			reg_inst 	:= io.in.inst
		}

		// different from other stages, module ImmGen and InstDecode 
		// are embedded into Decode stage. 

		// connect to InstDecode
		val decoder = Module(new InstDecode)
		decoder.io.inst := reg_inst

		// connect to ImmGen
		val imm_gen = Module(new ImmGen)
		imm_gen.io.inst := reg_inst
		imm_gen.io.itype := decoder.io.out.imm_type
		// sign-extend imm generated
		val imm = Cat(Fill(MXLEN - 32, imm_gen.io.imm32(31)), imm_gen.io.imm32)

		// generate signals used by Issue
		io.out.rs1_addr 	:= Mux(decoder.io.out.lui, 0.U, reg_inst(19, 15))
		io.out.rs1_use 		:= decoder.io.out.rs1_use
		io.out.rs2_addr 	:= reg_inst(24, 20)
		io.out.rs2_use 		:= decoder.io.out.rs2_use
		io.out.imm 			:= imm
		// Micro-Op
		io.out.uop := Cat(
			decoder.io.out.store || decoder.io.out.jal || decoder.io.out.word, 
			decoder.io.out.load || decoder.io.out.jalr || decoder.io.out.arith, 
			Mux(decoder.io.out.lui || decoder.io.out.auipc, 0.U, reg_inst(14, 12))
		)
		io.out.rd_addr := reg_inst(11, 7)
		io.out.csr_addr := reg_inst(31, 20)
		// FU usage
		io.out.rd_wen 	:= decoder.io.out.rd_wen
		io.out.csr_use 	:= decoder.io.out.csr
		io.out.lsu_use 	:= decoder.io.out.load || decoder.io.out.store
		io.out.jb_use 	:= decoder.io.out.branch || 
				decoder.io.out.jal || decoder.io.out.jalr

		// re-generate exception signals
		io.out.excp 	:= io.in.excp || decoder.io.out.illegal
		// as long as io.out.excp stays unasserted, the value in code is meaningless
		io.out.code 	:= Mux(io.in.excp, io.in.code, MCause.ILL_INS)
	}
}


import chisel3.stage.ChiselStage
object DecodeGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Decode, BUILD_ARG)
}