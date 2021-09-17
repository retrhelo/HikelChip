// The Commit stage of hikelchip core
// In this stage CPU will do things below: 
// 		* write result of Execute back to regfile/csr/lsu
// 		* take in a trap if there is one

package hikel.stage

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

import hikel._
import hikel.Config._

import difftest._

class CommitPortIn extends StagePortIn {
	val rd_addr 	= UInt(RegFile.ADDR.W)
	val csr_addr 	= UInt(CsrFile.ADDR.W)

	val rd_wen 		= Bool()
	val csr_use 	= Bool()
	val lsu_use 	= Bool()

	val data1 		= UInt(MXLEN.W)		// write to regfile
	val data2 		= UInt(MXLEN.W)		// write to CSR/LSU
}

class CommitPort extends StagePort {
	override lazy val in = Input(new CommitPortIn)
	val regfile_write = Flipped(new RegFileWrite)
	val csrfile_write = Flipped(new CsrFileWrite)
}

class Commit extends Stage {
	override lazy val io = IO(new CommitPort)

	withReset(rst) {
		val reg_rd_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_csr_addr 	= RegInit(0.U(CsrFile.ADDR.W))
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
		io.regfile_write.rd_wen 	:= reg_rd_wen && !io.trap
		io.regfile_write.rd_addr 	:= reg_rd_addr
		io.regfile_write.rd_data 	:= reg_data1
		// bypass for redirection
		addSource(io.regfile_write.rd_wen, "commit_rd_wen")
		addSource(io.regfile_write.rd_addr, "commit_rd_addr")
		addSource(io.regfile_write.rd_data, "commit_rd_data")

		// connect to csrfile write port
		io.csrfile_write.addr 		:= reg_csr_addr
		io.csrfile_write.data 		:= reg_data2
		io.csrfile_write.wen 		:= reg_csr_use && !io.trap
		// bypass for redirection
		addSource(io.csrfile_write.wen, "commit_csr_use")
		addSource(io.csrfile_write.addr, "commit_csr_addr")
		addSource(io.csrfile_write.data, "commit_csr_data")

		// is this instruction valid?
		val minstret_en = Wire(Bool())
		minstret_en := enable && io.out.valid && !io.trap
		addSource(minstret_en, "minstret_en")
	}

	// for YSYX project
	if (YSYX_DIFFTEST) {
		val difftest = Module(new DifftestInstrCommit)
		difftest.io.clock 	:= clock
		difftest.io.coreid 	:= 0.U
		difftest.io.index 	:= 0.U

		difftest.io.valid 	:= enable && io.out.valid && !io.trap
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
			val cycleCnt = WireInit(0.U(MXLEN.W))
			val instrCnt = WireInit(0.U(MXLEN.W))
			addSink(cycleCnt, "mcycle")
			addSink(instrCnt, "minstret")

			val trap = Module(new DifftestTrapEvent)
			trap.io.clock 		:= clock
			trap.io.coreid 		:= 0.U
			trap.io.valid 		:= 0x6b.U === io.out.inst
			trap.io.code 		:= 0.U
			trap.io.pc 			:= io.out.pc
			trap.io.cycleCnt 	:= cycleCnt
			trap.io.instrCnt 	:= instrCnt
		}
	}
}