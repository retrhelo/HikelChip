// CLINT: Core Local INTerrupt

package hikel.fufu.mmio

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.fufu._

class ClintPort(hartnum: Int) extends LsuUnitPort {
	val do_soft 	= Output(Vec(hartnum, Bool()))
	val do_timer 	= Output(Vec(hartnum, Bool()))
}

// clint register memory layout
// 		0x0000 + 4 * hartid 	msip
// 		0x4000 + 8 * hartid		mtimecmp
// 		0xbff8 					mtime
object Clint {
	val MSIP_OFFSET 		= 0x0000
	val MSIP_LEN 			= 4
	val MTIMECMP_OFFSET 	= 0x4000
	val MTIMECMP_LEN 		= 8
	val MTIME_OFFSET 		= 0xbff8
	val MTIME_LEN 			= 8
}
import Clint._

class Clint(val hartnum: Int, val base: BigInt) extends LsuUnit {
	def MSIP(hartid: Int) = (base + MSIP_OFFSET + MSIP_LEN * hartid) >> 3
	def MTIMECMP(hartid: Int) = (base + MTIMECMP_OFFSET + MTIMECMP_LEN * hartid) >> 3
	def MTIME = (base + MTIME_OFFSET) >> 3

	override lazy val io = IO(new ClintPort(hartnum))
	
	// to be simple, current implementation does not support software interrupt
	val reg_mtimecmp = RegInit(VecInit(Seq.fill(hartnum)(0.U(MXLEN.W))))
	val reg_mtime = RegInit(0.U(MXLEN.W))
	val reg_do_timer = RegInit(VecInit(Seq.fill(hartnum)(false.B)))

	/* register update */
	reg_mtime := reg_mtime + 1.U
	for (i <- 0 until hartnum) {
		when (reg_mtimecmp(i) === reg_mtime) {
			reg_do_timer(i) := true.B
		}
	}

	/* interrupt signals */
	for (i <- 0 until hartnum) {
		io.do_soft(i) 	:= false.B
		io.do_timer(i) 	:= reg_do_timer(i)
	}

	/* READ from CLINT */
	val ren_mtime = Wire(Bool())
	val ren_mtimecmp = Wire(Vec(hartnum, Bool()))

	io.read.ready := true.B
	io.read.bits.excp := false.B
	io.read.bits.rdata := 0.U
	val raddr = io.read.bits.addr >> 3
	for (i <- 0 until hartnum) {
		ren_mtimecmp(i) := raddr === MTIMECMP(i).U
		when (ren_mtimecmp(i)) {
			io.read.bits.rdata := reg_mtimecmp(i)
		}
	}
	ren_mtime := raddr === MTIME.U
	when (ren_mtime) {
		io.read.bits.rdata := reg_mtime
	}

	/* WRITE to CLINT */
	val wen_mtimecmp = Wire(Vec(hartnum, Bool()))

	io.write.ready := true.B
	io.write.bits.excp := false.B
	val waddr = io.write.bits.addr >> 3
	for (i <- 0 until hartnum) {
		wen_mtimecmp(i) := io.write.valid && (waddr === MTIMECMP(i).U) && 
				io.write.bits.wstrb.andR
		when (wen_mtimecmp(i)) {
			reg_do_timer(i) := false.B
			reg_mtimecmp(i) := io.write.bits.wdata
		}
	}
}