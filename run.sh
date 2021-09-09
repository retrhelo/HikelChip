#!/bin/bash

TEST_HOME=src/test/verilator
VSRC=${TEST_HOME}/vsrc
CSRC=${TEST_HOME}/csrc

if [ "" = "$1" ]; then 
	echo "please enter a module"
	exit -1
fi

verilator --x-assign unique --cc --exe --build --trace --assert -O3 -CFLAGS "-std=c++11 -Wall" ${CSRC}/$1_tb.cpp ${VSRC}/$1.v