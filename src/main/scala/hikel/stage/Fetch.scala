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

	private val ENTRY_PC = "h8000_0000".U(PC.W)

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
		io.iread.valid := true.B
		io.iread.bits.addr := reg_pc
		io.iread.bits.op := "b10".U

		io.hshake := io.iread.valid && io.iread.ready

		// connect to Decode
		val data = io.iread.bits.data
		io.out.inst := Mux(reg_pc(2), data(63, 32), data(31, 0))

		// exception generation
		io.out.excp := io.iread.bits.excp
		io.out.code := Mux(io.iread.bits.misalign, INS_ADDR_MISALIGN, INS_ACCE)
	}
}