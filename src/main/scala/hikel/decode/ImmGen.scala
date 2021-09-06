package hikel.decode

import chisel3._
import chisel3.util._

import hikel.Config._

import hikel.decode.InstDecode._

class ImmGenPort extends Bundle {
	val inst 	= Input(UInt(INST.W))
	val itype 	= Input(UInt(3.W))
	val imm32 	= Output(UInt(32.W))
}

// extract 32bit immediate from instruction
class ImmGen extends RawModule {
	val io = IO(new ImmGenPort)

	val i_imm32 = Cat(
		Fill(21, io.inst(31)), 
		io.inst(30, 25), io.inst(24, 21), io.inst(20)
	)
	val s_imm32 = Cat(
		Fill(21, io.inst(31)), 
		io.inst(30, 25), io.inst(11, 8), io.inst(7)
	)
	val b_imm32 = Cat(
		Fill(20, io.inst(31)), 
		io.inst(7), io.inst(30, 25), io.inst(11, 8), 0.U(1.W)
	)
	val u_imm32 = Cat(
		io.inst(31), io.inst(30, 20), io.inst(19, 12), 
		Fill(12, 0.U)
	)
	val j_imm32 = Cat(
		Fill(12, io.inst(31)), 
		io.inst(19, 12), io.inst(20), io.inst(30, 25), 
		io.inst(24, 21), 0.U(1.W)
	)
	// special for CSR instructions 
	val csr_imm32 = Cat(Fill(27, 0.U), io.inst(19, 15))

	// select among different instruction types 
	// val table = Array(
	// 	I_TYPE -> i_imm32, 
	// 	S_TYPE -> s_imm32, 
	// 	B_TYPE -> b_imm32, 
	// 	U_TYPE -> u_imm32, 
	// 	J_TYPE -> j_imm32, 
	// 	CSR_TYPE -> csr_imm32, 
	// )

	// io.imm32 := MuxLookup(io.itype, 0.U, table)
}


import chisel3.stage.ChiselStage
import hikel.Config.BUILD_ARG
object ImmGenGenVerilog extends App {
	(new ChiselStage).emitVerilog(new ImmGen, BUILD_ARG)
}