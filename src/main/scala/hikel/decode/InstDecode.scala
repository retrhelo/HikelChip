package hikel.decode

import chisel3._

object InstDecode {
	val INST_LEN = 32

	// different types of instructions
	val ILL_TYPE 	= 0.U(3.W)
	val I_TYPE 		= 1.U(3.W)
	val S_TYPE 		= 2.U(3.W)
	val B_TYPE 		= 3.U(3.W)
	val U_TYPE 		= 4.U(3.W)
	val J_TYPE 		= 5.U(3.W)
	val CSR_TYPE 	= 7.U(3.W)
}