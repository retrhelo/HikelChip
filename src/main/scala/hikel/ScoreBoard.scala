package hikel

import chisel3._
import chisel3.util._

import hikel.Config._

class ScoreBoardPort extends Bundle {
	val rs1_addr 	= Input(UInt(RegFile.ADDR.W))
	val rs2_addr 	= Input(UInt(RegFile.ADDR.W))
	// the address to lock
	val rd_addr 	= Input(UInt(RegFile.ADDR.W))

	// other FU
	val csr_use 	= Input(Bool())
	val lsu_use 	= Input(Bool())

	// Issue stage should make sure only ONE port can be valid
	val valid 		= Input(Bool())
	val ready 		= Output(Bool())
}

class ScoreBoardCommit extends Bundle {
	val rd_addr 	= Input(UInt(RegFile.ADDR.W))
	val csr_use 	= Input(Bool())
	val lsu_use 	= Input(Bool())
}

class ScoreBoard extends Module {
	val io = IO(new Bundle {
		val ports = Vec(Rob.NUM, new ScoreBoardPort)
		val commit = new ScoreBoardCommit
	})

	val reg_avail 	= RegInit(VecInit(Seq.fill(RegFile.NUM)(true.B)))
	val reg_csr 	= RegInit(true.B)
	val reg_lsu 	= RegInit(true.B)
	// generate ok signals
	for (i <- 0 until Rob.NUM) {
		val port = io.ports(i)

		val rs1_ok = (0.U === port.rs1_addr) || reg_avail(port.rs1_addr)
		val rs2_ok = (0.U === port.rs2_addr) || reg_avail(port.rs2_addr)

		// other fu
		val csr_ok = !port.csr_use || reg_csr
		val lsu_ok = !port.lsu_use || reg_lsu

		// acquire
		port.ready := rs1_ok && rs2_ok && csr_ok && lsu_ok
		when (port.ready && port.valid) {
			reg_avail(port.rd_addr) := 0.U === port.rd_addr && reg_avail(port.rd_addr)
			reg_csr := !port.csr_use && reg_csr
			reg_lsu := !port.lsu_use && reg_lsu
		}
	}

	// release port
	when (0.U =/= io.commit.rd_addr) {
		reg_avail(io.commit.rd_addr) := true.B
	}
	when (io.commit.lsu_use) {
		reg_lsu := true.B
	}
	when (io.commit.csr_use) {
		reg_csr := true.B
	}
}


import chisel3.stage.ChiselStage
object ScoreBoardGenVerilog extends App {
	(new ChiselStage).emitVerilog(new ScoreBoard, BUILD_ARG)
}