// Some common definitions for stages

package hikel.stage

import chisel3._

import hikel.Config.MXLEN
import hikel.csr.machine.MCause._

class StagePortIn extends Bundle {
	val pc 			= Input(UInt(MXLEN.W))		// PC of current instruction
	val excp 		= Input(Bool())				// cause an exception
	val code 		= Input(UInt(EXCP_LEN.W))	// exception code
}

// standard pipeline stage ports
class StagePort extends Bundle {
	lazy val in = new StagePortIn
	lazy val out = Flipped(new StagePortIn)
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
		val reg_pc 		= RegInit(0.U(MXLEN.W))
		val reg_excp 	= RegInit(false.B)
		val reg_code 	= RegInit(0.U(EXCP_LEN.W))

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