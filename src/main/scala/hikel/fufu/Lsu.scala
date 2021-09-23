// The Load/Store Unit

package hikel.fufu

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.mmio._
import hikel.csr.machine.MCause._
import hikel.util.ReadyValid

class LsuUnitRead extends Bundle {
	val addr 	= Output(UInt(Lsu.ADDR.W))
	val rdata 	= Input(UInt(Lsu.DATA.W))
}
class LsuUnitWrite extends Bundle {
	val addr 	= Output(UInt(Lsu.ADDR.W))
	val wdata 	= Output(UInt(Lsu.DATA.W))
	val wstrb 	= Output(UInt(Lsu.MASK.W))

	def expand_wstrb = {
		val tmp = WireInit(0.U(MXLEN.W))
		val tmp_vec = VecInit(tmp.asBools)
		for (i <- 0 until MXLEN) {
			val j = i / 8
			tmp_vec(i) := wstrb(j)
		}
		tmp_vec.asUInt
	}
}

class LsuUnitPort extends Bundle {
	val read = Flipped(ReadyValid(new LsuUnitRead))
	val write = Flipped(ReadyValid(new LsuUnitWrite))
}
abstract class LsuUnit extends Module {
	lazy val io = IO(new LsuUnitPort)
}


// LSU port for CPU to access. 
class LsuPort extends Bundle {
	val addr 	= Output(UInt(MXLEN.W))
	val op 		= Output(UInt(3.W))

	// exception signals
	val excp 	= Input(Bool())
	val code 	= Input(UInt(EXCP_LEN.W))

	// generate misalign exception signal
	def genMisalign: Bool = {
		MuxLookup(op(1, 0), false.B, Seq(
			"b00".U -> true.B, 
			"b01".U -> (0.U === addr(0)), 
			"b10".U -> (0.U === addr(1, 0)), 
			"b11".U -> (0.U === addr(2, 0)), 
		))
	}
}
class LsuRead extends LsuPort {
	val data 		= Output(UInt(MXLEN.W))
}
class LsuWrite extends LsuPort {
	val data 		= Input(UInt(MXLEN.W))
}

private class LsuReadArbiter extends Module {
	val io = IO(new Bundle {
		val iread = Flipped(ReadyValid(new LsuRead))
		val dread = Flipped(ReadyValid(new LsuRead))
		val read = ReadyValid(new LsuRead)
	})

	// `dread` has higher priority
	val sel = io.dread.valid

	io.read.valid := sel || io.iread.valid
	io.dread.ready := io.read.ready
	io.iread.ready := !sel && io.read.ready

	io.dread.bits <> io.read.bits
	io.iread.bits <> io.read.bits
}

object Lsu {
	val ADDR 		= 32 - log2Ceil(MASK)
	val DATA 		= MXLEN
	lazy val MASK 	= MXLEN / 8

	/* Memory Layout:
		RAM 		(0x8000_0000, ??K, cached)
		CLINT 		(0x0200_0000, 4K)
	*/
}
class Lsu extends Module {
	val io = IO(new Bundle {
		val iread = Flipped(ReadyValid(new LsuRead))
		val dread = Flipped(ReadyValid(new LsuRead))
		val dwrite = Flipped(ReadyValid(new LsuWrite))

		// connect to CLINT
		val clint = Flipped(new ClintPort(HARTNUM))
	})

	val read = Wire(ReadyValid(new LsuRead));
	{ 		// use arbiter to clear conflicts between Iread and Dread
		val arbiter = Module(new LsuReadArbiter)
		arbiter.io.iread <> io.iread
		arbiter.io.dread <> io.dread
		read <> arbiter.io.read
	}

	/* LSU should divide MMIO access into 3 parts:
		1. Access to RAM (AXI4 and cached)
		2. Access to peripherals (AXI4 but NOT cached)
		3. Access to CLINT (built in CPU, neither AXI4 nor cached)
	*/

	
}