package hikel

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

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

class SimTop extends Module {
	val io = IO(new Bundle {
		val logCtrl = new LogCtrlIO
		val perfInfo = new PerfInfoIO
		val uart = new UARTIO

		val memAXI_0 = new Bundle {
			val aw = ReadyValid(Output(new AxiWAddrWrapper))
			val w = ReadyValid(Output(new AxiWDataWrapper))
			val b = Flipped(ReadyValid(Output(new AxiWRespWrapper)))
			val ar = ReadyValid(Output(new AxiRAddrWrapper))
			val r = Flipped(ReadyValid(Output(new AxiRDataWrapper)))
		}
	})

	val ysyx_uart_valid = WireInit(false.B)
	val ysyx_uart_out = WireInit(0.U(MXLEN.W))
	if (YSYX_UART) {
		addSink(ysyx_uart_valid, "ysyx_uart_valid")
		addSink(ysyx_uart_out, "ysyx_uart_out")
	}

	io.uart.in.valid 	:= false.B
	io.uart.out.valid 	:= ysyx_uart_valid
	io.uart.out.ch 		:= ysyx_uart_out(7, 0)

	val reg_delay_reset = RegNext(reset.asBool)
	withReset(reg_delay_reset) {
		val hart0 = Module(new HikelCore(0))
		val lsu = Module(new Lsu)

		// first connect hart0 with lsu
		hart0.io.iread <> lsu.io.iread
		hart0.io.dread <> lsu.io.dread
		hart0.io.dwrite <> lsu.io.dwrite

		val clint = Module(new Clint(1, CLINT_BASE))
		val axi_interface = Module(new AxiInterface)

		lsu.io.clint <> clint.io
		lsu.io.axi.read <> axi_interface.io.read
		lsu.io.axi.write <> axi_interface.io.write

		// AXI4 RADDR channel
		io.memAXI_0.ar.valid := axi_interface.io.axi.raddr.valid
		axi_interface.io.axi.raddr.ready := io.memAXI_0.ar.ready
		io.memAXI_0.ar.bits.from(axi_interface.io.axi.raddr.bits)

		// AXI4 RDATA channel
		axi_interface.io.axi.rdata.valid := io.memAXI_0.r.valid
		io.memAXI_0.r.ready := axi_interface.io.axi.rdata.ready
		io.memAXI_0.r.bits.from(axi_interface.io.axi.rdata.bits)

		// AXI4 WADDR channel
		io.memAXI_0.aw.valid := axi_interface.io.axi.waddr.valid
		axi_interface.io.axi.waddr.ready := io.memAXI_0.aw.ready
		io.memAXI_0.aw.bits.from(axi_interface.io.axi.waddr.bits)

		// AXI4 WDATA channel
		io.memAXI_0.w.valid := axi_interface.io.axi.wdata.valid
		axi_interface.io.axi.wdata.ready := io.memAXI_0.w.ready
		io.memAXI_0.w.bits.from(axi_interface.io.axi.wdata.bits)

		// AXI4 WRESP channel
		axi_interface.io.axi.wresp.valid := io.memAXI_0.b.valid
		io.memAXI_0.b.ready := axi_interface.io.axi.wresp.ready
		io.memAXI_0.b.bits.from(axi_interface.io.axi.wresp.bits)

		// connect CLINT to hart0
		hart0.io.int_timer := clint.io.do_timer(0)
		hart0.io.int_soft := clint.io.do_soft(0)
		hart0.io.int_extern := false.B
	}
}

object AxiWrapper {
	val ADDR 	= 64
	val DATA 	= 64
	val ID 		= 4
	val USER 	= 1

	val SIZE_B 	= "b00".U
	val SIZE_H 	= "b01".U
	val SIZE_W 	= "b10".U
	val SIZE_D 	= "b11".U

	val REQ_READ 	= false.B
	val REQ_WRITE 	= true.B
}

class AxiWAddrWrapper extends Bundle {
	val addr 	= UInt(AxiWrapper.ADDR.W)
	val prot 	= UInt(3.W)
	val id 		= UInt(AxiWrapper.ID.W)
	val user 	= UInt(AxiWrapper.USER.W)
	val len 	= UInt(8.W)
	val size 	= UInt(3.W)
	val burst 	= UInt(2.W)
	val lock 	= Bool()
	val cache 	= UInt(4.W)
	val qos 	= UInt(4.W)

	def from(waddr: WAddrPort) {
		addr := waddr.awaddr
		prot := 0.U
		id := waddr.awid
		user := 0.U
		len := waddr.awlen
		size := waddr.awsize
		burst := waddr.awburst
		lock := false.B
		cache := 0.U
		qos := 0.U
	}
}

class AxiWDataWrapper extends Bundle {
	val data 	= UInt(AxiWrapper.DATA.W)
	val strb 	= UInt((AxiWrapper.DATA / 8).W)
	val last 	= Bool()

	def from(wdata: WDataPort) {
		data := wdata.wdata
		strb := wdata.wstrb
		last := wdata.wlast
	}
}

class AxiWRespWrapper extends Bundle {
	val resp 	= UInt(2.W)
	val id 		= UInt(AxiWrapper.ID.W)
	val user 	= UInt(AxiWrapper.USER.W)

	def from(wresp: WRespPort) {
		wresp.bresp := resp
		wresp.bid := id
	}
}

class AxiRAddrWrapper extends Bundle {
	val addr 	= UInt(AxiWrapper.ADDR.W)
	val prot 	= UInt(3.W)
	val id 		= UInt(AxiWrapper.ID.W)
	val user 	= UInt(AxiWrapper.USER.W)
	val len 	= UInt(8.W)
	val size 	= UInt(3.W)
	val burst 	= UInt(2.W)
	val lock 	= Bool()
	val cache 	= UInt(4.W)
	val qos 	= UInt(4.W)

	def from(raddr: RAddrPort) {
		addr := raddr.araddr
		prot := 0.U
		id := raddr.arid
		user := 0.U
		len := raddr.arlen
		size := raddr.arsize
		burst := raddr.arburst
		lock := false.B
		cache := false.B
		qos := 0.U
	}
}

class AxiRDataWrapper extends Bundle {
	val resp 	= UInt(2.W)
	val data 	= UInt(AxiWrapper.DATA.W)
	val last 	= Bool()
	val id 		= UInt(AxiWrapper.ID.W)
	val user 	= UInt(AxiWrapper.USER.W)

	def from(rdata: RDataPort) {
		rdata.rresp := resp
		rdata.rdata := data
		rdata.rlast := last
		rdata.rid := id
	}
}


import chisel3.stage.ChiselStage
object SimTopGenVerilog extends App {
	(new ChiselStage).emitVerilog(new SimTop, BUILD_ARG)
}