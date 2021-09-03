// Configurations for hikelchip.

package hikel

object Config {
	val MXLEN = 64
	val REG_NUM = 32

	val BUILD_ARG 	= Array("-td", "vbuild")

	// add extra instructions to support ysyx tests
	val YSYX_TEST_OUTPUT 	= false
}