# script for SoC emulating environment

NOOP_HOME=.
VERILOG=build/ysyx_210727.v
TARGET=build/soc_emu
IMG_DIR=bin

export NOOP_HOME

WAVE_START=0 		# start of wavefile
WAVE_END=2000 		# end of wavefile

help() {
	echo "Usage:"
	echo "$0 [-h] [-b] [-r] [-i image] [-w] [-c] [-s wave_start] [-e wave_end]"
	echo "Description:"
	echo "-h: Display this help message"
	echo "-b: Build emulation program using verilator"
	echo "-r: Run emulation program"
	echo "-i: Specify binary image(s) as program to run"
	echo "-w: Generate wavefile"
	echo "-c: Clean up"
	echo "-s: Specify start cycle for wavefile"
	echo "-e: Specify end cycle for wavefile"
	exit 0
}

# extract parameters
while getopts 'hbri:wcs:e:' OPT; do
	case $OPT in
		h) help;;
		b) DO_BUILD="true";;
		r) DO_RUN="true";;
		i) images="$OPTARG";;
		w) DO_WAVE="--dump-wave";;
		s) WAVE_START="$OPTARG";;
		e) WAVE_END="$OPTARG";;
		c) rm -rf build;;
		?) help;;
	esac
done

if [[ "$DO_BUILD" = "true" ]]; then
	make soc-verilog
fi

# check if the code is under contraint
mv ${VERILOG} ysyxSoC/ysyx/lint/
make -C ysyxSoC/ysyx/lint

if [[ "$DO_RUN" = "true" ]]; then
	for i in ${images}; do 
		${TARGET} -i $i $DO_WAVE -b ${WAVE_START} -e ${WAVE_END}
		if [[ $? -ne 0 ]]; then 
			echo "failed at $i"
			exit -1
		fi
	done
fi