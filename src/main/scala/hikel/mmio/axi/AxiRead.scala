// READ part of Axi4 interface

package hikel.mmio.axi

import chisel3._
import chisel3.util._

import hikel.mmio.{AxiInterface => Axi}
import hikel.util.ReadyValid
import hikel.fufu.{LsuUnitRead}

class RAddrPort extends Bundle {
	val araddr 		= UInt(Axi.ADDR.W)
	val arid 		= UInt(Axi.ID.W)
	val arlen 		= UInt(8.W)
	val arsize 		= UInt(4.W)
	val arburst 	= UInt(Axi.BURST.W)
}

class RDataPort extends Bundle {
	val rresp 		= UInt(2.W)
	val rdata 		= UInt(Axi.DATA.W)
	val rlast 		= Bool()
	val rid 		= UInt(Axi.ID.W)
}

class AxiRead extends Module {
	val io = IO(new Bundle {
		val raddr = ReadyValid(Output(new RAddrPort))
		val rdata = Flipped(ReadyValid(Output(new RDataPort)))

		// the interface for CPU
		val lsu_read = Flipped(ReadyValid(new LsuUnitRead))
	})
}


object AxiReadGenVerilog extends App {
	(new chisel3.stage.ChiselStage).emitVerilog(new AxiRead)
}