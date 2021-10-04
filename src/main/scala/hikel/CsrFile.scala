// This is the functional interface of CSR registers

package hikel

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

// difftest
import difftest._

import Config._
import csr.machine._

class CsrFileRead extends Bundle {
	val addr 	= Input(UInt(CsrFile.ADDR.W))
	val data 	= Output(UInt(MXLEN.W))
	val valid 	= Output(Bool())
}

class CsrFileWrite extends Bundle {
	val addr 	= Input(UInt(CsrFile.ADDR.W))
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
	val ADDR 		= 12

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

// Though we don't create multiple harts, it means no bad making it available to assign hartid.
class CsrFile(val hartid: Int) extends Module {
	val io = IO(new Bundle {
		val read 	= new CsrFileRead
		val write 	= new CsrFileWrite
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
		Module(new MStatus), Module(new MEDeleg), Module(new MIDeleg), Module(new MtVec), Module(new MScratch), 
		Module(new MEpc), Module(new MCause), Module(new MtVal), Module(new Mip), Module(new Mie), 
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
			val sel = csr.addr.U === io.write.addr
			when (sel) {
				csr.io.wdata 	:= io.write.data
				csr.io.wen 		:= io.write.wen && csr.writable
				io.write.valid 	:= !io.write.wen || csr.writable
			}
		}
	}

	val mstatus 	= WireInit(0.U(MXLEN.W))
	val mcause 		= WireInit(0.U(MXLEN.W))
	val mepc 		= WireInit(0.U(MXLEN.W))
	val mip 		= WireInit(0.U(MXLEN.W))
	val mie 		= WireInit(0.U(MXLEN.W))
	val mscratch 	= WireInit(0.U(MXLEN.W))
	val mideleg 	= WireInit(0.U(MXLEN.W))
	val medeleg 	= WireInit(0.U(MXLEN.W))
	val mtval 		= WireInit(0.U(MXLEN.W))
	val mtvec 		= WireInit(0.U(MXLEN.W))
	addSink(mstatus, "mstatus")
	addSink(mcause, "mcause")
	addSink(mepc, "mepc")
	addSink(mip, "mip")
	addSink(mie, "mie")
	addSink(mscratch, "mscratch")
	addSink(mideleg, "mideleg")
	addSink(medeleg, "medeleg")
	addSink(mtval, "mtval")
	addSink(mtvec, "mtvec")

	if (YSYX_DIFFTEST) {
		val difftest = Module(new DifftestCSRState)
		difftest.io.clock 		:= clock
		difftest.io.coreid 		:= 0.U
		difftest.io.mstatus 	:= mstatus
		difftest.io.mcause 		:= mcause
		difftest.io.mepc 		:= mepc
		difftest.io.sstatus 	:= 0.U
		difftest.io.scause 		:= 0.U
		difftest.io.sepc 		:= 0.U
		difftest.io.satp 		:= 0.U
		difftest.io.mip 		:= mip
		difftest.io.mie 		:= mie
		difftest.io.mscratch 	:= mscratch
		difftest.io.sscratch 	:= 0.U
		difftest.io.mideleg 	:= mideleg
		difftest.io.medeleg 	:= medeleg
		difftest.io.mtval 		:= mtval
		difftest.io.stval 		:= 0.U
		difftest.io.mtvec 		:= mtvec
		difftest.io.stvec 		:= 0.U
		difftest.io.priviledgeMode := "b11".U
	}
}