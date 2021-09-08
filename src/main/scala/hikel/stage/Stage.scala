// Some common definitions for stages

package hikel.stage

import chisel3._

import hikel.Config._
import hikel.csr.machine.MCause._

// standard input of stage
class StagePortIn extends Bundle {
	val pc 		= UInt(PC.W)
	val excp 	= Bool()
	val code 	= UInt(EXCP_LEN.W)
}

// standard pipeline stage ports
class StagePort extends Bundle {
	lazy val in = Input(new StagePortIn)
	lazy val out = Output(new StagePortIn)

	val enable 	= Input(Bool())		// enable update
	val clear 	= Input(Bool())		// clear current stage
	val trap 	= Input(Bool())		// a trap to handle!
}

class Stage extends Module {
	lazy val io = IO(new StagePort)

	val enable = Wire(Bool())
	val rst = Wire(Bool())
	enable := io.enable
	rst := reset.asBool || io.clear || io.trap

	withReset(rst) {
		val reg_pc 		= RegInit(0.U)
		val reg_excp 	= RegInit(false.B)
		val reg_code 	= RegInit(0.U)
		when (enable) {
			reg_pc 		:= io.in.pc
			reg_excp 	:= io.in.excp
			reg_code 	:= io.in.code
		}

		io.out.pc 		:= reg_pc
		io.out.excp 	:= reg_excp
		io.out.code 	:= reg_code
	}
}

import chisel3.stage.ChiselStage
object StageGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Stage, BUILD_ARG)
}