// The Commit stage of hikelchip core
// In this stage CPU will do things below: 
// 		* write result of Execute back to regfile/csr/lsu
// 		* take in a trap if there is one

package hikel.stage

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

import freechips.rocketchip.rocket.Instructions.MRET

import hikel._
import hikel.Config._
import hikel.util.ReadyValid
import hikel.fufu._
import hikel.csr.machine.MCause._

import difftest._

class CommitPortIn extends StagePortIn {
	val rd_addr 	= UInt(RegFile.ADDR.W)
	val csr_addr 	= UInt(CsrFile.ADDR.W)

	val rd_wen 		= Bool()
	val csr_use 	= Bool()
	val lsu_use 	= Bool()
	val uop 		= UInt(5.W)

	val mret 		= Bool()

	val data1 		= UInt(MXLEN.W)		// write to regfile, or as the address of lsu
	val data2 		= UInt(MXLEN.W)		// write to CSR/LSU
}

class CommitPort extends StagePort {
	override lazy val in = Input(new CommitPortIn)
	val regfile_write = Flipped(new RegFileWrite)
	val csrfile_write = Flipped(new CsrFileWrite)
	val dwrite = ReadyValid(new LsuWrite)

	val mret = Output(Bool())
	val hshake = Output(Bool()) 		// the handshake is successful
}

class Commit extends Stage {
	override lazy val io = IO(new CommitPort)

	withReset(rst) {
		val reg_rd_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_csr_addr 	= RegInit(0.U(CsrFile.ADDR.W))
		val reg_rd_wen 		= RegInit(false.B)
		val reg_csr_use 	= RegInit(false.B)
		val reg_lsu_use 	= RegInit(false.B)
		val reg_uop 		= RegInit(0.U(5.W))
		val reg_mret 		= RegInit(false.B)
		val reg_data1 		= RegInit(0.U(MXLEN.W))
		val reg_data2 		= RegInit(0.U(MXLEN.W))
		when (enable) {
			reg_rd_addr 	:= io.in.rd_addr
			reg_csr_addr 	:= io.in.csr_addr
			reg_rd_wen 		:= io.in.rd_wen
			reg_csr_use 	:= io.in.csr_use
			reg_lsu_use 	:= io.in.lsu_use
			reg_uop 		:= io.in.uop
			reg_mret 		:= io.in.mret
			reg_data1 		:= io.in.data1
			reg_data2 		:= io.in.data2
		}

		io.mret := reg_mret
		addSource(io.mret, "do_mret")

		val mepc_pc = io.out.pc
		addSource(mepc_pc, "mepc_pc")

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

		// connect to Lsu write port
		io.dwrite.valid := reg_uop(4).asBool && reg_lsu_use
		io.dwrite.bits.data := reg_data1
		io.dwrite.bits.op := reg_uop(2, 0)
		io.dwrite.bits.addr := reg_data1(31, 0)

		io.hshake := !io.dwrite.valid || (io.dwrite.valid && io.dwrite.ready)

		// generate exception signals
		val reg_excp = RegInit(false.B)
		val reg_code = RegInit(0.U(EXCP_LEN.W))
		when (enable) {
			reg_excp := io.in.excp
			reg_code := io.in.code
		}
		io.out.excp := reg_excp || io.dwrite.bits.excp
		io.out.code := Mux(reg_excp, reg_code, 
				Mux(io.dwrite.bits.misalign, STORE_ADDR_MISALIGN, STORE_ACCE))

		// is this instruction valid?
		val minstret_en = Wire(Bool())
		minstret_en := enable && io.out.valid && !io.trap
		addSource(minstret_en, "minstret_en")
	}

	// for YSYX project
	if (YSYX_DIFFTEST) {
		{	// connect to instrcommit
			val instr = Module(new DifftestInstrCommit)
			instr.io.clock 		:= clock
			instr.io.coreid 	:= 0.U
			instr.io.index 		:= 0.U

			instr.io.valid 		:= RegNext(enable && io.out.valid)
			instr.io.pc 		:= RegNext(io.out.pc)
			instr.io.instr 		:= RegNext(io.out.inst)
			instr.io.skip 		:= false.B
			instr.io.isRVC 		:= false.B
			instr.io.scFailed 	:= false.B

			instr.io.wen 		:= RegNext(io.regfile_write.rd_wen)
			instr.io.wdata 		:= RegNext(io.regfile_write.rd_data)
			instr.io.wdest 		:= RegNext(io.regfile_write.rd_addr)
		}

		{	// connect to trap
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