package hikel.fufu.lsu

import chisel3._

import hikel.Config._
import hikel.fufu._

class RAMHelper extends BlackBox {
	val io = IO(new Bundle {
		val clk = Input(Clock())
		val en = Input(Bool())
		val rIdx = Input(UInt(64.W))
		val rdata = Output(UInt(64.W))
		val wIdx = Input(UInt(64.W))
		val wdata = Input(UInt(64.W))
		val wmask = Input(UInt(64.W))
		val wen = Input(Bool())
	})
}

class SimRamLsu extends LsuModule {
	val read = new LsuRead

	// use arbitor to select on iread and dread
	val arbiter = Module(new RamArbiter)
	arbiter.io.iread 	<> Flipped(io.iread)
	arbiter.io.dread 	<> Flipped(io.dread)
	read <> arbiter.io.out

	// connect to RAMHelper
	val ram = Module(new RAMHelper)
	ram.io.clk := clock
	// read ports
	ram.io.rIdx := (read.addr - BigInt("80000000", 16).U) >> 3
	read.rdata := ram.io.rdata
	ram.io.en := read.rvalid
	read.rready := true.B
	// write ports
	ram.io.wIdx := (io.dwrite.addr - BigInt("80000000", 16).U) >> 3
	ram.io.wdata := io.dwrite.wdata
	ram.io.wmask := LsuWrite.expand(io.dwrite.wstrb)
	ram.io.wen := io.dwrite.wvalid
	io.dwrite.wready := true.B
}