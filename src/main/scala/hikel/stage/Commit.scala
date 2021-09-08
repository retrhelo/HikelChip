// The Commit stage of hikelchip core
// In this stage CPU will do things below: 
// 		* write result of Execute back to regfile/csr/lsu
// 		* take in a trap if there is one

package hikel.stage

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.RegFile
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

class CommitPort extends StagePort

class Commit extends Stage


import chisel3.stage.ChiselStage
object CommitGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Commit, BUILD_ARG)
}