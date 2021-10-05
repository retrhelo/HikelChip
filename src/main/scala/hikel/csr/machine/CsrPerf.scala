// CSR registers for performance measurement

package hikel.csr.machine

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils._

import freechips.rocketchip.rocket.CSRs

import hikel.Config._
import hikel.CsrReg

class MCycle extends CsrReg(CSRs.mcycle) {
	val mcycle = RegInit(0.U(MXLEN.W))

	// connect to outside
	io.rdata := mcycle
	if (YSYX_DIFFTEST) {
		addSource(io.rdata, "mcycle")
	}

	// update cycle
	mcycle := mcycle + 1.U
}

class MInstret extends CsrReg(CSRs.minstret) {
	val minstret = RegInit(0.U(MXLEN.W))
	
	io.rdata := minstret
	if (YSYX_DIFFTEST) {
		addSource(io.rdata, "minstret")
	}

	val enable = WireInit(false.B)
	addSink(enable, "minstret_en")

	when (enable) {
		minstret := minstret + 1.U
	}
}