package hikel

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.decode.MicroOp

class RobIn extends Bundle {
	val uop 	= Input(new MicroOp)
}

class RobOut extends Bundle {
	val uop 	= Output(new MicroOp)
	val ready 	= Output(Bool())
	val num 	= Output(UInt(Rob.ADDR.W))
}

class RobCommit extends Bundle {
	val valid 	= Input(Bool())
	val id 		= Input(UInt(Rob.ADDR.W))
}

object Rob {
	val NUM 	= 1
	val ADDR 	= log2Ceil(NUM)
}

private class RobUnit extends Bundle {
	val uop 	= new MicroOp
	val issue 	= Bool()
	val free 	= Bool()
}

class Rob extends Module {
	val io = IO(new Bundle {
		val in = new RobIn
		val out = new RobOut
		val commit = new RobCommit
	})
}