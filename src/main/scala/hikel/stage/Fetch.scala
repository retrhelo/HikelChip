// The Fetch stage of hikelchip core
// Fetch instructions and pass it to Decode stage

package hikel.stage

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

import hikel.Config._
import hikel.csr.machine.MCause._
import hikel.fufu._
import hikel.util._

class FetchPort extends StagePort {
	override lazy val out = Output(new DecodePortIn)

	// connect to icache
	val iread = ReadyValid(new LsuRead)

	val hshake = Output(Bool())

	// extra pc option
	val change_pc 	= Input(Bool())
	val new_pc 		= Input(UInt(PC.W))
	val mret 		= Input(Bool())
}

class Fetch extends Stage {
	override lazy val io = IO(new FetchPort)

	// re-define enable and rst
	enable := io.enable
	rst := reset.asBool || io.clear

	private val ENTRY_PC = if (YSYX_DIFFTEST) {
		"h8000_0000".U(PC.W)
	}
	else {
		"h3000_0000".U(PC.W)
	}

	withReset(rst) {
		val reg_pc = RegInit(ENTRY_PC)
		val next_pc = reg_pc + 4.U
		val mtvec = WireInit(0.U(PC.W))
		val mepc = WireInit(0.U(PC.W))
		addSink(mtvec, "mtvec")
		addSink(mepc, "mepc")

		when (io.trap) {
			reg_pc := mtvec
		}
		.elsewhen (io.mret) {
			reg_pc := mepc
		}
		.elsewhen (io.change_pc) {
			reg_pc := io.new_pc
		}
		.elsewhen (enable) {
			reg_pc := next_pc
		}

		// connect to icache
		io.iread.valid := true.B
		io.iread.bits.addr := reg_pc
		io.iread.bits.op := "b10".U

		io.hshake := !io.iread.valid || (io.iread.valid && io.iread.ready)

		val reg_inst = RegInit(0.U(32.W))
		when (io.hshake) {
			reg_inst := io.iread.bits.data(31, 0)
		}

		// connect to Decode
		val data = io.iread.bits.data
		// io.out.inst := data(31, 0)
		io.out.inst := Mux(io.hshake, io.iread.bits.data(31, 0), reg_inst) 	// is this necessary?
		io.out.pc := reg_pc
		io.out.valid := true.B

		// exception generation
		io.out.excp := io.iread.bits.excp
		io.out.code := Mux(io.iread.bits.misalign, INS_ADDR_MISALIGN, INS_ACCE)
	}
}