// Arithmetic Logic Unit

package hikel

import chisel3._
import chisel3.util._

import Config.MXLEN

// The Alu op is extracted directly from inst[14:12]
object Alu {
	val ALU_ADD 	= "b000".U(3.W)
	val ALU_SLT 	= "b010".U(3.W)
	val ALU_SLTU	= "b011".U(3.W)
	val ALU_XOR		= "b100".U(3.W)
	val ALU_OR 		= "b110".U(3.W)
	val ALU_AND		= "b111".U(3.W)
	val ALU_SLL		= "b001".U(3.W)
	val ALU_SRL 	= "b101".U(3.W)
}
import Alu._

class AluPortIn extends Bundle {
	val op 		= Input(UInt(3.W))
	val arith 	= Input(Bool())			// arithmetic
	val word 	= Input(Bool()) 		// word operation
	val in0 	= Input(UInt(MXLEN.W))
	val in1 	= Input(UInt(MXLEN.W))
	val shmt 	= Input(UInt(log2Ceil(MXLEN).W))
}

class AluPort extends Bundle {
	val in = new AluPortIn
	val result = Output(UInt(MXLEN.W))
}

class Alu extends RawModule {
	val io = IO(new AluPort)

	// in case of sub, io.arith is asserted
	val in1 = Mux(io.in.arith, ~io.in.in1 + 1.U, io.in.in1)

	val result = MuxLookup(io.in.op, 0.U, Array(
		ALU_ADD 	-> (io.in.in0 + in1),
		ALU_SLT 	-> (io.in.in0.asSInt < in1.asSInt),
		ALU_SLTU 	-> (io.in.in0 < in1),
		ALU_XOR 	-> (io.in.in0 ^ in1),
		ALU_OR 		-> (io.in.in0 | in1),
		ALU_AND 	-> (io.in.in0 & in1),
		ALU_SLL 	-> (io.in.in0 << io.in.shmt),
		ALU_SRL 	-> Mux(io.in.arith, (io.in.in0.asSInt >> io.in.shmt).asUInt, 
							io.in.in0 >> io.in.shmt)
	))

	io.result := Mux(io.in.word, 
		Cat(Fill(MXLEN-32, result(31)), result(31, 0)), 
		result
	)
}

import chisel3.stage.ChiselStage
import hikel.Config.BUILD_ARG
object AluGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Alu, BUILD_ARG)
}