// The Load/Store Unit

package hikel.fufu

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.mmio._
import hikel.mmio.MemLayout._
import hikel.csr.machine.MCause._
import hikel.util.ReadyValid

class LsuUnitRead extends Bundle {
	val addr 	= Output(UInt(Lsu.ADDR.W))
	val rdata 	= Input(UInt(Lsu.DATA.W))
	val op 	= Output(UInt(3.W))

	/*
		op: operation code, 3bit
		base: base address, 3bit
	*/
	def genReadData = {
		val signed = !op(2)
		val width = op(1, 0)
		val base = addr(2, 0)

		val tmp = Wire(UInt(MXLEN.W))
		tmp := MuxLookup(base, 0.U, Array(
			"b000".U -> tmp, 
			"b001".U -> (tmp >> 8), 
			"b010".U -> (tmp >> 16), 
			"b011".U -> (tmp >> 24), 
			"b100".U -> (tmp >> 32), 
			"b101".U -> (tmp >> 40), 
			"b110".U -> (tmp >> 48), 
			"b111".U -> (tmp >> 56), 
		))

		MuxLookup(width, tmp, Array(
			"b00".U -> Cat(Fill(MXLEN - 8, tmp(7) & signed), tmp(7, 0)), 
			"b01".U -> Cat(Fill(MXLEN - 16, tmp(15) & signed), tmp(15, 0)), 
			"b10".U -> Cat(Fill(MXLEN - 32, tmp(31) & signed), tmp(31, 0)), 
			"b11".U -> tmp, 
		))
	}
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


class LsuPort extends Bundle {
	val addr 	= Output(UInt(MXLEN.W))
	val op 		= Output(UInt(3.W))

	// exception signals
	val excp 		= Input(Bool())
	val misalign 	= Input(Bool())

	// generate misalign exception signal
	def isMisalign: Bool = {
		MuxLookup(op(1, 0), false.B, Seq(
			"b00".U -> false.B, 
			"b01".U -> (0.U =/= addr(0)), 
			"b10".U -> (0.U =/= addr(1, 0)), 
			"b11".U -> (0.U =/= addr(2, 0)), 
		))
	}
}
class LsuRead extends LsuPort {
	val data 		= Input(UInt(MXLEN.W))
}
class LsuWrite extends LsuPort {
	val data 		= Output(UInt(MXLEN.W))

	def genStrb: UInt = {	// generate 8bit mask
		val base = addr(2, 0)

		val width = MXLEN / 8
		val wstrb = WireInit(0.U(width.W))
		wstrb := {
			val tmp = MuxLookup(op(1, 0), 0.U, Array(
				"b00".U -> "b00000001".U(width.W), 
				"b01".U -> "b00000011".U(width.W), 
				"b10".U -> "b00001111".U(width.W), 
				"b11".U -> "b11111111".U(width.W), 
			))
			tmp << base
		}

		wstrb
	}

	def genData: UInt = {
		val base = addr(2, 0)

		MuxLookup(base, 0.U, Array(
			"b000".U -> (data), 
			"b001".U -> (data << 8), 
			"b010".U -> (data << 16), 
			"b011".U -> (data << 24), 
			"b100".U -> (data << 32), 
			"b101".U -> (data << 40), 
			"b110".U -> (data << 48), 
			"b111".U -> (data << 56), 
		))
	}
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

	io.read.bits.addr := Mux(sel, io.dread.bits.addr, 
			io.iread.bits.addr)
	io.read.bits.op := Mux(sel, io.dread.bits.op, 
			io.iread.bits.op)

	io.dread.bits.data 	:= io.read.bits.data
	io.iread.bits.data 	:= io.read.bits.data

	io.dread.bits.misalign := io.read.bits.misalign
	io.iread.bits.misalign := io.read.bits.misalign

	// `excp` is special, it's never asserted when the port is not selected
	io.dread.bits.excp := io.read.bits.excp && io.dread.valid
	io.iread.bits.excp := io.read.bits.excp && io.iread.valid
}

object Lsu {
	val ADDR 		= 32
	val DATA 		= MXLEN
	lazy val MASK 	= MXLEN / 8

	/* Memory Layout:
		RAM 		(0x8000_0000, 0x8fff_ffff)
		CHIPLINK 	(0x4000_0000, 0x7fff_ffff)
		SPI-flash 	(0x3000_0000, 0x3fff_ffff)
		SPI 		(0x1000_1000, 0x1000_1fff)
		UART 		(0x1000_0000, 0x1000_0fff)
		CLINT 		(0x0200_0000, 0x0200_ffff)
	*/
}
class Lsu extends Module {
	val io = IO(new Bundle {
		val iread = Flipped(ReadyValid(new LsuRead))
		val dread = Flipped(ReadyValid(new LsuRead))
		val dwrite = Flipped(ReadyValid(new LsuWrite))

		// connect to CLINT
		val clint = Flipped(new ClintPort(HARTNUM))
		val ram = Flipped(new SimRamPort)
	})

	val read = Wire(ReadyValid(new LsuRead));
	{ 		// use arbiter to clear conflicts between Iread and Dread
		val arbiter = Module(new LsuReadArbiter)
		arbiter.io.iread <> io.iread
		arbiter.io.dread <> io.dread
		read <> arbiter.io.read
	}
	val write = io.dwrite

	/* Check Misalignment */
	read.bits.misalign := read.bits.isMisalign
	write.bits.misalign := write.bits.isMisalign

	/* LSU should divide MMIO access into 3 parts:
		1. Access to RAM (AXI4 and cached)
		2. Access to peripherals (AXI4 but NOT cached)
		3. Access to CLINT (built in CPU, neither AXI4 nor cached)
	*/

	/* READ */
	val ren = !read.bits.misalign && read.valid
	val ren_clint = ren && MemLayout.sel_clint(read.bits.addr)
	val ren_ram = ren && MemLayout.sel_ram(read.bits.addr)

	// connect to CLINT
	io.clint.read.bits.addr := read.bits.addr
	io.clint.read.bits.op := read.bits.op
	io.clint.read.valid := ren_clint

	// connect to RAM
	io.ram.read.bits.addr := read.bits.addr
	io.ram.read.bits.op := read.bits.op
	io.ram.read.valid := ren_clint

	// select output signals
	read.ready := Mux(ren_clint, io.clint.read.ready, io.ram.read.ready)
	read.bits.data := Mux(ren_clint, io.clint.read.bits.genReadData, 
			io.ram.read.bits.genReadData)
	read.bits.excp := read.bits.isMisalign

	/* WRITE */
	val wen = !write.bits.misalign && write.valid
	val wen_clint = wen && MemLayout.sel_clint(write.bits.addr)
	val wen_ram = wen && MemLayout.sel_ram(write.bits.addr)

	// connect to CLINT
	io.clint.write.bits.addr := write.bits.addr
	io.clint.write.bits.wdata := write.bits.data
	io.clint.write.bits.wstrb := write.bits.genStrb
	io.clint.write.valid := wen_clint

	// connect to RAM
	io.ram.write.bits.addr := write.bits.addr
	io.ram.write.bits.wdata := write.bits.genData
	io.ram.write.bits.wstrb := write.bits.genStrb
	io.ram.write.valid := wen_ram

	// select output signals
	write.ready := Mux(wen_clint, io.clint.write.ready, io.ram.write.ready)
	write.bits.excp := write.bits.isMisalign && write.valid
}