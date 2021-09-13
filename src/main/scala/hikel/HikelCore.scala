// The top-level module of Hikel chip 

package hikel

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.stage._
import hikel.fufu._

// difftest
import difftest._

class HikelCore extends Module {
	val io = IO(new Bundle {
		val pc 		= Output(UInt(PC.W))
		val icache_ready 	= Input(Bool())
		val icache_illegal 	= Input(Bool())
		val inst 			= Input(UInt(INST.W))
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
	io.pc := fetch.io.fetch_pc
	fetch.io.fetch_inst 	:= io.inst
	fetch.io.fetch_ready 	:= io.icache_ready
	fetch.io.fetch_illegal 	:= io.icache_illegal
	// jump/branch signals
	fetch.io.change_pc 		:= brcond.io.change_pc
	fetch.io.new_pc 		:= brcond.io.new_pc

	// no extra connections for decode stage

	// extra connections for issue
	private lazy val regfile = Module(new RegFile)
	regfile.io.read <> issue.io.regfile_read
	private lazy val brcond = Module(new BrCond)
	brcond.io.in <> issue.io.brcond
	issue.io.exec_rd_addr 		:= execute.io.out.rd_addr
	issue.io.exec_rd_wen 		:= execute.io.out.rd_wen
	issue.io.exec_rd_data 		:= execute.io.out.data1
	issue.io.commit_rd_addr 	:= commit.io.regfile_write.rd_addr
	issue.io.commit_rd_wen 		:= commit.io.regfile_write.rd_wen
	issue.io.commit_rd_data 	:= commit.io.regfile_write.rd_data

	// extra connections for execute
	val alu = Module(new Alu)
	alu.io <> execute.io.alu

	// extra connections for commit
	regfile.io.write <> commit.io.regfile_write

	/* stage control signals */

	// fetch
	fetch.io.enable := true.B
	fetch.io.clear := false.B
	fetch.io.trap := false.B

	// decode
	decode.io.enable := true.B
	decode.io.clear := brcond.io.change_pc
	decode.io.trap := false.B

	// issue
	issue.io.enable := true.B
	issue.io.clear := brcond.io.change_pc
	issue.io.trap := false.B

	// execute
	execute.io.enable := true.B
	execute.io.clear := false.B
	execute.io.trap := false.B

	// commit
	commit.io.enable := true.B
	commit.io.clear := false.B
	commit.io.trap := false.B
}


import chisel3.stage.ChiselStage
object HikelGenVerilog extends App {
	(new ChiselStage).emitVerilog(new HikelCore, BUILD_ARG)
}