// The Execute Stage of 5-stage hikelchip RISC-V64 core
// In this stage CPU will do one of these things:
// 		* execute an arithmetic or a logical instruction
// 		* access data cache, either load or store
// 		* access CSR registers

package hikel.stage

import chisel3._
import chisel3.util._

import hikel.Config.MXLEN

import hikel.stage._
import hikel.Alu
import hikel.Alu._
import hikel.csr.Csr

object Execute {
	val SEL 		= 2
	val SEL_NONE 	= "b00".U
	val SEL_ALU 	= "b01".U
	val SEL_CSR 	= "b10".U
	val SEL_MEM 	= "b11".U
}

class ExecutePortIn extends Bundle {
	val in0 	= Input(UInt(MXLEN.W))		// rs1
	val in1 	= Input(UInt(MXLEN.W))		// rs2 or imm

	// Write Back 
	val rd_addr 	= Input(UInt(log2Ceil(MXLEN).W))
	val rd_data 	= Input(UInt(MXLEN.W))
	val rd_wen 		= Input(Bool())

	// ALU 
	val op 		= Input(UInt(3.W))
	val arith 	= Input(Bool())
	val word 	= Input(Bool())
	val shmt 	= Input(UInt(log2Ceil(MXLEN).W))

	// CSR
	val csr_addr 	= Input(UInt(Csr.ADDR_LEN.W))
	val csr_cmd 	= Input(UInt(2.W))

	// select output from multiple options
	val sel 	= Input(UInt(Execute.SEL.W))
}

class ExecutePort extends StagePort {
	val in = new ExecutePortIn
	val out = Flipped(new WritePortIn)
	// connect to CSR
	val csr_read = Input(UInt(MXLEN.W))
	val csr_addr = Output(UInt(MXLEN.W))
	val csr_data = Output(UInt(MXLEN.W))
	val csr_cmd = Output(UInt(2.W))
}

class Execute extends Stage {
	override lazy val io = new ExecutePort

	// ALU
	val alu = Module(new Alu)
	// CSR is not placed inside Execute, because it includes too many 
	// ports for CPU control and trap handling. Building CSR inside 
	// Execute will make the ExecutePort too complex.

	withReset(rst) {
		// pipeline registers

		val reg_in0 	= RegInit(0.U(MXLEN.W))
		val reg_in1 	= RegInit(0.U(MXLEN.W))
		reg_in0 		:= io.in.in0
		reg_in1 		:= io.in.in1

		// write back
		val reg_rd_addr 	= RegInit(0.U(log2Ceil(MXLEN).W))
		val reg_rd_data 	= RegInit(0.U(MXLEN.W))
		val reg_rd_wen 		= RegInit(false.B)
		reg_rd_addr 		:= io.in.rd_addr
		reg_rd_data 		:= io.in.rd_data
		reg_rd_wen 			:= io.in.rd_wen

		// ALU
		val reg_op 		= RegInit(0.U(3.W))
		val reg_arith 	= RegInit(false.B)
		val reg_word 	= RegInit(false.B)
		val reg_shmt 	= RegInit(0.U(log2Ceil(MXLEN).W))
		reg_op 			:= io.in.op
		reg_arith 		:= io.in.arith
		reg_word 		:= io.in.word
		reg_shmt 		:= io.in.shmt

		// connect to alu
		alu.io.in.in0 	:= reg_in0
		alu.io.in.in1 	:= reg_in1
		alu.io.in.op 	:= reg_op
		alu.io.in.arith := reg_arith
		alu.io.in.word 	:= reg_word
		alu.io.in.shmt 	:= reg_shmt

		// CSR
		val reg_csr_addr 	= RegInit(0.U(Csr.ADDR_LEN.W))
		val reg_csr_cmd 	= RegInit(0.U(2.W))
		reg_csr_addr 		:= io.in.csr_addr
		reg_csr_cmd 		:= io.in.csr_cmd

		// connect to CSR
		io.csr_addr 		:= reg_csr_addr
		io.csr_data 		:= reg_in0
		io.csr_cmd 			:= reg_csr_cmd

		// select 
		val reg_sel 	= RegInit(0.U(Execute.SEL.W))
		reg_sel 		:= io.in.sel

		// select output
		io.out.rd_addr 	:= reg_rd_addr
		io.out.rd_data 	:= MuxLookup(reg_sel, 0.U, Array(
			Execute.SEL_ALU -> alu.io.result, 
			Execute.SEL_CSR -> io.csr_read, 
			Execute.SEL_MEM -> 0.U, 
		))
	}
}


import chisel3.stage.ChiselStage
import hikel.Config.BUILD_ARG
object ExecuteGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Execute, BUILD_ARG)
}