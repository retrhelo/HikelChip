// Arithmetic and Logical Unit

package hikel.fufu

import chisel3._
import chisel3.util._

import hikel.Config._

class AluPort extends Bundle {
	val in 		= Input(new Bundle {
		val op 	= UInt(5.W)
		val in0 = UInt(MXLEN.W)
		val in1 = UInt(MXLEN.W)
	})
	val res 	= Output(UInt(MXLEN.W))
}

object Alu {
	val ADD 	= "b000".U
	val SLT 	= "b010".U
	val SLTU 	= "b011".U
	val XOR 	= "b100".U
	val OR 		= "b110".U
	val AND 	= "b111".U
	val SLL 	= "b001".U
	val SRL 	= "b101".U
}
import Alu._

class Alu extends RawModule {
	val io = IO(new AluPort)

	val op 		= io.in.op(2, 0)
	val arith 	= io.in.op(3)
	val word 	= io.in.op(4)

	val in0 = io.in.in0
	val in1 = Mux(arith, ~io.in.in1 + 1.U, io.in.in1)
	val shmt = io.in.in1(log2Ceil(MXLEN)-1, 0)
	val res = MuxLookup(op, 0.U, Array(
		ADD 	-> (in0 + in1), 
		SLT 	-> (in0.asSInt < in1.asSInt), 
		SLTU 	-> (in0 < in1), 
		XOR 	-> (in0 ^ in1), 
		OR 		-> (in0 | in1), 
		AND 	-> (in0 & in1), 
		SLL 	-> (in0 << shmt), 
		SRL 	-> Mux(arith, (in0.asSInt >> shmt).asUInt, in0 >> shmt), 
	))

	io.res := Mux(word, Cat(Fill(MXLEN-32, res(31)), res), res)
}


import chisel3.stage.ChiselStage
object AluGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Alu, BUILD_ARG)
}