// Some common definitions for stages

package hikel.stage

import chisel3._

class StagePort extends Bundle {
	val enable 	= Input(Bool())		// enable update
	val trap 	= Input(Bool())		// a trap to handle!
}

class Stage extends Module {
	lazy val io = IO(new StagePort)

	val enable = Wire(Bool())
	val rst = Wire(Bool())
	enable := io.enable && !io.trap
	rst := reset.asBool || io.trap
}