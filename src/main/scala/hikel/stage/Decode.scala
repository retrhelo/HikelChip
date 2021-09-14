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

	withReset(rst) {
		// different from other stages, module ImmGen and InstDecode 
		// are embedded into Decode stage. 

		// connect to InstDecode
		val decoder = Module(new InstDecode)
		decoder.io.inst := io.out.inst

		// connect to ImmGen
		val imm_gen = Module(new ImmGen)
		imm_gen.io.inst := io.out.inst
		imm_gen.io.itype := decoder.io.out.imm_type
		// sign-extend imm generated
		val imm = Cat(Fill(MXLEN - 32, imm_gen.io.imm32(31)), imm_gen.io.imm32)

		// generate signals used by Issue
		io.out.rs1_addr 	:= Mux(decoder.io.out.lui, 0.U, io.out.inst(19, 15))
		io.out.rs1_use 		:= decoder.io.out.rs1_use
		io.out.rs2_addr 	:= io.out.inst(24, 20)
		io.out.rs2_use 		:= decoder.io.out.rs2_use
		io.out.imm 			:= imm
		// Micro-Op
		io.out.uop := Cat(
			decoder.io.out.store || decoder.io.out.jal || decoder.io.out.word, 
			decoder.io.out.load || decoder.io.out.jalr || decoder.io.out.arith, 
			Mux(decoder.io.out.lui || decoder.io.out.auipc, 0.U, io.out.inst(14, 12))
		)
		io.out.rd_addr := io.out.inst(11, 7)
		io.out.csr_addr := io.out.inst(31, 20)
		// component usage
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