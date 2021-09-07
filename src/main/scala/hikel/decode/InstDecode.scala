// decode input instruction
// Generate some raw signals for Decode stage

package hikel.decode

import chisel3._
import chisel3.util._

import freechips.rocketchip.rocket.Instructions._

import hikel.Config._

object InstDecode {
	val Y = true.B
	val N = false.B

	// imm_sel
	val IMM_X 	= 0.U(3.W)
	val IMM_I 	= 1.U(3.W)
	val IMM_S 	= 2.U(3.W)
	val IMM_U 	= 3.U(3.W)
	val IMM_J 	= 4.U(3.W)
	val IMM_B 	= 5.U(3.W)
	val IMM_Z 	= 6.U(3.W)

	//               illegal                         fence
	//                 | lui                      ebreak| wen
	//                 |  | auipc     br        ecall|  |  | imm_type
	//                 |  |  | jal    |       csr |  |  |  |    |   rs2
	//                 |  |  |  | jalr|   store|  |  |  |  |    |    |
	//                 |  |  |  |  |  | load|  |  |  |  |  |    |    |
	val default = List(Y, N, N, N, N, N, N, N, N, N, N, N, N, IMM_X, N)
	val table = Array(
		LUI    -> List(N, Y, N, N, N, N, N, N, N, N, N, N, Y, IMM_U, N), 
		AUIPC  -> List(N, N, Y, N, N, N, N, N, N, N, N, N, Y, IMM_U, N), 
		JAL    -> List(N, N, N, Y, N, N, N, N, N, N, N, N, Y, IMM_J, N), 
		JALR   -> List(N, N, N, N, Y, N, N, N, N, N, N, N, Y, IMM_I, N), 
		BEQ    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y), 
		BNE    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y), 
		BLT    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y), 
		BGE    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y), 
		BLTU   -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y), 
		BGEU   -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y), 
		LB     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N), 
		LH     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N), 
		LW     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N), 
		LBU    -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N), 
		LHU    -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N), 
		LWU    -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N), 
		LD     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N), 
		SB     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y), 
		SH     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y), 
		SW     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y), 
		SD     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y), 
		ADDI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		ADDIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		SLTI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		SLTIU  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		XORI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		ORI    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		ANDI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		SLLI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		SLLIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		SRLI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		SRLIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		SRAI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		SRAIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N), 
		ADD    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		ADDW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		SUB    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		SUBW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		SLL    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		SLLW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		SLT    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		SLTU   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		XOR    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		SRL    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		SRLW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		SRA    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		SRAW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		OR     -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		AND    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y), 
		FENCE  -> List(N, N, N, N, N, N, N, N, N, N, N, Y, N, IMM_X, N), 
		ECALL  -> List(N, N, N, N, N, N, N, N, N, Y, N, N, N, IMM_X, N), 
		EBREAK -> List(N, N, N, N, N, N, N, N, N, N, Y, N, N, IMM_X, N), 
		CSRRW  -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_X, N), 
		CSRRS  -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_X, N), 
		CSRRC  -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_X, N), 
		CSRRWI -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_Z, N), 
		CSRRSI -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_X, N), 
		CSRRCI -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_X, N), 
	)
}
import InstDecode._

class InstDecodeOut extends Bundle {
	val illegal 	= Bool()
	val lui 		= Bool()
	val auipc 		= Bool()
	val jal 		= Bool()
	val jalr 		= Bool()
	val branch 		= Bool()
	val load 		= Bool()
	val store 		= Bool()
	val csr 		= Bool()	// when use csr, it's always written
	val ecall 		= Bool()
	val ebreak 		= Bool()
	val fence 		= Bool()

	val rd_wen 		= Bool()
	val imm_type 	= UInt(3.W)
	val rs2_sel 	= Bool() 	// use imm instead of rs2?
}

class InstDecode extends RawModule {
	val io = IO(new Bundle {
		val inst = Input(UInt(INST.W))
		val out = Output(new InstDecodeOut)
	})

	val list = ListLookup(io.inst, default, table)
	// link out
	io.out.illegal 	:= list(0)
	io.out.lui 		:= list(1)
	io.out.auipc 	:= list(2)
	io.out.jal 		:= list(3)
	io.out.jalr 	:= list(4)
	io.out.branch 	:= list(5)
	io.out.load 	:= list(6)
	io.out.store 	:= list(7)
	io.out.csr 		:= list(8)
	io.out.ecall 	:= list(9)
	io.out.ebreak 	:= list(10)
	io.out.fence 	:= list(11)
	io.out.rd_wen 	:= list(12)
	io.out.imm_type := list(13)
	io.out.rs2_sel 	:= list(14)
}


import chisel3.stage.ChiselStage
object InstDecodeGenVerilog extends App {
	(new ChiselStage).emitVerilog(new InstDecode, BUILD_ARG)
}