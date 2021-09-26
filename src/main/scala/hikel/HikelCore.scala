// The top-level module of Hikel chip 

package hikel

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.stage._
import hikel.fufu._
import hikel.util.ReadyValid

class HikelCore(val hartid: Int) extends Module {
	val io = IO(new Bundle {
		val iread = ReadyValid(new LsuRead)
		val dread = ReadyValid(new LsuRead)
		val dwrite = ReadyValid(new LsuWrite)

		val int_soft = Input(Bool())
		val int_timer = Input(Bool())
		val int_extern = Input(Bool())
	})

	// stages
	val fetch 		= Module(new Fetch)
	val decode 		= Module(new Decode)
	val issue 		= Module(new Issue)
	val execute 	= Module(new Execute)
	val commit 		= Module(new Commit)

	// we have to provide some default connections for fetch
	fetch.io.in.pc 	:= 0.U
	fetch.io.in.excp := false.B
	fetch.io.in.code := 0.U
	fetch.io.in.valid := true.B
	fetch.io.in.inst := 0.U

	// hookup
	decode.io.in <> fetch.io.out
	issue.io.in <> decode.io.out
	execute.io.in <> issue.io.out
	commit.io.in <> execute.io.out

	// extra connections for Fetch
	// connect to icache
	fetch.io.iread <> io.iread
	// jump/branch signals
	fetch.io.change_pc 		:= brcond.io.change_pc
	fetch.io.new_pc 		:= brcond.io.new_pc
	// mret
	fetch.io.mret 			:= commit.io.mret

	// no extra connections for decode stage

	// extra connections for issue
	private lazy val regfile = Module(new RegFile)
	regfile.io.read <> issue.io.regfile_read
	private lazy val brcond = Module(new BrCond)
	brcond.io.in <> issue.io.brcond

	// extra connections for execute
	val alu = Module(new Alu)
	alu.io <> execute.io.alu
	execute.io.dread <> io.dread

	// extra connections for commit
	regfile.io.write <> commit.io.regfile_write
	commit.io.dwrite <> io.dwrite

	/* stage control signals */

	// fetch
	fetch.io.enable := io.iread.ready && fetch.io.hshake && execute.io.hshake && commit.io.hshake
	fetch.io.clear := false.B
	fetch.io.trap := trapctrl.io.do_trap

	// decode
	decode.io.enable := execute.io.hshake && commit.io.hshake
	decode.io.clear := brcond.io.change_pc || commit.io.mret || !io.iread.ready || !fetch.io.hshake
	decode.io.trap := trapctrl.io.do_trap

	// issue
	issue.io.enable := execute.io.hshake && commit.io.hshake
	issue.io.clear := brcond.io.change_pc || commit.io.mret
	issue.io.trap := trapctrl.io.do_trap

	// execute
	execute.io.enable := execute.io.hshake && commit.io.hshake
	execute.io.clear := commit.io.mret
	execute.io.trap := trapctrl.io.do_trap

	// commit
	commit.io.enable := commit.io.hshake
	commit.io.clear := commit.io.mret || !execute.io.hshake
	commit.io.trap := trapctrl.io.do_trap

	// CSR
	private val csrfile = Module(new CsrFile(hartid))
	issue.io.csrfile_read <> csrfile.io.read
	commit.io.csrfile_write <> csrfile.io.write
	// trap control
	lazy val trapctrl = Module(new TrapCtrl)
	trapctrl.io.excp.do_excp 	:= commit.io.out.excp
	trapctrl.io.excp.code 		:= commit.io.out.code
}


import chisel3.stage.ChiselStage
object HikelCoreGenVerilog extends App {
	(new ChiselStage).emitVerilog(new HikelCore(0))
}