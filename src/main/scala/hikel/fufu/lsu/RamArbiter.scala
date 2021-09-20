// The arbitor for IRead and DRead

package hikel.fufu.lsu

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.fufu._

class RamArbiter extends RawModule {
	val io = IO(new Bundle {
		val iread 	= new LsuRead
		val dread 	= new LsuRead
		val out 	= Flipped(new LsuRead)
	})

	val sel = io.iread.rvalid

	// select on input
	io.out.addr 	:= Mux(sel, io.iread.addr, io.dread.addr)
	io.out.rvalid 	:= io.iread.rvalid || io.dread.rvalid

	// select on output
	io.iread.rready 	:= io.out.rready
	io.dread.rready 	:= !sel && io.out.rready
	io.iread.rdata 		:= io.out.rdata
	io.dread.rdata 		:= io.out.rdata
}