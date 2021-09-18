// The Fetch stage of hikelchip core
// Fetch instructions and pass it to Decode stage

package hikel.stage

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

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
	val mret 		= Input(Bool())
}

class Fetch extends Stage {
	override lazy val io = IO(new FetchPort)

	// rewrite enable
	enable := io.enable && io.fetch_ready

	private val ENTRY_PC 	= "h8000_0000".U(PC.W)

	rst := reset.asBool || io.clear
	withReset(rst) {
		val reg_pc = RegInit(ENTRY_PC)
		val next_pc = reg_pc + 4.U
		val mtvec = WireInit(0.U(PC.W))
		val mepc = WireInit(0.U(PC.W))
		val do_mret = WireInit(false.B)
		addSink(mtvec, "mtvec")
		addSink(mepc, "mepc")
		addSink(do_mret, "do_mret")
		when (io.trap) {
			reg_pc := mtvec
		}
		.elsewhen (do_mret) {
			reg_pc := mepc
		}
		.elsewhen (enable) {
			reg_pc := Mux(io.change_pc, io.new_pc, 
					Mux(io.mret, mepc, next_pc))
		}

		// connect to icache
		io.fetch_pc := reg_pc

		// connect to Decode
		io.out.inst 	:= io.fetch_inst

		io.out.pc 		:= reg_pc
		io.out.excp 	:= io.fetch_illegal && io.out.valid
		io.out.code 	:= MCause.INS_ACCE
		io.out.valid 	:= RegNext(true.B)
	}
}