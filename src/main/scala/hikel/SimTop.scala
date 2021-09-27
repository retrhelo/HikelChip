package hikel

import chisel3._
import chisel3.util._

import Config._
import fufu._
import mmio._
import mmio.MemLayout._

import difftest._

class SimTop extends Module {
	val io = IO(new Bundle {
		val logCtrl = new LogCtrlIO
		val perfInfo = new PerfInfoIO
		val uart = new UARTIO
	})

	io.uart.in.valid 	:= false.B
	io.uart.out.valid 	:= false.B
	io.uart.out.ch 		:= 0.U

	val reg_delay_reset = RegNext(reset.asBool)
	withReset(reg_delay_reset) {
		val hart0 = Module(new HikelCore(0))
		val lsu = Module(new Lsu)

		// first connect hart0 with lsu
		hart0.io.iread <> lsu.io.iread
		hart0.io.dread <> lsu.io.dread
		hart0.io.dwrite <> lsu.io.dwrite

		val clint = Module(new Clint(1, CLINT_BASE))
		val ram = Module(new SimRam)

		lsu.io.clint <> clint.io
		lsu.io.ram <> ram.io

		// connect CLINT to hart0
		hart0.io.int_timer := clint.io.do_timer(0)
		hart0.io.int_soft := clint.io.do_soft(0)
		hart0.io.int_extern := false.B
	}
}


import chisel3.stage.ChiselStage
object SimTopGenVerilog extends App {
	(new ChiselStage).emitVerilog(new SimTop, BUILD_ARG)
}