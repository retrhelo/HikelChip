// The top-level module of Hikel chip 

package hikel 

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.stage._

class Hikel extends Module {
	// genereate desired name for top-level module
	override def desiredName: String = "SimTop"

	val io = IO(new Bundle {
		
	})
}

import chisel3.stage.ChiselStage
object HikelGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Hikel, BUILD_ARG)
}