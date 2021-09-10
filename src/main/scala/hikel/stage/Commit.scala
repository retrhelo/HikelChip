// The Commit stage of hikelchip core
// In this stage CPU will do things below: 
// 		* write result of Execute back to regfile/csr/lsu
// 		* take in a trap if there is one

package hikel.stage

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.RegFile
import hikel.RegFileWrite
import hikel.csr.Csr

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
		io.regfile_write.rd_addr 	:= reg_rd_addr
		io.regfile_write.rd_data 	:= reg_data1
		io.regfile_write.rd_wen 	:= reg_rd_wen
	}
}


import chisel3.stage.ChiselStage
object CommitGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Commit, BUILD_ARG)
}