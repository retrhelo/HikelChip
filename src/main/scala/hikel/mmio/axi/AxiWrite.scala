package hikel.mmio.axi

import chisel3._
import chisel3.util._

import hikel.mmio.{AxiInterface => Axi}
import hikel.util.ReadyValid
import hikel.fufu.{LsuUnitWrite}

class WAddrPort extends Bundle {
	val awaddr 		= UInt(Axi.ADDR.W)
	val awid 		= UInt(Axi.ID.W)
	val awlen 		= UInt(8.W)
	val awsize 		= UInt(3.W)
	val awburst 	= UInt(Axi.BURST.W)
}

class WDataPort extends Bundle {
	val wdata 		= UInt(Axi.DATA.W)
	val wstrb 		= UInt(Axi.STRB.W)
	val wlast 		= Bool()
}

class WRespPort extends Bundle {
	val bresp 		= UInt(2.W)
	val bid 		= UInt(Axi.ID.W)
}

class AxiWrite(val id: Int) extends Module {
	val io = IO(new Bundle {
		val waddr = ReadyValid(Output(new WAddrPort))
		val wdata = ReadyValid(Output(new WDataPort))
		val wresp = Flipped(ReadyValid(Output(new WRespPort)))

		// interface to invalid
		val lsu_write = Flipped(ReadyValid(new LsuUnitWrite))
	})

	val reg_aw_w_valid = RegInit(false.B) 	// valid signal for both WADDR and WDATA
	val reg_bready = RegInit(false.B);
	{
		when (!(reg_aw_w_valid || reg_bready) && 
				io.lsu_write.valid) 
		{
			reg_aw_w_valid := true.B
			reg_bready := false.B
		}
		.elsewhen (io.waddr.hshake && io.wdata.hshake) {
			reg_aw_w_valid := false.B
			reg_bready := true.B
		}
		.elsewhen (io.lsu_write.ready) {
			reg_bready := false.B
		}
	}

	// ready/valid signals
	io.waddr.valid := reg_aw_w_valid
	io.wdata.valid := reg_aw_w_valid
	io.wresp.ready := reg_bready
	io.lsu_write.ready := io.wresp.hshake

	// connect to WADDR channel
	io.waddr.bits.awaddr := io.lsu_write.bits.addr
	io.waddr.bits.awid := id.U
	io.waddr.bits.awlen := 0.U
	io.waddr.bits.awsize := "b11".U
	io.waddr.bits.awburst := Axi.BURST_INCR

	// connect to WDATA channel
	io.wdata.bits.wdata := io.lsu_write.bits.wdata
	io.wdata.bits.wstrb := io.lsu_write.bits.wstrb
	io.wdata.bits.wlast := true.B
}


object AxiWriteGenVerilog extends App {
	(new chisel3.stage.ChiselStage).emitVerilog(new AxiWrite(0))
}