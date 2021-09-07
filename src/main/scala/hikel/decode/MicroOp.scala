// The Micro Op used by Execute stage

package hikel.decode

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.RegFile
import hikel.csr.machine.MCause._

object MicroOp {
	val OP 		= 5
}

import MicroOp._
class MicroOp extends Bundle {
	val pc 			= UInt(PC.W)
	val code 		= UInt(EXCP_LEN.W)
	val excp 		= Bool()

	val op 			= UInt(OP.W)
	val rs1_addr 	= UInt(RegFile.ADDR.W)
	val rs2_addr 	= UInt(RegFile.ADDR.W)
	val rs1_use 	= Bool()
	val rs2_use 	= Bool()

	val imm 		= UInt(IMM.W)

	val rd_addr 	= UInt(RegFile.ADDR.W)
	val rd_wen 		= Bool()

	// Functional Unit Usage
	val lsu_use 	= Bool()
	val csr_use 	= Bool()
	val jb_use 		= Bool()
}

class GenMicroOp extends RawModule {
	val io = IO(new Bundle {
		val inst 	= Input(UInt(INST.W))
		val pc 		= Input(UInt(PC.W))
		val out 	= Output(new MicroOp)
	})

	val decoder = Module(new InstDecode)
	decoder.io.inst := io.inst

	// basic informations
	io.out.pc 		:= io.pc
	io.out.code 	:= Mux(decoder.io.out.illegal, ILL_INS, 0.U)
	io.out.excp 	:= decoder.io.out.illegal

	// operator
	io.out.op := Cat(
		decoder.io.out.store || decoder.io.out.jal || io.inst(3), 
		decoder.io.out.load || decoder.io.out.jalr || io.inst(30), 
		io.inst(14, 12)
	)

	io.out.rs1_addr 	:= io.inst(19, 15)
	io.out.rs2_addr 	:= io.inst(24, 20)

	io.out.rs1_use := decoder.io.out.rs1_sel
	io.out.rs2_use := decoder.io.out.rs2_sel

	// immediate
	val imm_gen = Module(new ImmGen)
	imm_gen.io.inst := io.inst
	imm_gen.io.itype := decoder.io.out.imm_type
	io.out.imm := imm_gen.io.imm32

	io.out.rd_addr := io.inst(11, 7)
	io.out.rd_wen := decoder.io.out.rd_wen

	io.out.lsu_use := decoder.io.out.load || decoder.io.out.store
	io.out.csr_use := decoder.io.out.csr
	io.out.jb_use := decoder.io.out.branch || 
			decoder.io.out.jal || 
			decoder.io.out.jalr
}


import chisel3.stage.ChiselStage
object GenMicroOpGenVerilog extends App {
	(new ChiselStage).emitVerilog(new GenMicroOp, BUILD_ARG)
}