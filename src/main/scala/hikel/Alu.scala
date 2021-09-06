// Arithmetic Logic Unit

package hikel

import chisel3._
import chisel3.util._

import Config._

// The Alu op is extracted directly from inst[14:12]
object Alu {
	val ALU_ADD 	= "b000".U(UOP.W)
	val ALU_SLT 	= "b010".U(UOP.W)
	val ALU_SLTU	= "b011".U(UOP.W)
	val ALU_XOR		= "b100".U(UOP.W)
	val ALU_OR 		= "b110".U(UOP.W)
	val ALU_AND		= "b111".U(UOP.W)
	val ALU_SLL		= "b001".U(UOP.W)
	val ALU_SRL 	= "b101".U(UOP.W)
}
import Alu._

class AluExt extends Bundle {
	val arith	= Bool()			// arithmetic
	val word 	= Bool()			// word operation
	val shmt 	= UInt(SHMT.W)
}

class AluPortIn extends Bundle {
	val in0 	= Input(UInt(MXLEN.W))
	val in1 	= Input(UInt(MXLEN.W))
	val op 		= Input(UInt(3.W))
	val ext 	= Input(new AluExt)
}

class AluPort extends Bundle {
	val in = new AluPortIn
	val result = Output(UInt(MXLEN.W))
}

class Alu extends RawModule {
	val io = IO(new AluPort)

	// in case of sub, io.arith is asserted
	val in1 = Mux(io.in.ext.arith, ~io.in.in1 + 1.U, io.in.in1)

	val result = MuxLookup(io.in.op, 0.U, Array(
		ALU_ADD 	-> (io.in.in0 + in1),
		ALU_SLT 	-> (io.in.in0.asSInt < in1.asSInt),
		ALU_SLTU 	-> (io.in.in0 < in1),
		ALU_XOR 	-> (io.in.in0 ^ in1),
		ALU_OR 		-> (io.in.in0 | in1),
		ALU_AND 	-> (io.in.in0 & in1),
		ALU_SLL 	-> (io.in.in0 << io.in.ext.shmt),
		ALU_SRL 	-> Mux(io.in.ext.arith, (io.in.in0.asSInt >> io.in.ext.shmt).asUInt, 
							io.in.in0 >> io.in.ext.shmt)
	))

	io.result := Mux(io.in.ext.word, 
		Cat(Fill(MXLEN-32, result(31)), result(31, 0)), 
		result
	)
}

import chisel3.stage.ChiselStage
object AluGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Alu, BUILD_ARG)
}