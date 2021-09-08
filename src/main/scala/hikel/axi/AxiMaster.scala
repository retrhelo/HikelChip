package hikel.axi

import chisel3._

// AXI4's reset use negative signal as active, and Chisel3's default reset 
// signal is positive-active. We can't use the default Module in following
// master/slave modules. Instead we wrap a new module providing clock and 
// reset signal. 
class AxiMaster extends Module {
	val io = IO(new AxiMasterPort)
	val resetn = !reset.asBool		// reverse reset signal, so it will be negative-active

	val interface = Wire(Flipped(new AxiMasterPort))
	interface <> io
	withReset(resetn) {
		val _master = new AxiMasterReal
		_master.io <> interface
	}
}

private class AxiMasterReal extends Module {
	val io = IO(new AxiMasterPort)

	// TODO
}


import chisel3.stage.ChiselStage
object AxiMasterGenVerilog extends App {
	(new ChiselStage).emitVerilog(new AxiMaster)
}