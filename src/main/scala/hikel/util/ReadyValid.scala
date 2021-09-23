package hikel.util

import chisel3._
import chisel3.util._

object ReadyValid {
	def apply[T <: Data](data: T) = new ReadyValid(data)
}

// from the perspective of master
class ReadyValid[T <: Data](val bits: T) extends Bundle {
	val valid = Output(Bool())
	val ready = Input(Bool())
}