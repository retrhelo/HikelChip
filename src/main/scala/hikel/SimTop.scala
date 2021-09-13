package hikel

import chisel3._
import chisel3.util._

import Config._

import difftest._

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
		val hikel = Module(new HikelCore)
		hikel.io.icache_ready 		:= true.B
		hikel.io.icache_illegal 	:= true.B

		// RAM
		{
			val ram = Module(new RAMHelper)
			ram.io.clk 			:= clock
			ram.io.en 			:= true.B
			ram.io.rIdx 		:= (hikel.io.pc - BigInt("80000000", 16).U) >> 3
			ram.io.wIdx 		:= 0.U
			ram.io.wdata 		:= 0.U
			ram.io.wmask 		:= 0.U
			ram.io.wen 			:= false.B

			hikel.io.inst 		:= Mux(hikel.io.pc(2), 
					ram.io.rdata(63, 32), ram.io.rdata(31, 0)
			)
		}

		// we haven't implement CSR yet
		{
			val csr = Module(new DifftestCSRState)
			csr.io.clock 		:= clock
			csr.io.coreid 		:= 0.U
			csr.io.mstatus 		:= 0.U
			csr.io.mcause 		:= 0.U
			csr.io.mepc 		:= 0.U
			csr.io.sstatus 		:= 0.U
			csr.io.scause 		:= 0.U
			csr.io.sepc 		:= 0.U
			csr.io.satp 		:= 0.U
			csr.io.mip 			:= 0.U
			csr.io.mie 			:= 0.U
			csr.io.mscratch 	:= 0.U
			csr.io.sscratch 	:= 0.U
			csr.io.mideleg 		:= 0.U
			csr.io.medeleg 		:= 0.U
			csr.io.mtval 		:= 0.U
			csr.io.stval 		:= 0.U
			csr.io.mtvec 		:= 0.U
			csr.io.stvec 		:= 0.U
			csr.io.priviledgeMode := 0.U
		}
	}
}


import chisel3.stage.ChiselStage
object SimTopGenVerilog extends App {
	(new ChiselStage).emitVerilog(new SimTop, BUILD_ARG)
}