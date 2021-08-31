// A test for ALU

package test 

import chiseltest._
import org.scalatest._ 
import chisel3._

import hikel.Alu

class AluTest extends FlatSpec with ChiselScalatestTester with Matchers {
	val ADD 	= "b000".U
	val SLT 	= "b010".U
	val SLTU 	= "b011".U
	val AND 	= "b111".U
	val OR 		= "b110".U
	val XOR 	= "b100".U
	val SLL 	= "b001".U
	val SRL 	= "b101".U

	behavior of "AluTest"
	it should "test ALU" in {
		test(new Alu) { c => 
			// initialization 
			c.io.arith.poke(false.B)
			c.io.word.poke(false.B)
			c.io.shmt.poke(0.U)

			// add: 15 + 12
			c.io.op.poke(ADD)
			c.io.in0.poke(15.U)
			c.io.in1.poke(12.U)
			c.io.result.expect(27.U)

			// addw: 
			// I can't think about some good test now 

			// sub: 15 - 12
			c.io.arith.poke(true.B)
			c.io.result.expect(3.U)

			// sltu 
			c.io.arith.poke(false.B)
			c.io.op.poke(SLT)
			c.io.in0.poke(12.U)
			c.io.in1.poke(14.U)
			c.io.result.expect(1.U)

			c.io.in0.poke(18.U)
			c.io.in1.poke(1.U)
			c.io.result.expect(0.U)

			// slt
			// unfortunately we can't test slt, 
			// because I have no idea how to pass signed integers into the module

			// logical and 
			c.io.op.poke(AND)
			c.io.in0.poke(0xfc.U)
			c.io.in1.poke(0xcf.U)
			c.io.result.expect(0xcc.U)

			// logical or 
			c.io.op.poke(OR)
			c.io.in0.poke(0xf0.U)
			c.io.in1.poke(0x0f.U)
			c.io.result.expect(0xff.U)

			// logical xor 
			c.io.op.poke(XOR)
			c.io.in0.poke(0xf0.U)
			c.io.in1.poke(0xff.U)
			c.io.result.expect(0x0f.U)

			// srl 
			c.io.op.poke(SLL)
			c.io.in0.poke(0xff.U)
			c.io.shmt.poke(16.U)
			c.io.result.expect(0xff0000.U)

			// srl 
			c.io.op.poke(SRL)
			c.io.in0.poke(0xff00.U)
			c.io.shmt.poke(16.U)
			c.io.result.expect(0x00.U)

			// sra 
			// for the same reason with SLT, we can't test it now
		}
	}
}