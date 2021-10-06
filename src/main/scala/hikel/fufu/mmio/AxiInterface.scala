package hikel.fufu.mmio

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.fufu.{
	LsuUnitPort, LsuUnit, 
}
import axi._
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

class AxiMasterPort extends Bundle {
	// read channels
	val raddr = ReadyValid(Output(new RAddrPort))
	val rdata = Flipped(ReadyValid(Output(new RDataPort)))
	// write channels
	val waddr = ReadyValid(Output(new WAddrPort))
	val wdata = ReadyValid(Output(new WDataPort))
	val wresp = Flipped(ReadyValid(Output(new WRespPort)))
}

class AxiInterfacePort extends LsuUnitPort 
class AxiInterface extends LsuUnit {
	override lazy val io = IO(new LsuUnitPort {
		val axi = new AxiMasterPort
	})

	private val id = 0

	/* AXI4 READ */
	val axi_read = Module(new AxiRead(id))
	// connect to it
	io.read <> axi_read.io.lsu_read
	io.axi.raddr <> axi_read.io.raddr
	io.axi.rdata <> axi_read.io.rdata

	/* AXI4 WRITE */
	val axi_write = Module(new AxiWrite(id))
	// connect to it
	io.write <> axi_write.io.lsu_write
	io.axi.waddr <> axi_write.io.waddr
	io.axi.wdata <> axi_write.io.wdata
	io.axi.wresp <> axi_write.io.wresp
}