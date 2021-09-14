// The Commit stage of hikelchip core
// In this stage CPU will do things below: 
// 		* write result of Execute back to regfile/csr/lsu
// 		* take in a trap if there is one

package hikel.stage

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

import hikel.Config._
import hikel.RegFile
import hikel.RegFileWrite
import hikel.csr.Csr

import difftest._

class CommitPortIn extends StagePortIn {
	val rd_addr 	= UInt(RegFile.ADDR.W)
	val csr_addr 	= UInt(Csr.ADDR.W)

	val rd_wen 		= Bool()
	val csr_use 	= Bool()
	val lsu_use 	= Bool()

	val data1 		= UInt(MXLEN.W)		// write to regfile
	val data2 		= UInt(MXLEN.W)		// write to CSR/LSU
}

class CommitPort extends StagePort {
	override lazy val in = Input(new CommitPortIn)
	val regfile_write = Flipped(new RegFileWrite)
}

class Commit extends Stage {
	override lazy val io = IO(new CommitPort)

	withReset(rst) {
		val reg_rd_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_csr_addr 	= RegInit(0.U(Csr.ADDR.W))
		val reg_rd_wen 		= RegInit(false.B)
		val reg_csr_use 	= RegInit(false.B)
		val reg_lsu_use 	= RegInit(false.B)
		val reg_data1 		= RegInit(0.U(MXLEN.W))
		val reg_data2 		= RegInit(0.U(MXLEN.W))
		when (enable) {
			reg_rd_addr 	:= io.in.rd_addr
			reg_csr_addr 	:= io.in.csr_addr
			reg_rd_wen 		:= io.in.rd_wen
			reg_csr_use 	:= io.in.csr_use
			reg_lsu_use 	:= io.in.lsu_use
			reg_data1 		:= io.in.data1
			reg_data2 		:= io.in.data2
		}

		// connect to regfile
		io.regfile_write.rd_wen 	:= reg_rd_wen
		io.regfile_write.rd_addr 	:= reg_rd_addr
		io.regfile_write.rd_data 	:= reg_data1

		// bypass for redirection
		addSource(io.regfile_write.rd_wen, "commit_rd_wen")
		addSource(io.regfile_write.rd_addr, "commit_rd_addr")
		addSource(io.regfile_write.rd_data, "commit_rd_data")
	}

	// for YSYX project
	if (YSYX_TEST_OUTPUT) {
		val difftest = Module(new DifftestInstrCommit)
		difftest.io.clock 	:= clock
		difftest.io.coreid 	:= 0.U
		difftest.io.index 	:= 0.U

		// difftest.io.valid 	:= RegNext(!(io.trap || io.in.excp))
		// difftest.io.valid 	:= true.B
		difftest.io.valid 	:= RegNext(io.out.pc >= BigInt("80000000", 16).U)
		difftest.io.pc 		:= RegNext(io.out.pc)
		difftest.io.instr 	:= RegNext(io.out.inst)
		difftest.io.skip 	:= false.B
		difftest.io.skip 	:= false.B
		difftest.io.isRVC 	:= false.B
		difftest.io.scFailed := false.B

		difftest.io.wen 	:= RegNext(io.regfile_write.rd_wen)
		difftest.io.wdata 	:= RegNext(io.regfile_write.rd_data)
		difftest.io.wdest 	:= RegNext(io.regfile_write.rd_addr)

		// connect to trap
		{
			val reg_cycleCnt 	= RegInit(0.U(MXLEN.W))
			val reg_instrCnt 	= RegInit(0.U(MXLEN.W))
			// update
			reg_cycleCnt 	:= reg_cycleCnt + 1.U
			when (enable && io.out.valid) {
				reg_instrCnt 	:= reg_instrCnt + 1.U
			}

			val trap = Module(new DifftestTrapEvent)
			trap.io.clock 		:= clock
			trap.io.coreid 		:= 0.U
			trap.io.valid 		:= 0x6b.U === io.out.inst
			trap.io.code 		:= 0.U
			trap.io.pc 			:= io.out.pc
			trap.io.cycleCnt 	:= reg_cycleCnt
			trap.io.instrCnt 	:= reg_instrCnt
		}
	}
}


import chisel3.stage.ChiselStage
object CommitGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Commit, BUILD_ARG)
}