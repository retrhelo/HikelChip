// Common interface and behavior of AXI4 bus.

package hikel.axi

import chisel3._

import hikel.Config._

object Axi4 {
	val ID		 			= 4
	val ADDR	 			= MXLEN
	val DATA 				= MXLEN
	val BURST_LEN 			= 8		// burst length width
	val BURST_SZ 			= 3		// burst size width
	val BURST_TYPE 			= 2 	// burst type width
	val BURST_TYPE_FIXED 	= "b00".U
	val BURST_TYPE_INCR 	= "b01".U
	val BURST_TYPE_WRAP 	= "b10".U
	val MEM_TYPE 			= 4		// memory type width
	val QOS		 			= 4		// quality of service width
	val STROBE 				= MXLEN / 8
	val RESP 				= 2
	val RESP_OKAY 			= "b00".U
	val RESP_EXOKAY 		= "b01".U
	val RESP_SLVERR 		= "b10".U
	val RESP_DECERR 		= "b11".U
}

// To be simple, all channels below are originally written from MASTER's view, 
// for slave use, try Flipped() to flip the ports. 

// Write Address Channel
class WADDR extends Bundle {
	val awid 	= Output(UInt(Axi4.ID.W))			// write address id
	val awaddr 	= Output(UInt(Axi4.ADDR.W))			// write address
	val awlen 	= Output(UInt(Axi4.BURST_LEN.W))	// burst length
	val awsize 	= Output(UInt(Axi4.BURST_SZ.W))		// burst size
	val awburst = Output(UInt(Axi4.BURST_TYPE.W))	// burst type
	val awcache = Output(UInt(Axi4.MEM_TYPE.W))		// memory type
	val awqos 	= Output(UInt(Axi4.QOS.W))			// quality of service
	val awvalid = Output(Bool())					// write address valid
	val awready = Input(Bool())						// write address ready
}

// Write Data Channel
class WDATA extends Bundle {
	val wid 	= Output(UInt(Axi4.ID.W))			// write id
	val wdata 	= Output(UInt(Axi4.DATA.W))			// write data
	val wstrb 	= Output(UInt(Axi4.STROBE.W))		// write strobes
	val wlast 	= Output(Bool())					// write last, indicates the last transfer in a write burst
	val wvalid 	= Output(Bool())					// write valid
	val wready 	= Input(Bool())						// write ready
}

// Write Response Channel
class WRESP extends Bundle {
	val bid 	= Input(UInt(Axi4.ID.W))			// response id
	val bresp 	= Input(UInt(Axi4.RESP.W))			// write response
	val bvalid 	= Input(Bool())						// write response valid
	val bready 	= Output(Bool())					// response ready
}

// Read Address Channel
class RADDR extends Bundle {
	val arid 	= Output(UInt(Axi4.ID.W))			// read address id
	val araddr 	= Output(UInt(Axi4.DATA.W))			// read address
	val arlen 	= Output(UInt(Axi4.BURST_LEN.W)) 	// burst length
	val arsize 	= Output(UInt(Axi4.BURST_SZ.W))		// burst size
	val arburst = Output(UInt(Axi4.BURST_TYPE.W))	// burst type
	val arcache = Output(UInt(Axi4.MEM_TYPE.W))		// memory type
	val arqos 	= Output(UInt(Axi4.QOS.W))			// quality of service
	val arvalid = Output(Bool())					// read address valid
	val arready = Output(Bool())					// read address ready
}

// Read Data Channel
class RDATA extends Bundle {
	val rid 	= Input(UInt(Axi4.ID.W))			// read id
	val rdata 	= Input(UInt(Axi4.DATA.W))			// read data
	val rresp 	= Input(UInt(Axi4.RESP.W))			// read response
	val rlast 	= Input(Bool())						// read last
	val rvalid 	= Input(Bool())						// read valid
	val rready 	= Output(Bool())					// read ready
}

class AxiMasterPort extends Bundle {
	val waddr 	= new WADDR
	val wdata 	= new WDATA
	val wresp	= new WRESP
	val raddr 	= new RADDR
	val rdata 	= new RDATA
}

class AxiSlavePort extends Bundle {
	val waddr 	= Flipped(new WADDR)
	val wdata 	= Flipped(new WDATA)
	val wresp 	= Flipped(new WRESP)
	val raddr 	= Flipped(new RADDR)
	val rdata 	= Flipped(new RDATA)
}