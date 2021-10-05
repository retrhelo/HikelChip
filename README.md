# HiKelChip: A RV64I Implementation in Chisel

Author: Artyom Liu <artyomliu@foxmail.com>

## Introduction

指揮官、わたしがいれば十分ですよ。 --That's the way to comfort the machine spirit \*laugh\*.

Let's be serious. HikelChip is a project for YSYX project, which is a project aiming 
to training young chip designers. In the project, each participant is asked to implement 
his/her own chip design, in ISA of RISC-V. The minimun goal is to support RISC-V I-extension 
and support simple interrupts like _timer interrupt_. 

And HikelChip is my piece of work participanting in this project. It implements a full 
implementation of I-extension, and with Zicsr extension too. The chip uses a 5-stage classical 
implementation, with _Fetch_, _Decode_, _Issue_, _Execute_ and _Commit_. The chip also 
implements an interface of standard AXI4 bus protocol, for connecting to peripherals outside 
the chip itself. 

Thanks to the previous work of all YSYX project and Xiangshan project, a mechanic called 
"_Difftest_" is introduced in the debugging. With this certain mechanic, we can now connect 
our implementation to a standard software implementation of RISC-V. By comparing the commit 
stage of each instruction, bugs in chip design can be found more effeciently. 

## Prerequirements

To run the programs, with difftest, requires two more repos: ***NEMU*** and ***DRAMsim3***. The 
previous one is meant to be standard implementation for _Difftest_, while the later one provides 
an software implementation of DRAM that can be accessed by AXI4 bus. Both these two repos can be 
cloned from github. 

Once the repos are cloned onto local machine, you need to set two environment variables to help 
the building Makefile script to find the repos: _DRAMSIM3\_HOME_ and _NEMU\_HOME_. Both pointing 
to the root path of relevant repo. 

For simulation, we use ***verilator*** as the very tool. This is a tool that transfer the given 
HDL codes into a C++ class, and final build it into an executable file with the help of some 
user-implement C++ codes. In this sense, to "simulate" the design is to run the executable. 

## Diagram