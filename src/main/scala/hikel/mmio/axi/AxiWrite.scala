package hikel.mmio.axi

import chisel3._
import chisel3.util._

import hikel.mmio.{AxiInterface => Axi}
import hikel.util.ReadyValid
import hikel.fufu.{LsuUnitWrite}

class WAddrPort extends Bundle {
	val awaddr 		= UInt(Axi.ADDR.W)
	val awid 		= UInt(Axi.ID.W)
	val awlen 		= UInt(8.W)
	val awsize 		= UInt(3.W)
	val awburst 	= UInt(Axi.BURST.W)
}

class WDataPort extends Bundle {
	val wdata 		= UInt(Axi.DATA.W)
	val wstrb 		= UInt(Axi.STRB.W)
	val wlast 		= Bool()
}

class WRespPort extends Bundle {
	val bresp 		= UInt(2.W)
	val bid 		= UInt(Axi.ID.W)
}

class AxiWrite extends Module {
	val io = IO(new Bundle {
		val waddr = ReadyValid(Output(new WAddrPort))
		val wdata = ReadyValid(Output(new WDataPort))
		val wresp = Flipped(ReadyValid(Output(new WRespPort)))

		// interface to invalid
		val lsu_write = Flipped(ReadyValid(new LsuUnitWrite))
	})
}


object AxiWriteGenVerilog extends App {
	(new chisel3.stage.ChiselStage).emitVerilog(new AxiWrite)
}