// CSR Trap Registers

package hikel.csr.machine

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

import freechips.rocketchip.rocket.CSRs

import hikel.Config._
import hikel.CsrReg

object MStatus {
	val SIE 	= 1
	val MIE 	= 3
	val SPIE 	= 5
	val UBE 	= 6
	val MPIE 	= 7
	val SPP 	= 8
	val MPP 	= 11	// [12:11]
	val FS 		= 13	// [14:13]
	val XS 		= 15	// [16:15]
	val MPRV 	= 17
	val SUM 	= 18
	val MXR 	= 19
	val TVM 	= 20
	val TW 		= 21
	val TSR 	= 22
	val UXL 	= 32	// [33:32]
	val SBE 	= 36
	val MBE 	= 37
	val SD 		= MXLEN - 1
}

class MStatus extends CsrReg(CSRs.mstatus) {
	val mstatus = WireInit(0.U(MXLEN.W))

	val mie 	= RegInit(false.B)
	val mpie 	= RegInit(false.B)

	val mstatus_vec = VecInit(mstatus.asBools)
	mstatus_vec(MStatus.MIE) 	:= mie
	mstatus_vec(MStatus.MPIE) 	:= mpie
	// mstatus_vec(MStatus.MPP+1) 	:= true.B
	// mstatus_vec(MStatus.MPP) 	:= true.B

	io.rdata 	:= mstatus_vec.asUInt
	addSource(io.rdata, "mstatus")

	// update
	when (io.wen) {
		mie 	:= io.wdata(MStatus.MIE)
		mpie 	:= io.wdata(MStatus.MPIE)
	}
}

class MIsa extends CsrReg(CSRs.misa) {
	val EXT_I = 1 << ('I' - 'A')
	val EXT = EXT_I

	io.rdata 	:= EXT.U
}

class MEDeleg extends CsrReg(CSRs.medeleg) {
	val medeleg = WireInit(0.U(MXLEN.W))

	addSource(medeleg, "medeleg")
	io.rdata 	:= medeleg
}
class MIDeleg extends CsrReg(CSRs.mideleg) {
	val mideleg = WireInit(0.U(MXLEN.W))

	addSource(mideleg, "mideleg")
	io.rdata 	:= mideleg
}

object MtVec {
	val MODE_DIRECT 	= 0.U(2.W)
	val MODE_VECTORED 	= 1.U(2.W)
}

class MtVec extends CsrReg(CSRs.mtvec) {
	val BASE = RegInit(0.U((MXLEN - 2).W))
	// only support Direct Mode
	val MODE = MtVec.MODE_DIRECT

	val mtvec = Cat(BASE, MODE)

	addSource(mtvec, "mtvec")
	io.rdata 	:= Cat(BASE, MODE)

	val align = !(io.wdata(1, 0).orR)
	when (io.wen && align) {
		BASE 	:= io.wdata(MXLEN-1, 2)
	}
}

class MScratch extends CsrReg(CSRs.mscratch) {
	val mscratch = RegInit(0.U(MXLEN.W))

	io.rdata := mscratch
	addSource(mscratch, "mscratch")
	// update
	when (io.wen) {
		mscratch := io.wdata
	}
}

class MEpc extends CsrReg(CSRs.mepc) {
	val mepc = RegInit(0.U((MXLEN - 2).W))

	// mepc[0] is always zero, and for those only implement IALIGN = 32, 
	// mepc[1:0] are always zero
	io.rdata := Cat(mepc, 0.U(2.W))
	addSource(mepc, "mepc")

	when (io.wen) {
		mepc := io.wdata(MXLEN-1, 2)
	}
}

object MCause {
	val EXCP_LEN = 4

	// Exception Codes

	// interrupts
	val SSINT	= 1.U(EXCP_LEN.W)
	val MSINT 	= 3.U(EXCP_LEN.W)
	val STINT 	= 5.U(EXCP_LEN.W)
	val MTINT 	= 7.U(EXCP_LEN.W)
	val SEINT 	= 9.U(EXCP_LEN.W)
	val MEINT 	= 11.U(EXCP_LEN.W)
	// exception
	val INS_ADDR_MISALIGN 		= 0.U(EXCP_LEN.W)
	val INS_ACCE				= 1.U(EXCP_LEN.W)
	val ILL_INS					= 2.U(EXCP_LEN.W)
	val BREAKPOINT 				= 3.U(EXCP_LEN.W)
	val LOAD_ADDR_MISALIGN		= 4.U(EXCP_LEN.W)
	val LOAD_ACCE				= 5.U(EXCP_LEN.W)
	val STORE_ADDR_MISALIGN 	= 6.U(EXCP_LEN.W)
	val STORE_ACCE 				= 7.U(EXCP_LEN.W)
	val ENV_CALL_U				= 8.U(EXCP_LEN.W)
	val ENV_CALL_S 				= 9.U(EXCP_LEN.W)
	// 10 is reserved
	val ENV_CALL_M 				= 11.U(EXCP_LEN.W)
	val INS_PAGEFAULT 			= 12.U(EXCP_LEN.W)
	val LOAD_PAGEFAULT 			= 13.U(EXCP_LEN.W)
	// 14 is reserved 
	val STORE_PAGEFAULT 		= 15.U(EXCP_LEN.W)
}

class MCause extends CsrReg(CSRs.mcause) {
	val int = RegInit(false.B)
	val excp_code = RegInit(0.U(MCause.EXCP_LEN))

	val mcause = Wire(UInt(MXLEN.W))
	mcause := Cat(int, Fill(MXLEN - 1 - MCause.EXCP_LEN, 0.U), excp_code)

	io.rdata := mcause
	addSource(mcause, "mcause")
}

class MtVal extends CsrReg(CSRs.mtval) {
	val mtval = WireInit(0.U(MXLEN.W))

	io.rdata := mtval
	addSource(mtval, "mtval")
}

class Mip extends CsrReg(CSRs.mip) {
	val mip = WireInit(0.U(MXLEN.W))

	io.rdata := mip
	addSource(mip, "mip")
}

class Mie extends CsrReg(CSRs.mie) {
	val mie = WireInit(0.U(MXLEN.W))

	io.rdata := mie
	addSource(mie, "mie")
}