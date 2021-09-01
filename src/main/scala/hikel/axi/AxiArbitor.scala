// The arbiter of Axi4 Bus Protocol. 
// The module name 'Arbitor' is not a typo, it's a title owned by 
// one of my friends, 'the Great Arbitor'. In memory of him I use 
// the term 'Arbitor' instead of the original 'Arbiter'. 

package hikel.axi

import chisel3._
import chisel3.util._

class AxiArbitor extends Module {
	val io = IO(new Bundle {})
}