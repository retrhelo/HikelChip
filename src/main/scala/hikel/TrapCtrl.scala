// The control unit of trap

package hikel

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

import Config._
import csr.machine._

class TrapExcp extends Bundle {
	val do_excp 	= Bool()
	val code 		= UInt(MCause.EXCP_LEN.W)
}

class TrapCtrlPort extends Bundle {
	val excp 		= Input(new TrapExcp)
	val do_trap 	= Output(Bool())
}

class TrapCtrl extends RawModule {
	val io = IO(new TrapCtrlPort)

	// connect to mstatus
	val mstatus = WireInit(0.U(MXLEN.W))
	addSink(mstatus, "mstatus")
	val mstatus_ie = mstatus(MStatus.MIE)

	// connect to mie/mip
	val mie = WireInit(0.U(MXLEN.W))
	val mip = WireInit(0.U(MXLEN.W))
	addSink(mie, "mie")
	addSink(mip, "mip")

	// is there an interrupt to handler?
	val do_interrupt = Wire(Bool())
	val int_code = Wire(UInt(MCause.EXCP_LEN.W));
	{
		val do_timer = mie(MI.MTI).asBool && mip(MI.MTI).asBool
		val do_extern = mie(MI.MEI).asBool && mip(MI.MEI).asBool
		// It's very interesting that `soft` is a keyword in Verilog... 
		// Hence we have to use `do_soft` instead to avoid conflict with Verilator compiler. 
		val do_soft = mie(MI.MSI).asBool && mip(MI.MSI).asBool

		do_interrupt := mstatus(MStatus.MIE).asBool && (do_timer || do_extern || do_soft)
		// the priority is extern > soft > timer
		int_code := Mux(do_extern, MCause.MSINT, 
				Mux(do_soft, MCause.MSINT, 
				Mux(do_timer, MCause.MTINT, 0.U)))
	}
	io.do_trap := io.excp.do_excp || do_interrupt
	addSource(io.do_trap, "do_trap")

	// connect to mcause
	val mcause_code = Wire(UInt(MCause.EXCP_LEN.W))
	val mcause_int = Wire(Bool())
	// exception has higher priority
	mcause_code := Mux(io.excp.do_excp, io.excp.code, int_code)
	mcause_int := !io.excp.do_excp && do_interrupt
	addSource(mcause_code, "mcause_code")
	addSource(mcause_int, "mcause_int")
}