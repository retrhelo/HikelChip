
# generate verilog code for simulation
sim-verilog: src/main/scala/hikel/SimTop.scala
	mill -i __.test.runMain hikel.SimTopGenVerilog