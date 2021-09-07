// The Fetch stage of hikelchip core
// Fetch instructions and pass it to Decode stage

package hikel.stage

import chisel3._
import chisel3.util._

import hikel.Config._

class Fetch extends Stage {}


import chisel3.stage.ChiselStage
object FetchGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Fetch, BUILD_ARG)
}