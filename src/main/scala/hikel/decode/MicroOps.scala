// The Micro Op used by Execute stage

package hikel.decode

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.RegFile

object MicroOp {
	val OP 		= 5
}

import MicroOp._
class MicroOp extends Bundle {
	val pc 			= UInt(PC.W)

	val op 			= UInt(OP.W)
	val rs1_addr 	= UInt(RegFile.ADDR.W)
	val rs2_addr 	= UInt(RegFile.ADDR.W)

	val imm 		= UInt(IMM.W)
	val imm_use 	= Bool()

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
		val out 	= Output(new MicroOp)
	})

	val decoder = Module(new InstDecode)
	decoder.io.inst := io.inst


}


import chisel3.stage.ChiselStage
object GenMicroOpGenVerilog extends App {
	(new ChiselStage).emitVerilog(new GenMicroOp, BUILD_ARG)
}