// The Execute Stage of 5-stage hikelchip RISC-V64 core
// In this stage CPU will do these things:
// 		* execute an arithmetic or a logical instruction
// 		* load from LSU
// 		* read from CSR

package hikel.stage

import chisel3._

import hikel.Config._
import hikel.RegFile

class Execute extends Module {
	val io = IO(new Bundle {})
}


import chisel3.stage.ChiselStage
object ExecuteGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Execute, BUILD_ARG)
}