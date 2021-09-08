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
	//                 |  |  |  | jalr|   store|  |  |  |  |    |    | rs1
	//                 |  |  |  |  |  | load|  |  |  |  |  |    |    |  |
	val default = List(Y, N, N, N, N, N, N, N, N, N, N, N, N, IMM_X, N, N)
	val table = Array(
		LUI    -> List(N, Y, N, N, N, N, N, N, N, N, N, N, Y, IMM_U, N, N), 
		AUIPC  -> List(N, N, Y, N, N, N, N, N, N, N, N, N, Y, IMM_U, N, N), 
		JAL    -> List(N, N, N, Y, N, N, N, N, N, N, N, N, Y, IMM_J, N, N), 
		JALR   -> List(N, N, N, N, Y, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		BEQ    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y), 
		BNE    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y), 
		BLT    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y), 
		BGE    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y), 
		BLTU   -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y), 
		BGEU   -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y), 
		LB     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y), 
		LH     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y), 
		LW     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y), 
		LBU    -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y), 
		LHU    -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y), 
		LWU    -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y), 
		LD     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y), 
		SB     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y, Y), 
		SH     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y, Y), 
		SW     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y, Y), 
		SD     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y, Y), 
		ADDI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		ADDIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		SLTI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		SLTIU  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		XORI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		ORI    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		ANDI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		SLLI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		SLLIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		SRLI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		SRLIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		SRAI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		SRAIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y), 
		ADD    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		ADDW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		SUB    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		SUBW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		SLL    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		SLLW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		SLT    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		SLTU   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		XOR    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		SRL    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		SRLW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		SRA    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		SRAW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		OR     -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		AND    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y), 
		FENCE  -> List(N, N, N, N, N, N, N, N, N, N, N, Y, N, IMM_X, N, N), 
		ECALL  -> List(N, N, N, N, N, N, N, N, N, Y, N, N, N, IMM_X, N, N), 
		EBREAK -> List(N, N, N, N, N, N, N, N, N, N, Y, N, N, IMM_X, N, N), 
		CSRRW  -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_X, N, Y), 
		CSRRS  -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_X, N, Y), 
		CSRRC  -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_X, N, Y), 
		CSRRWI -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_Z, N, N), 
		CSRRSI -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_Z, N, N), 
		CSRRCI -> List(N, N, N, N, N, N, N, N, Y, N, N, N, N, IMM_Z, N, N), 
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
	val rs1_use 	= Bool()	// do use rs1?
	val rs2_use 	= Bool() 	// use imm instead of rs2?
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
	io.out.rs2_use 	:= list(14)
	io.out.rs1_use 	:= list(15)
}


import chisel3.stage.ChiselStage
object InstDecodeGenVerilog extends App {
	(new ChiselStage).emitVerilog(new InstDecode, BUILD_ARG)
}