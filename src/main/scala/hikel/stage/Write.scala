// The Write-Back stage of 5-stage hikelchip RISC-V64 core
// In this stage CPU will do things below: 
// 		* write result of Execute back to regfile/csr/mmio
// 		* take in a trap if there is one

package hikel.stage

import chisel3._

import hikel.Config._
import hikel.{RegFile, RegFileWrite}

class WritePortIn extends StagePortIn {
	val rd_addr 	= Input(UInt(RegFile.ADDR.W))
	val rd_wen 		= Input(Bool())

	val data1 		= Input(UInt(MXLEN.W))	// write to regfile
	// val data2 		= Input(UInt(MXLEN.W))	// write to CSR or LSU
}

class WritePort extends StagePort {
	override lazy val in = new WritePortIn
	// the pipeline reaches the end

	val regfile = Flipped(new RegFileWrite)
}

class Write extends Stage {
	override lazy val io = IO(new WritePort)

	withReset(rst) {
		val reg_rd_addr 	= RegInit(0.U(RegFile.ADDR.W))
		val reg_rd_wen 		= RegInit(false.B)
		when (enable) {
			reg_rd_addr 	:= io.in.rd_addr
			reg_rd_wen 		:= io.in.rd_wen
		}

		val reg_data1 		= RegInit(0.U(MXLEN.W))
		when (enable) {
			reg_data1 		:= io.in.data1
		}

		// connect to regfile
		io.regfile.rd_addr 	:= reg_rd_addr
		io.regfile.rd_data 	:= reg_data1
		io.regfile.rd_wen 	:= reg_rd_wen
	}
}


import chisel3.stage.ChiselStage
object WriteGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Write, BUILD_ARG)
}