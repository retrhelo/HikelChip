// CLINT: Core Local INTerrupt

package hikel.mmio

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.fufu._

class ClintPort(val hartnum: Int) extends LsuUnitPort {
	val do_soft = Output(Vec(hartnum, Bool()))		// software interrupt
	val do_timer = Output(Vec(hartnum, Bool())) 	// timer interrupt
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

	// the number of msip registers / 2
	private val MSIP_NUM = (hartnum + 1) / 2

	override lazy val io = IO(new ClintPort(hartnum))

	val reg_msip = RegInit(VecInit(Seq.fill(hartnum)(false.B)))
	val reg_mtimecmp = RegInit(VecInit(Seq.fill(hartnum)(0.U(MXLEN.W))))
	val reg_timer = RegInit(VecInit(Seq.fill(hartnum)(false.B)))
	val reg_mtime = RegInit(0.U(MXLEN.W))

	/* Register Update */
	for (i <- 0 until hartnum) {
		when (reg_mtimecmp(i) === reg_mtime) {
			reg_timer(i) := true.B
		}
	}
	reg_mtime := reg_mtime + 1.U

	/* Interrupt Signals */
	for (i <- 0 until hartnum) {
		io.do_soft(i) := reg_msip(i)
		io.do_timer(i) := reg_timer(i)
	}

	/* READ from CLINT */
	val ren_msip = Wire(Vec(MSIP_NUM, Bool()))
	val ren_mtimecmp = Wire(Vec(hartnum, Bool()))
	val ren_mtime = Wire(Bool())

	io.read.ready := true.B
	io.read.bits.rdata := 0.U
	val raddr = io.read.bits.addr(12, 0)
	for (i <- 0 until MSIP_NUM) {
		ren_msip(i) := raddr === MSIP(2 * i).U
		when (ren_msip(i)) {
			io.read.bits.rdata := Cat(
				Fill(31, 0.U), if (2 * i + 1 < hartnum) {reg_msip(2*i+1)} else {false.B}, 
				Fill(31, 0.U), reg_msip(2*i)
			)
		}
	}
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
	val wen_msip = Wire(Vec(MSIP_NUM, Bool()))
	val wen_mtimecmp = Wire(Vec(hartnum, Bool()))

	io.write.ready := true.B
	val waddr = io.write.bits.addr(12, 0)
	for (i <- 0 until MSIP_NUM) {
		wen_msip(i) := io.write.valid && (waddr === MSIP(2 * i).U)
		when (wen_msip(i) && io.write.bits.wstrb(0).asBool) {
			reg_msip(2 * i) := io.write.bits.wdata(0)
		}
		if (2 * i + 1 < hartnum) {
			when (wen_msip(i) && io.write.bits.wstrb(4).asBool) {
				reg_msip(2 * i + 1) := io.write.bits.wdata(32)
			}
		}
	}
	for (i <- 0 until hartnum) {
		wen_mtimecmp(i) := io.write.valid && (waddr === MTIMECMP(i).U) && 
				io.write.bits.wstrb.andR
		when (wen_mtimecmp(i)) {
			reg_timer(i) := false.B
			reg_mtimecmp(i) := io.write.bits.wdata
		}
	}
}