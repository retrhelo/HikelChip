// System Information CSRs

package hikel.csr.machine

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.CsrReg

import freechips.rocketchip.rocket.CSRs

class MVendorId extends CsrReg(CSRs.mvendorid) {
	io.rdata 	:= 0.U
}

class MArchId extends CsrReg(CSRs.marchid) {
	io.rdata 	:= 0.U
}

class MImpId extends CsrReg(CSRs.mimpid) {
	io.rdata 	:= 0.U
}

class MHartId(val hartid: Int) extends CsrReg(CSRs.mhartid) {
	io.rdata 	:= hartid.U
}