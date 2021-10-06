// READ part of Axi4 interface

package hikel.fufu.mmio.axi

import chisel3._
import chisel3.util._

import hikel.fufu.mmio.{AxiInterface => Axi}
import hikel.util.ReadyValid
import hikel.fufu.{LsuUnitRead}

class RAddrPort extends Bundle {
	val araddr 		= UInt(Axi.ADDR.W)
	val arid 		= UInt(Axi.ID.W)
	val arlen 		= UInt(8.W)
	val arsize 		= UInt(3.W)
	val arburst 	= UInt(Axi.BURST.W)
}

class RDataPort extends Bundle {
	val rresp 		= UInt(Axi.RESP.W)
	val rdata 		= UInt(Axi.DATA.W)
	val rlast 		= Bool()
	val rid 		= UInt(Axi.ID.W)
}

class AxiRead(val id: Int) extends Module {
	val io = IO(new Bundle {
		val raddr = ReadyValid(Output(new RAddrPort))
		val rdata = Flipped(ReadyValid(Output(new RDataPort)))

		// the interface for CPU
		val lsu_read = Flipped(ReadyValid(new LsuUnitRead {
			override def genReadData = {
				val signed = !op(2)
				val width = op(1, 0)

				MuxLookup(width, 0.U, Array(
					"b00".U -> Cat(Fill(Axi.DATA - 8, rdata(7) & signed), rdata(7, 0)), 
					"b01".U -> Cat(Fill(Axi.DATA - 16, rdata(15) & signed), rdata(15, 0)), 
					"b10".U -> Cat(Fill(Axi.DATA - 32, rdata(31) & signed), rdata(31, 0)), 
					"b11".U -> rdata, 
				))
			}
		}))
	})

	// state machine
	val reg_araddr = RegInit(0.U(Axi.ADDR.W))
	val reg_arvalid = RegInit(false.B)
	val reg_rready = RegInit(false.B);
	{
		when (!(reg_arvalid || reg_rready) && io.lsu_read.valid) {
			// start a new transaction
			reg_araddr := io.lsu_read.bits.addr
			reg_arvalid := true.B
		}
		.elsewhen (io.raddr.hshake) {
			reg_arvalid := false.B
			reg_rready := true.B
		}
		.elsewhen (io.rdata.hshake && io.rdata.bits.rlast) { // transaction done
			reg_rready := false.B
		}
	}

	// connect ready/valid signals
	io.raddr.valid := reg_arvalid
	io.rdata.ready := reg_rready
	io.lsu_read.ready := io.rdata.hshake && io.rdata.bits.rlast && 
			reg_araddr === io.lsu_read.bits.addr

	// connect to RADDR
	io.raddr.bits.araddr 	:= reg_araddr
	io.raddr.bits.arid 		:= id.U
	io.raddr.bits.arlen 	:= 0.U 		// number of transfer in burst transation
	io.raddr.bits.arsize 	:= "b11".U
	io.raddr.bits.arburst 	:= Axi.BURST_INCR

	// connect RDATA
	io.lsu_read.bits.rdata := io.rdata.bits.rdata
	io.lsu_read.bits.excp := Axi.RESP_OKAY =/= io.rdata.bits.rresp
}