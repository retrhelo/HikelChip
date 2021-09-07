// The Issue Stage of 5-stage hikelchip RISC-V64 core
// In this stage CPU will do things below:
// 		* solve the problem of data conflicts(redirection)
// 		* decide on branch instruction

package hikel.stage

import chisel3._
import chisel3.util._

import hikel.Config._
import hikel.RegFile

class Issue extends Module {
	val io = IO(new Bundle {})
}


import chisel3.stage.ChiselStage
object IssueGenVerilog extends App {
	(new ChiselStage).emitVerilog(new Issue, BUILD_ARG)
}