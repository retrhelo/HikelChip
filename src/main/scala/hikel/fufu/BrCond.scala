// Branch Control

package hikel.fufu

import chisel3._
import chisel3.util._

import hikel.Config._

class BrCondPort extends Bundle {
	val in0 	= UInt(MXLEN.W)
	val in1 	= UInt(MXLEN.W)
	val pc 		= UInt(PC.W)
	val imm 	= UInt(IMM.W)
	val uop 	= UInt(5.W)
	val sel 	= Bool()
}

class BrCond extends RawModule {
	val io = IO(new Bundle {
		val in 			= Input(new BrCondPort)
		val change_pc 	= Output(Bool())
		val new_pc 		= Output(UInt(PC.W))
	})

	val jal 		= io.in.uop(4)
	val jalr 		= io.in.uop(3)
	val lt 			= io.in.uop(2)
	val unsigned 	= io.in.uop(1)		// is the operand unsigned?
	val not 		= io.in.uop(0)

	// jump
	val do_jump = jal || jalr
	// branch
	val do_eql = io.in.in0 === io.in.in1
	val do_lt = Mux(unsigned, io.in.in0 < io.in.in1, 
			io.in.in0.asSInt < io.in.in1.asSInt)
	val do_branch = not ^ Mux(lt, do_lt, do_eql)

	io.change_pc := (do_jump || do_branch) && io.in.sel
	io.new_pc := Mux(jalr, io.in.in0 + io.in.imm, 
			io.in.pc + io.in.imm)
}