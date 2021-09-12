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

	val hikel = Module(new HikelCore)

	// connect to hikel
	hikel.io.icache_illegal 	:= false.B
	hikel.io.icache_ready 		:= false.B
	hikel.io.inst 				:= 0.U

	io.uart.in.valid 	:= false.B
	io.uart.out.valid 	:= false.B
	io.uart.out.ch 		:= 0.U
}


import chisel3.stage.ChiselStage
object SimTopGenVerilog extends App {
	(new ChiselStage).emitVerilog(new SimTop, BUILD_ARG)
}