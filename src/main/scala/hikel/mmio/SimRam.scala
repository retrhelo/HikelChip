// The interface for simulated RAM, using RAMHelper

package hikel.mmio

import chisel3._

import hikel.Config._
import hikel.fufu._

class RAMHelperPort extends Bundle {
	val clk 	= Input(Clock())
	val en 		= Input(Bool())
	val rIdx 	= Input(UInt(64.W))
	val rdata 	= Output(UInt(64.W))
	val wIdx 	= Input(UInt(64.W))
	val wdata 	= Input(UInt(64.W))
	val wmask 	= Input(UInt(64.W))
	val wen 	= Input(Bool())
}

class RAMHelper extends BlackBox {
	val io = IO(new RAMHelperPort)
}

class SimRamPort extends LsuUnitPort

class SimRam extends LsuUnit {
	override lazy val io = IO(new SimRamPort)

	val ram = Module(new RAMHelper)
	ram.io.clk := clock
	ram.io.en := true.B

	/* READ from RAM */
	io.read.ready := true.B
	ram.io.rIdx := io.read.bits.addr
	io.read.bits.rdata := ram.io.rdata

	/* WRITE to RAM */
	io.write.ready := true.B
	ram.io.wIdx := io.write.bits.addr
	ram.io.wdata := io.write.bits.wdata
	ram.io.wmask := io.write.bits.expand_wstrb
	ram.io.wen := io.write.valid
}