package hikel.axi

import chisel3._

// AXI4's reset use negative signal as active, and Chisel3's default reset 
// signal is positive-active. We can't use the default Module in following
// master/slave modules. Instead we wrap a new module providing clock and 
// reset signal. 
class AxiSlave extends Module {
	val io = IO(new AxiSlavePort)
	val resetn = !reset.asBool

	val interface = Wire(Flipped(new AxiSlavePort))
	interface <> io

	withReset(resetn) {
		val _slave = Module(new AxiSlaveReal)
		_slave.io <> interface
	}
}

class AxiSlaveReal extends Module {
	val io = IO(new AxiSlavePort)

	// TODO
}


import chisel3.stage.ChiselStage
object AxiSlaveGenVerilog extends App {
	(new ChiselStage).emitVerilog(new AxiSlave)
}