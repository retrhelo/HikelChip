// The Decode Stage of 5-stage hikelchip RISC-V64 core 
// In this stage CPU will do things below:
// 		* take in instruction and generate control signals

package hikel.stage

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.{RegFile, RegFileRead}

class DecodePortIn extends StagePortIn {
	val inst 	= Input(UInt(INST.W))
}

class DecodePort extends StagePort {
	override lazy val in = new DecodePortIn
	override lazy val out = Flipped(new IssuePortIn)

	// connect to regfile
	val regfile = Flipped(new RegFileRead)

	// connect to CSR
}

class Decode extends Stage {
	override lazy val io = IO(new DecodePort)

	withReset (rst) {
		val reg_inst 	= RegInit(0.U(INST.W))
		when (enable) {
			reg_inst 	:= io.in.inst
		}
	}
}


import chisel3.stage.ChiselStage
object DecodeGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Decode, BUILD_ARG)
}