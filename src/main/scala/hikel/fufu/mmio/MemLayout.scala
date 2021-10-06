package hikel.fufu.mmio

import chisel3._
import chisel3.util._

import hikel.fufu.Lsu.MASK

object MemLayout {
	val CLINT_BASE 		= BigInt("02000000", 16)

	// `addr` should be Config.ADDR in width

	def sel_clint(addr: UInt): Bool = {
		CLINT_BASE.U(31, 16) === addr(31, 16)
	}

	def sel_axi(addr: UInt): Bool = {
		!sel_clint(addr)
	}
}