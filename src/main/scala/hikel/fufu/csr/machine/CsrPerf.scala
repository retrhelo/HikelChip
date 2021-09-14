// CSR registers for performance measurement

package hikel.fufu.csr.machine

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils

import freechips.rocketchip.rocket.CSRs

import hikel.Config._
import hikel.fufu.CsrReg

class MCycle extends CsrReg(CSRs.mcycle) {
	val mcycle = RegInit(0.U(MXLEN.W))
	io.rdata := mcycle

	BoringUtils.addSource(mcycle, "mcycle")

	// update cycle
	mcycle := mcycle + 1.U
}

class MInstret extends CsrReg(CSRs.minstret) {
	val minstret = RegInit(0.U(MXLEN.W))
	io.rdata := minstret

	val enable = Wire(Bool())
	// configure default connection for enable
	enable := false.B
	BoringUtils.addSink(enable, "minstret_en")

	when (enable) {
		minstret := minstret + 1.U
	}
}