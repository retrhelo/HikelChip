// The Load/Store Unit

package hikel.fufu

import chisel3._
import chisel3.util._

import hikel.Config._

// general interface to reading data from RAM
class LsuRead extends Bundle {
	val addr 	= Input(UInt(MXLEN.W))
	val rdata 	= Output(UInt(MXLEN.W))
	val rvalid 	= Input(Bool())
	val rready 	= Output(Bool())
}

// general interface to write data to RAM
object LsuWrite {
	def expand(strb: UInt) = {
		val tmp = Wire(UInt(MXLEN.W))
		val tmp_vec = VecInit(tmp.asBools)
		for (i <- 0 until MXLEN) {
			val j = i / 8
			tmp_vec(i) := strb(j)
		}
		tmp_vec.asUInt
	}
}

class LsuWrite extends Bundle {
	val addr 	= Input(UInt(MXLEN.W))
	val wdata 	= Input(UInt(MXLEN.W))
	val wstrb 	= Input(UInt((MXLEN / 8).W))
	val wvalid 	= Input(Bool())
	val wready 	= Output(Bool())
}

// general RAM interface
class LsuModule extends Module {
	val io = IO(new Bundle {
		val iread 	= new LsuRead
		val dread 	= new LsuRead
		val dwrite 	= new LsuWrite
	})
}