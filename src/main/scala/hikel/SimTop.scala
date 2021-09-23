package hikel

import chisel3._
import chisel3.util._

import Config._

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
		val hikel = Module(new HikelCore(0))
	}
}


import chisel3.stage.ChiselStage
object SimTopGenVerilog extends App {
	(new ChiselStage).emitVerilog(new SimTop, BUILD_ARG)
}