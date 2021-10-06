// The top level of SoC simulation and commit. 

package hikel

import chisel3._
import chisel3.util._

import Config._
import fufu._
import fufu.mmio._
import fufu.mmio.MemLayout._
import fufu.mmio.axi.{
	RAddrPort, RDataPort, 
	WAddrPort, WDataPort, WRespPort, 
}
import util.ReadyValid

import difftest._

class SocAxiPort extends Bundle {
	// WADDR channel
	val awready 	= Input(Bool())
	val awvalid 	= Output(Bool())
	val awaddr 		= Output(UInt(32.W))
	val awid 		= Output(UInt(4.W))
	val awlen 		= Output(UInt(8.W))
	val awsize 		= Output(UInt(3.W))
	val awburst 	= Output(UInt(2.W))
	// WDATA channel
	val wready 		= Input(Bool())
	val wvalid 		= Output(Bool())
	val wdata 		= Output(UInt(64.W))
	val wstrb 		= Output(UInt(8.W))
	val wlast 		= Output(Bool())
	// WRESP channel
	val bready 		= Output(Bool())
	val bvalid 		= Input(Bool())
	val bresp 		= Input(UInt(2.W))
	val bid 		= Input(UInt(4.W))
	// RADDR channel
	val arready 	= Input(Bool())
	val arvalid 	= Output(Bool())
	val araddr 		= Output(UInt(32.W))
	val arid 		= Output(UInt(4.W))
	val arlen 		= Output(UInt(8.W))
	val arsize 		= Output(UInt(3.W))
	val arburst 	= Output(UInt(2.W))
	// RDATA channel
	val rready 		= Output(Bool())
	val rvalid 		= Input(Bool())
	val rresp 		= Input(UInt(2.W))
	val rdata 		= Input(UInt(64.W))
	val rlast 		= Input(Bool())
	val rid 		= Input(UInt(4.W))
}

class SocTop extends Module {
	// this is the desired name for ysyx project
	override def desiredName: String = "SocTop"

	val io = IO(new Bundle {
		val interrupt = Input(Bool()) 	// external interrupt
		val master = new SocAxiPort
		val slave = Flipped(new SocAxiPort)
	})

	val hart0 = Module(new HikelCore(0))
	val lsu = Module(new Lsu)

	// connect hart0 interrupt ports
	hart0.io.int_timer 		:= clint.io.do_timer(0)
	hart0.io.int_soft 		:= clint.io.do_soft(0)
	hart0.io.int_extern 	:= io.interrupt

	// connect hart0 with lsu
	hart0.io.iread 		<> lsu.io.iread
	hart0.io.dread 		<> lsu.io.dread
	hart0.io.dwrite 	<> lsu.io.dwrite

	lazy val clint = Module(new Clint(1, CLINT_BASE)); {
		lsu.io.clint <> clint.io
	}
	val axi_interface = Module(new AxiInterface); {
		// connect to lsu
		lsu.io.axi.read 	<> axi_interface.io.read
		lsu.io.axi.write 	<> axi_interface.io.write

		/* connect to AXI master port */

		// AXI4 WADDR channel
		axi_interface.io.axi.waddr.ready := io.master.awready
		io.master.awvalid 	:= axi_interface.io.axi.waddr.valid
		io.master.awaddr 	:= axi_interface.io.axi.waddr.bits.awaddr
		io.master.awid 		:= axi_interface.io.axi.waddr.bits.awid
		io.master.awlen 	:= axi_interface.io.axi.waddr.bits.awlen
		io.master.awsize 	:= axi_interface.io.axi.waddr.bits.awsize
		io.master.awburst 	:= axi_interface.io.axi.waddr.bits.awburst
	
		// AXI4 WDATA channel
		axi_interface.io.axi.wdata.ready := io.master.wready
		io.master.wvalid 	:= axi_interface.io.axi.wdata.valid
		io.master.wdata 	:= axi_interface.io.axi.wdata.bits.wdata
		io.master.wstrb 	:= axi_interface.io.axi.wdata.bits.wstrb
		io.master.wlast 	:= axi_interface.io.axi.wdata.bits.wlast

		// AXI4 WRESP channel
		io.master.bready := axi_interface.io.axi.wresp.ready
		axi_interface.io.axi.wresp.valid 		:= io.master.bvalid
		axi_interface.io.axi.wresp.bits.bresp 	:= io.master.bresp
		axi_interface.io.axi.wresp.bits.bid 	:= io.master.bid

		// AXI4 RADDR channel
		axi_interface.io.axi.raddr.ready := io.master.arready
		io.master.arvalid 	:= axi_interface.io.axi.raddr.valid
		io.master.araddr 	:= axi_interface.io.axi.raddr.bits.araddr
		io.master.arid 		:= axi_interface.io.axi.raddr.bits.arid
		io.master.arlen 	:= axi_interface.io.axi.raddr.bits.arlen
		io.master.arsize 	:= axi_interface.io.axi.raddr.bits.arsize
		io.master.arburst 	:= axi_interface.io.axi.raddr.bits.arburst

		// AXI4 RDATA channel
		io.master.rready := axi_interface.io.axi.rdata.ready
		axi_interface.io.axi.rdata.valid 		:= io.master.rvalid
		axi_interface.io.axi.rdata.bits.rresp 	:= io.master.rresp
		axi_interface.io.axi.rdata.bits.rdata 	:= io.master.rdata
		axi_interface.io.axi.rdata.bits.rlast 	:= io.master.rlast
		axi_interface.io.axi.rdata.bits.rid 	:= io.master.rid

		/* add default connection for slave port to avoid output hang-up */
		
		// AXI4 WADDR channel
		io.slave.awready 	:= false.B

		// AXI4 WDATA channel
		io.slave.wready 	:= false.B

		// AXI4 WRESP channel
		io.slave.bvalid 	:= false.B
		io.slave.bresp 		:= 0.U
		io.slave.bid 		:= 0.U

		// AXI4 RADDR channel
		io.slave.arready 	:= false.B

		// AXI4 RDATA channel
		io.slave.rvalid 	:= false.B
		io.slave.rresp 		:= 0.U
		io.slave.rdata 		:= 0.U
		io.slave.rlast 		:= false.B
		io.slave.rid 		:= 0.U
	}
}


object SocTopGenVerilog extends App {
	(new chisel3.stage.ChiselStage).emitVerilog(new SocTop, BUILD_ARG, Seq(
		firrtl.stage.RunFirrtlTransformAnnotation(new AddModulePrefix), 
		ModulePrefixAnnotation("ysyx_210727_"), 
	))
}