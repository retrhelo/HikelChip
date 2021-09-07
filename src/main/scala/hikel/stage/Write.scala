// Write stage of hikelchip core
// In this stage CPU will do things below: 
// 		* write result of Execute back to regfile/csr/lsu/pc
// 		* take in a trap if there is one
// 		* commit to ScoreBoard to release FU

package hikel.stage

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.RegFile
import hikel.csr.Csr
import hikel.ScoreBoardCommit

class WritePortIn extends Bundle {
	val rd_addr 	= UInt(RegFile.ADDR.W)
	val csr_addr 	= UInt(Csr.ADDR.W)
	// mmio
	
	val data1 		= UInt(MXLEN.W) 		// written to regfile
	val data2 		= UInt(MXLEN.W) 		// written to CSR/LSU or PC
	
	val rd_wen 		= Bool()
	val csr_use 	= Bool()
	val lsu_use 	= Bool()
	val jb_use 		= Bool()
}

class WritePort extends StagePort {
	val in = Input(new WritePortIn)
	val out = Output(new WritePortIn)

	// connect to ScoreBoard
	val commit = Output(new ScoreBoardCommit)
}

class Write extends Stage {
	override lazy val io = IO(new WritePort)

	withReset(rst) {
		val reg_in 			= RegInit(Wire({
			val tmp = new WritePortIn
			tmp.rd_addr 	:= 0.U
			tmp.csr_addr 	:= 0.U
			tmp.data1 		:= 0.U
			tmp.data2 		:= 0.U
			tmp.rd_wen 		:= false.B
			tmp.csr_use 	:= false.B
			tmp.lsu_use 	:= false.B
			tmp.jb_use 		:= false.B
			tmp
		}))
		when (enable) {
			reg_in 			:= io.in
		}
		io.out := reg_in

		// connect to ScoreBoard
		io.commit.rd_addr 	:= reg_in.rd_addr
		io.commit.rd_wen 	:= reg_in.rd_wen
		io.commit.csr_use 	:= reg_in.csr_use
		io.commit.lsu_use 	:= reg_in.lsu_use
	}
}


import chisel3.stage.ChiselStage
object WriteGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Write, BUILD_ARG)
}