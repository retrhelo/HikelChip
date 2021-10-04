# script for SoC emulating environment

NOOP_HOME=.
TARGET=build/soc_emu
IMG_DIR=bin

export NOOP_HOME

WAVE_START=0 		# start of wavefile
WAVE_END=2000 		# end of wavefile

help() {

}

while getopts '' OPT; do

done

if [[ "$DO_BUILD" = "true" ]]; then 

fi

if [[ "$DO_RUN" = "true" ]]; then
	for i in ${images}; do 
		${TARGET} -i $i $DO_WAVE -b ${WAVE_START} -e ${WAVE_END}
		if [[ $? -ne 0 ]]; then 
			echo "failed at $i"
			exit -1
		fi
	done
fi