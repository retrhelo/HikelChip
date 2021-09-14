// Configurations for hikelchip.

package hikel

import chisel3.util._

object Config {
	val MXLEN 		= 64
	val SHMT 		= log2Ceil(MXLEN)
	val IMM 		= MXLEN

	val INST 		= 32
	val UOP 		= 3

	val PC 			= 32

	val BUILD_ARG 	= Array("-td", "./build")

	// add extra instructions to support ysyx tests
	val YSYX_DIFFTEST 	= true
}