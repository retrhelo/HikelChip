NOOP_HOME=.
DIFF_DIR=difftest
TARGET=build/emu
IMG_DIR=bin

export NOOP_HOME

images=`ls ${IMG_DIR}/non-output/riscv-tests/*.bin`
images="${images} `ls ${IMG_DIR}/non-output/csr-tests/*.bin`"

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
while getopts 'hbri:wc' OPT; do
	case $OPT in
		h) help;;
		b) DO_BUILD="true";;
		r) DO_RUN="true";;
		i) images="$OPTARG";;
		w) DO_WAVE="--dump-wave";;
		c) rm -rf build;;
		?) help;;
	esac
done

if [[ $DO_BUILD = "true" ]]; then 
	make -C ${DIFF_DIR} NOOP_HOME=${NOOP_HOME} EMU_TRACE=1
fi

if [[ $DO_RUN = "true" ]]; then 
	for i in ${images}; do
		${TARGET} -i $i $DO_WAVE -b 0 -e 2000
		if [[ $? -ne 0 ]]; then 
			echo "failed at $i"
			exit -1
		fi
	done
fi