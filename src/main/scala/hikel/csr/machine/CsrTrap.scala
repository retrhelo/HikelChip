// CSR registers for Trap

package hikel.csr.machine

import chisel3._
import chisel3.util._

import hikel.Config.MXLEN

import hikel.csr.Csr._
import hikel.csr.CsrReg
import hikel.csr.CsrRegBundle

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

class MStatusBundle extends CsrRegBundle {
	val trap_wen = Input(Bool())
	val trap_data = Input(UInt(MXLEN.W))
}

class MStatus extends CsrReg(MSTATUS) {
	override lazy val io = IO(new MStatusBundle)

	val mie 	= RegInit(false.B)
	val mpie 	= RegInit(false.B)

	val read_vec = VecInit(io.read.asBools)
	for (i <- 0 until read_vec.length) {
		read_vec(i) := false.B
	}
	read_vec(MStatus.MIE) := mie
	read_vec(MStatus.MPIE) := mpie
	read_vec(MStatus.MPP+1) := true.B
	read_vec(MStatus.MPP) := true.B
	io.read := read_vec.asUInt

	when (io.trap_wen) {
		mie := io.trap_data(MStatus.MIE)
		mpie := mie
	}
	.elsewhen (wen) {
		mie := io.data(MStatus.MIE)
		mpie := io.data(MStatus.MPIE)
	}
}

class MIsa extends CsrReg(MISA) {
	val EXT_I = 1 << ('I' - 'A')
	val EXT_C = 1 << ('C' - 'A')

	val EXT = EXT_I | EXT_C

	io.read := EXT.U
}

class MEDeleg extends CsrReg(MEDELEG) {
	io.read := 0.U
}
class MIDeleg extends CsrReg(MEDELEG) {
	io.read := 0.U
}

object MtVec {
	val MODE_DIRECT = 0.U(2.W)
	val MODE_VECTORED = 1.U(2.W)
}

class MtVec extends CsrReg(MTVEC) {
	val BASE = RegInit(0.U((MXLEN - 2).W))
	// only support MODE
	val MODE = MtVec.MODE_DIRECT

	io.read := Cat(BASE, MODE)

	val align = ~(io.data(1, 0).orR)

	when (wen && align) {
		BASE := io.data(MXLEN-3, 2)
	}
}

class MScratch extends CsrReg(MSCRATCH) {
	val mscratch = RegInit(0.U(MXLEN.W))

	io.read := mscratch
	when (wen) {
		mscratch := io.data
	}
}

class MEpcBundle extends CsrRegBundle {
	val trap_wen = Input(Bool())
	val trap_data = Input(UInt((MXLEN-1).W))
}

class MEpc extends CsrReg(MEPC) {
	override lazy val io = IO(new MEpcBundle)

	val mepc = RegInit(0.U((MXLEN-1).W))

	// mepc[0] is always zero, and for those only implement IALIGN = 32, 
	// mepc[1:0] are always zero. 
	io.read := Cat(mepc, 0.U(1.W))
	when (io.trap_wen) {
		mepc := io.trap_data
	}
	.elsewhen (wen) {
		mepc := io.data(MXLEN-1, 1)
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

class MCauseBundle extends CsrRegBundle {
	val trap_wen = Input(Bool())
	// Exception Code
	val trap_excp_code = Input(UInt(MCause.EXCP_LEN.W))
	// Interrupt Bit
	val trap_int = Input(Bool())
}

class MCause extends CsrReg(MCAUSE) {
	override lazy val io = IO(new MCauseBundle)

	val int = RegInit(false.B)
	val excp_code = RegInit(0.U(MCause.EXCP_LEN.W))

	io.read := Cat(int, Fill(MXLEN - 1 - MCause.EXCP_LEN, 0.U), excp_code)

	// trap handling
	when (io.trap_wen) {
		excp_code := io.trap_excp_code
		int := io.trap_int
	}
}

class MtValBundle extends CsrRegBundle {
	val trap_wen = Input(Bool())
	val trap_data = Input(UInt(MXLEN.W))
}

class MtVal extends CsrReg(MTVAL) {
	override lazy val io = IO(new MtValBundle)

	val value = RegInit(0.U(MXLEN.W))

	io.read := value
	when (io.trap_wen) {
		value := io.trap_data
	}
	.elsewhen (wen) {
		value := io.data
	}
}

// Machine Level Interrupt Enable/Pending
object MI {
	val MI_LEN 	= 16

	val SSI 	= 1		// S-level soft
	val MSI 	= 3		// M-level soft
	val STI 	= 5		// S-level timer
	val MTI 	= 7		// M-level timer
	val SEI 	= 9		// S-level external
	val MEI 	= 11	// M-level external
}

class Mie extends CsrReg(MIE) {
	val msie = RegInit(false.B)
	val mtie = RegInit(false.B)
	val meie = RegInit(false.B)
	
	val read_vec = VecInit(io.read.asBools)
	for (i <- 0 until read_vec.length) {
		read_vec(i) := false.B
	}
	read_vec(MI.MSI) := msie
	read_vec(MI.MTI) := mtie
	read_vec(MI.MEI) := meie
	io.read := read_vec.asUInt

	when (wen) {
		msie := io.data(MI.MSI)
		mtie := io.data(MI.MTI)
		meie := io.data(MI.MEI)
	}
}

class MipBundle extends CsrRegBundle {
	val msip = Input(Bool())
	val mtip = Input(Bool())
	val meip = Input(Bool())
}

class Mip extends CsrReg(MIP) {
	override lazy val io = IO(new MipBundle)

	// Please remember that all of the M-level bits in mip 
	// are not changable by writing directly to mip. 

	// io.read := 0.U
	val read_vec = VecInit(io.read.asBools)
	for (i <- 0 until read_vec.length) {
		read_vec(i) := false.B
	}
	read_vec(MI.MSI) := io.msip
	read_vec(MI.MTI) := io.mtip
	read_vec(MI.MEI) := io.meip

	io.read := read_vec.asUInt
}