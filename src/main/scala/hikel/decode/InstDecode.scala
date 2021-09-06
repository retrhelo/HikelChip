// decode input instruction

package hikel.decode

import chisel3._
import chisel3.util._

import freechips.rocketchip.rocket.Instructions._

import hikel.Config._

object InstDecode {
	val X = BitPat("b?")
	val Y = BitPat("b1")
	val N = BitPat("b0")

	//               illegal
	//                 |
	// val default = List(Y, )
}

class InstDecodeIn extends Bundle {
	val inst = UInt(INST.W)
}

class InstDecodeOut extends Bundle {
	val lui 		= Bool()
	val auipc 		= Bool()
	val jal 		= Bool()
	val jalr 		= Bool()
	val branch 		= Bool()
	val lsu_ren 	= Bool()
	val lsu_wen 	= Bool()
	val csr_en 		= Bool()	// when use csr, it's always written
}

class InstDecode extends RawModule {
	val io = IO(new Bundle {
		val in = new InstDecodeIn
		val out = new InstDecodeOut
	})


}


import chisel3.stage.ChiselStage
object InstDecodeGenVerilog extends App {
	(new ChiselStage).emitVerilog(new InstDecode, BUILD_ARG)
}