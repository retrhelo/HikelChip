// Instruction Decoder 

package hikel

import chisel3._

class InstDec extends Module {
	val io = IO(new Bundle {
		val inst = Input(UInt(32.W))
	})

	// Is this instruction a compressed one?
	// val is_compress = 0x3.U === inst 
}