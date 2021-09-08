package hikel.csr

import chisel3._
import chisel3.util._

import hikel.Config.MXLEN

object Csr {
	val ADDR 		= 12

	// code of different privilege level
	val MACHINE 	= "b11".U
	val HYPERVISOR 	= "b10".U
	val SUPERVISOR 	= "b01".U
	val USER 		= "b00".U

	val READ_ONLY 	= "b11".U
	// otherwise it's read/write

	// address of implemented registers
	// machine information registers
	val MVENDORID 		= 0xf11
	val MARCHID 		= 0xf12
	val MIMPID 			= 0xf13
	val MHARTID 		= 0xf14
	// machine trap setup
	val MSTATUS 		= 0x300
	val MISA 			= 0x301
	val MEDELEG 		= 0x302
	val MIDELEG 		= 0x303
	val MIE 			= 0x304
	val MTVEC 			= 0x305
	// machine trap handling
	val MSCRATCH 		= 0x340
	val MEPC 			= 0x341
	val MCAUSE 			= 0x342
	val MTVAL 			= 0x343
	val MIP 			= 0x344
	// to be simple, we give up implementing other csrs for machine level. 

	// csr writting command
	val CMD 			= 2
	val CSR_NONE 		= "b00".U
	val CSR_WRITE 		= "b01".U
	val CSR_SET 		= "b10".U
	val CSR_CLEAR 		= "b11".U
}

import Csr._
import hikel.csr.machine._

class Csr(val hartid: Int) extends Module {
	val io = IO(new Bundle {
		val addr = Input(UInt(ADDR.W))
		val data = Input(UInt(MXLEN.W))
		val csr_cmd = Input(UInt(2.W))

		val legal = Output(Bool())
		val read = Output(UInt(MXLEN.W))

		// trap handling
		val trap_wen = Input(Bool())
		val trap_mstatus = Input(UInt(MXLEN.W))
		val trap_mepc = Input(UInt(MXLEN.W))
		val trap_excp_code = Input(UInt(MCause.EXCP_LEN.W))
		val trap_int = Input(Bool())
		val trap_mtval = Input(UInt(MXLEN.W))

		// external connection
		val mip_msip = Input(Bool())
		val mip_mtip = Input(Bool())
		val mip_meip = Input(Bool())

		val mstatus = Output(UInt(MXLEN.W))
		val mtvec = Output(UInt(MXLEN.W))
		val mepc = Output(UInt(MXLEN.W))
		val mie = Output(UInt(MI.MI_LEN.W))
		val mip = Output(UInt(MI.MI_LEN.W))
	})

	val wen = io.csr_cmd.orR
	val csr_data = Mux(CSR_SET === io.csr_cmd, io.read | io.data, 
			Mux(CSR_CLEAR === io.csr_cmd, io.read & ~(io.data), io.data))

	io.legal := false.B
	io.read := 0.U

	// select csr reg
	val csr_regs = List(
		Module(new MVendorId), Module(new MArchId), Module(new MImpId), Module(new MHartId(hartid)), 
		Module(new MStatus), Module(new MIsa), Module(new MEDeleg), Module(new MIDeleg), 
		Module(new MtVec), Module(new MScratch), Module(new MEpc), Module(new MCause), Module(new MtVal), 
		Module(new Mie), Module(new Mip), 
	)
	for (i <- 0 until csr_regs.length) {
		val csr = csr_regs(i)
		csr.io.addr := io.addr
		csr.io.wen := wen
		csr.io.data := csr_data
		when (csr.io.legal) {
			// because we only implement M-mode, so skip privilege check
			io.legal := true.B
			io.read := csr.io.read
		}

		if (MSTATUS == csr.csr_addr) {
			val mstatus = csr.asInstanceOf[MStatus]
			mstatus.io.trap_wen := io.trap_wen
			mstatus.io.trap_data := io.trap_mstatus
			io.mstatus := mstatus.io.read
		}
		else if (MTVEC == csr.csr_addr) {
			io.mtvec := csr.io.read
		}
		else if (MEPC == csr.csr_addr) {
			val mepc = csr.asInstanceOf[MEpc]
			mepc.io.trap_wen := io.trap_wen
			mepc.io.trap_data := io.trap_mepc
			io.mepc := mepc.io.read
		}
		else if (MCAUSE == csr.csr_addr) {
			val mcause = csr.asInstanceOf[MCause]
			mcause.io.trap_wen := io.trap_wen
			mcause.io.trap_excp_code := io.trap_excp_code
			mcause.io.trap_int := io.trap_int
		}
		else if (MTVAL == csr.csr_addr) {
			val mtval = csr.asInstanceOf[MtVal]
			mtval.io.trap_wen := io.trap_wen
			mtval.io.trap_data := io.trap_mtval
		}
		else if (MIE == csr.csr_addr) {
			io.mie := csr.io.read
		}
		else if (MIP == csr.csr_addr) {
			val mip = csr.asInstanceOf[Mip]
			mip.io.msip := io.mip_msip
			mip.io.mtip := io.mip_mtip
			mip.io.meip := io.mip_meip
			io.mip := csr.io.read
		}
	}
}

// the general interface for CsrReg
class CsrPort extends Bundle {
	val addr = Input(UInt(ADDR.W))
	val wen = Input(Bool())
	val data = Input(UInt(MXLEN.W))
	val legal = Output(Bool())
	val read = Output(UInt(MXLEN.W))
}

// general abstraction of csr regsiters
abstract class CsrReg(val csr_addr: Int) extends Module {
	lazy val io = IO(new CsrPort)

	val writable = READ_ONLY =/= io.addr(11, 10)
	val sel = csr_addr.U === io.addr
	val wen = writable && io.wen && sel

	// remember you should NEVER use io.wen to decide on writing register
	// the writing itself maybe illegal

	io.legal := sel && (!io.wen || writable)
}


import chisel3.stage.ChiselStage
import hikel.Config.BUILD_ARG
object CsrGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Csr(0), BUILD_ARG)
}