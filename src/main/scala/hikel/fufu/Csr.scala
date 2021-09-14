// This is the functional interface of CSR registers

package hikel.fufu

import chisel3._
import chisel3.util._

import freechips.rocketchip.rocket.CSR

import hikel.Config._

class CsrReadPort extends Bundle {
	val addr 	= Input(UInt(CSR.ADDRSZ.W))
	val data 	= Output(UInt(MXLEN.W))
	val valid 	= Output(Bool())
}

class CsrWritePort extends Bundle {
	val addr 	= Input(UInt(CSR.ADDRSZ.W))
	val data 	= Input(UInt(MXLEN.W))
	val wen 	= Input(Bool())
	val valid 	= Output(Bool())
}

abstract class CsrReg(val addr: Int) extends Module {
	// assume all the input signals are valid
	lazy val io = IO(new Bundle {
		val rdata 	= Output(UInt(MXLEN.W))
		val wdata 	= Input(UInt(MXLEN.W))
		val wen 	= Input(Bool())
	})

	def writable = addr.U(11, 10) =/= CsrFile.READ_ONLY
}

object CsrFile {
	val CMD 		= 2
	val CSR_NONE 	= "b00".U
	val CSR_WRITE 	= "b01".U
	val CSR_SET 	= "b10".U
	val CSR_CLEAR 	= "b11".U

	// code for different privilege level
	val MACHINE 	= "b11".U
	val HYPERVISOR 	= "b10".U
	val SUPERVISOR 	= "b01".U
	val USER 		= "b00".U

	// register read/write permission, this is decided by the addr[11:10]
	val READ_ONLY 	= "b11".U
	// otherwise read/write
}

import csr.machine._

// Though we don't create multiple harts, it means no bad making it available 
// to assign hartid.
class CsrFile(val hartid: Int) extends Module {
	val io = IO(new Bundle {
		val read 	= new CsrReadPort
		val write 	= new CsrWritePort
	})

	// default connection for read port
	io.read.valid 	:= false.B
	io.read.data 	:= 0.U
	// default connection for write port
	io.write.valid 	:= false.B

	// register list
	val csrfile = List(
		Module(new MVendorId), Module(new MArchId), Module(new MImpId), Module(new MHartId(hartid)), 
		Module(new MCycle), Module(new MInstret), 
		Module(new MScratch), 
	)
	for (i <- 0 until csrfile.length) {
		val csr = csrfile(i)
		csr.io.wdata 	:= 0.U
		csr.io.wen 		:= false.B;
		{	// read out
			val sel = csr.addr.U === io.read.addr
			when (sel) {
				io.read.data 	:= csr.io.rdata
				io.read.valid 	:= true.B
			}
		}
		{	// write in
			val sel = csr.addr.U === io.read.addr
			when (sel) {
				csr.io.wdata 	:= io.write.data
				csr.io.wen 		:= io.write.wen && csr.writable
				io.write.valid 	:= !io.write.wen || csr.writable
			}
		}
	}
}


import chisel3.stage.ChiselStage
object CsrFileGenVerilog extends App {
	(new ChiselStage).emitVerilog(new CsrFile(0), BUILD_ARG)
}