# script to run when emulating with difftest

NOOP_HOME=.
DIFF_DIR=difftest
TARGET=build/emu
IMG_DIR=bin

# support libraries
NEMU_HOME=~/bin/NEMU
DRAMSIM3_HOME=~/bin/DRAMsim3

export NOOP_HOME
export NEMU_HOME
export DRAMSIM3_HOME

# default instruction test sets
images=`ls ${IMG_DIR}/non-output/riscv-tests/*.bin`
images="${images} `ls ${IMG_DIR}/non-output/csr-tests/*.bin`"
images="${images} `ls ${IMG_DIR}/non-output/riscv-tests/load/*.bin`"
images="${images} `ls ${IMG_DIR}/non-output/riscv-tests/store/*.bin`"
images="${images} `ls ${IMG_DIR}/non-output/cpu-tests/*.bin`"

# start wavefile
WAVE_BEGIN=0
WAVE_END=2000

# disable difftest
DIFFTEST_FLAG="--no-diff"

help() {
	echo "Usage:"
	echo "$0 [-h] [-b] [-r] [-i image] [-w] [-c] [-s wave_start] [-e wave_end]"
	echo "Description:"
	echo "-h: Display this help message"
	echo "-b: Build emulation program using verilator"
	echo "-r: Run emulation program"
	echo "-i: Specify a binary image as program to run"
	echo "-w: Generate wavefile"
	echo "-c: Clean up"
	echo "-s: Specify start cycle for wavefile"
	echo "-e: Specify end cycle for wavefile"
	exit 0
}

# Check parameters
while getopts 'hbrdi:wcs:e:' OPT; do
	case $OPT in
		h) help;;
		b) DO_BUILD="true";;
		d) DIFFTEST_FLAG="";;
		r) DO_RUN="true";;
		i) images="$OPTARG";;
		w) DO_WAVE="--dump-wave";;
		c) rm -rf build; exit 0;;
		s) WAVE_BEGIN="$OPTARG";;
		e) WAVE_END="$OPTARG";;
		?) help;;
	esac
done

if [[ $DO_BUILD = "true" ]]; then 
	# make -C ${DIFF_DIR} NOOP_HOME=${NOOP_HOME} EMU_TRACE=1
	make -C ${DIFF_DIR} NOOP_HOME=${NOOP_HOME} DRAMSIM3_HOME=${DRAMSIM3_HOME} EMU_TRACE=1 WITH_DRAMSIM3=1
fi

if [[ $DO_RUN = "true" ]]; then 
	for i in ${images}; do
		${TARGET} -i $i $DO_WAVE -b ${WAVE_BEGIN} -e ${WAVE_END} ${DIFFTEST_FLAG}
		if [[ $? -ne 0 ]]; then 
			echo "failed at $i"
			exit -1
		fi
	done
fi