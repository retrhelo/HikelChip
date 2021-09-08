package hikel.csr.machine

import chisel3._
import chisel3.util._

import hikel.csr.Csr._
import hikel.csr.CsrReg
import hikel.csr.CsrPort

class MVendorId extends CsrReg(MVENDORID) {
	io.read := 0.U
}

class MArchId extends CsrReg(MARCHID) {
	io.read := 0.U
}

class MImpId extends CsrReg(MIMPID) {
	io.read := 0.U
}

class MHartId(val hartid: Int) extends CsrReg(MHARTID) {
	io.read := hartid.U
}