// The Fetch stage of hikelchip core
// Fetch instructions and pass it to Decode stage

package hikel.stage

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.csr.machine._

class FetchPort extends StagePort {
	override lazy val out = Output(new DecodePortIn)

	// connect to icahce
	// Currently implemented simply, as we're using simulated environment
	val fetch_pc 		= Output(UInt(PC.W))
	val fetch_inst 		= Input(UInt(INST.W))
	val fetch_ready 	= Input(Bool())
	val fetch_illegal 	= Input(Bool())

	// extra-pc option
	val change_pc 	= Input(Bool())
	val new_pc 		= Input(UInt(PC.W))
}

class Fetch extends Stage {
	override lazy val io = IO(new FetchPort)

	// rewrite enable
	enable := io.enable && io.fetch_ready

	private val ENTRY_PC 	= "h8000_0000".U(PC.W)
	// private val ENTRY_PC 	= "h7fff_fffc".U(PC.W)

	withReset(rst) {
		val reg_pc = RegInit(ENTRY_PC)
		val next_pc = reg_pc + 4.U
		when (enable) {
			reg_pc := Mux(io.change_pc, io.new_pc, next_pc)
		}

		// connect to icache
		io.fetch_pc := reg_pc

		// connect to Decode
		io.out.inst 	:= io.fetch_inst

		io.out.pc 		:= reg_pc
		io.out.excp 	:= io.fetch_illegal
		io.out.code 	:= Mux(io.fetch_illegal, MCause.INS_ACCE, 0.U)
		io.out.valid 	:= RegNext(true.B)
	}
}


import chisel3.stage.ChiselStage
object FetchGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Fetch, BUILD_ARG)
}