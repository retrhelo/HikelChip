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
	//                 |  |  | jal    |       csr |  |  |  |    |   rs2        mret
	//                 |  |  |  | jalr|   store|  |  |  |  |    |    | rs1   word|
	//                 |  |  |  |  |  | load|  |  |  |  |  |    |    |  |arith|  |
	val default = List(Y, N, N, N, N, N, N, N, N, N, N, N, N, IMM_X, N, N, N, N, N)
	val table = Array(
		LUI    -> List(N, Y, N, N, N, N, N, N, N, N, N, N, Y, IMM_U, N, Y, N, N, N), 
		AUIPC  -> List(N, N, Y, N, N, N, N, N, N, N, N, N, Y, IMM_U, N, N, N, N, N), 
		JAL    -> List(N, N, N, Y, N, N, N, N, N, N, N, N, Y, IMM_J, N, N, N, N, N), 
		JALR   -> List(N, N, N, N, Y, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		BEQ    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y, N, N, N), 
		BNE    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y, N, N, N), 
		BLT    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y, N, N, N), 
		BGE    -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y, N, N, N), 
		BLTU   -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y, N, N, N), 
		BGEU   -> List(N, N, N, N, N, Y, N, N, N, N, N, N, N, IMM_B, Y, Y, N, N, N), 
		LB     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		LH     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		LW     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		LBU    -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		LHU    -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		LWU    -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		LD     -> List(N, N, N, N, N, N, Y, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		SB     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y, Y, N, N, N), 
		SH     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y, Y, N, N, N), 
		SW     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y, Y, N, N, N), 
		SD     -> List(N, N, N, N, N, N, N, Y, N, N, N, N, N, IMM_S, Y, Y, N, N, N), 
		ADDI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		ADDIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, Y, N), 
		SLTI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		SLTIU  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		XORI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		ORI    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		ANDI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		SLLI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		SLLIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, Y, N), 
		SRLI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, N, N), 
		SRLIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, N, Y, N), 
		SRAI   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, Y, N, N), 
		SRAIW  -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_I, N, Y, Y, Y, N), 
		ADD    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, N, N, N), 
		ADDW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, N, Y, N), 
		SUB    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, Y, N, N), 
		SUBW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, Y, Y, N), 
		SLL    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, N, N, N), 
		SLLW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, N, Y, N), 
		SLT    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, N, N, N), 
		SLTU   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, N, N, N), 
		XOR    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, N, N, N), 
		SRL    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, N, N, N), 
		SRLW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, N, Y, N), 
		SRA    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, Y, N, N), 
		SRAW   -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, Y, Y, N), 
		OR     -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, N, N, N), 
		AND    -> List(N, N, N, N, N, N, N, N, N, N, N, N, Y, IMM_X, Y, Y, N, N, N), 
		FENCE  -> List(N, N, N, N, N, N, N, N, N, N, N, Y, N, IMM_X, N, N, N, N, N), 
		ECALL  -> List(N, N, N, N, N, N, N, N, N, Y, N, N, N, IMM_X, N, N, N, N, N), 
		EBREAK -> List(N, N, N, N, N, N, N, N, N, N, Y, N, N, IMM_X, N, N, N, N, N), 
		MRET   -> List(N, N, N, N, N, N, N, N, N, N, N, N, N, IMM_X, N, N, N, N, Y), 
		CSRRW  -> List(N, N, N, N, N, N, N, N, Y, N, N, N, Y, IMM_X, N, Y, N, N, N), 
		CSRRS  -> List(N, N, N, N, N, N, N, N, Y, N, N, N, Y, IMM_X, N, Y, N, N, N), 
		CSRRC  -> List(N, N, N, N, N, N, N, N, Y, N, N, N, Y, IMM_X, N, Y, N, N, N), 
		CSRRWI -> List(N, N, N, N, N, N, N, N, Y, N, N, N, Y, IMM_Z, N, N, N, N, N), 
		CSRRSI -> List(N, N, N, N, N, N, N, N, Y, N, N, N, Y, IMM_Z, N, N, N, N, N), 
		CSRRCI -> List(N, N, N, N, N, N, N, N, Y, N, N, N, Y, IMM_Z, N, N, N, N, N), 
		FENCE_I-> List(N, N, N, N, N, N, N, N, N, N, N, N, N, IMM_X, N, N, N, N, N), 
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
	val mret 		= Bool()
	val fence 		= Bool()

	val rd_wen 		= Bool()
	val imm_type 	= UInt(3.W)
	val rs1_use 	= Bool()	// do use rs1?
	val rs2_use 	= Bool() 	// use imm instead of rs2?

	val arith 		= Bool() 	// is this an arithmetic instruction
	val word 		= Bool() 	// word 
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
	io.out.arith 	:= list(16)
	io.out.word 	:= list(17)
	io.out.mret 	:= list(18)
}