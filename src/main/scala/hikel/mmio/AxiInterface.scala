package hikel.mmio

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.fufu.{
	LsuUnitRead, LsuUnitWrite, 
}
import hikel.util.ReadyValid

object AxiInterface {
	val ADDR = 32
	val DATA = 64
	val STRB = DATA / 8
	val ID = 4
	val BURST = 2

	val BURST_FIXED = 0.U
	val BURST_INCR = 1.U
}
class AxiInterface extends Module {
	val io = IO(new Bundle {
		val read = Flipped(ReadyValid(new LsuUnitRead))
		val write = Flipped(ReadyValid(new LsuUnitWrite))

		// AXI4 interface
		
	})
}