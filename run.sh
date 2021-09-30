NOOP_HOME=.
DRAMSIM3_HOME=${PWD}/DRAMsim3
DIFF_DIR=difftest
TARGET=build/emu
IMG_DIR=bin

export NOOP_HOME
export DRAMSIM3_HOME

images=`ls ${IMG_DIR}/non-output/riscv-tests/*.bin`
# images="${images} `ls ${IMG_DIR}/non-output/csr-tests/*.bin`"
# images="${images} `ls ${IMG_DIR}/non-output/riscv-tests/load/*.bin`"
# images="${images} `ls ${IMG_DIR}/non-output/riscv-tests/store/*.bin`"
# images="${images} `ls ${IMG_DIR}/non-output/cpu-tests/*.bin`"

# start wavefile
WAVE_BEGIN=0
WAVE_END=2000

help() {
	echo "Please remember: 指揮官、わたしがいれば十分ですよ。"
	echo "Usage:"
	echo "$0 [-h] [-b] [-r] [-i image] [-c]"
	echo "Description:"
	echo "-h: Display this help message"
	echo "-b: Build emulation program using verilator"
	echo "-r: Run emulation program"
	echo "-i: Specify a binary image as program to run"
	echo "-w: Generate wavefile"
	echo "-c: Clean up"
	exit 0
}

# Check parameters
while getopts 'hbri:wcs:e:' OPT; do
	case $OPT in
		h) help;;
		b) DO_BUILD="true";;
		r) DO_RUN="true";;
		i) images="$OPTARG";;
		w) DO_WAVE="--dump-wave";;
		c) rm -rf build;;
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
		${TARGET} -i $i $DO_WAVE -b ${WAVE_BEGIN} -e ${WAVE_END}
		if [[ $? -ne 0 ]]; then 
			echo "failed at $i"
			exit -1
		fi
	done
fi