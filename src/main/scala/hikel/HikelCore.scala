// Hikelchip Core. 
// This is the top level of a single hikelchip core, including basic 
// functional units like CSR and ALU. LSU is NOT INCLUDED here because 
// LSU may involve **MULTIPLE** cores and should be shared by them. 

package hikel

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

import Config._
import stage._
import fufu._
import util.ReadyValid

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
	fetch.io.change_pc 		:= brcond.io.change_pc && issue.io.enable
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
	fetch.io.enable := fetch.io.hshake && execute.io.hshake && commit.io.hshake && !lsu_write
	fetch.io.clear := false.B
	fetch.io.trap := trapctrl.io.do_trap

	// decode
	decode.io.enable := execute.io.hshake && commit.io.hshake && fetch.io.hshake
	decode.io.clear := brcond.io.change_pc || lsu_write
	decode.io.trap := trapctrl.io.do_trap || commit.io.mret

	// issue
	issue.io.enable := execute.io.hshake && commit.io.hshake && fetch.io.hshake
	issue.io.clear := brcond.io.change_pc
	issue.io.trap := trapctrl.io.do_trap || commit.io.mret

	// execute
	execute.io.enable := execute.io.hshake && commit.io.hshake
	execute.io.clear := !fetch.io.hshake
	execute.io.trap := trapctrl.io.do_trap || commit.io.mret

	// commit
	commit.io.enable := commit.io.hshake
	commit.io.clear := !execute.io.hshake
	commit.io.trap := trapctrl.io.do_trap || commit.io.mret

	// CSR
	private val csrfile = Module(new CsrFile(hartid))
	issue.io.csrfile_read <> csrfile.io.read
	commit.io.csrfile_write <> csrfile.io.write

	// LSU
	private lazy val lsu_write = WireInit(false.B)
	lsu_write := decode.io.lsu_write || 
			issue.io.lsu_write || 
			execute.io.lsu_write || 
			commit.io.lsu_write

	// connect to mip
	addSource(io.int_timer, "do_timer")
	addSource(io.int_soft, "do_soft")
	addSource(io.int_extern, "do_external")

	// trap control
	lazy val trapctrl = Module(new TrapCtrl)
	trapctrl.io.excp.do_excp 	:= commit.io.out.excp
	trapctrl.io.excp.code 		:= commit.io.out.code
	trapctrl.io.inst_done 		:= commit.io.out.valid && commit.io.hshake
}