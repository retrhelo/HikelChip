// Some common definitions for stages

package hikel.stage

import chisel3._

import hikel.Config._
import hikel.csr.machine.MCause._

// standard pipeline stage ports
class StagePort extends Bundle {
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
}