#!/bin/bash

ver=1.23


SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
imgtool=$SCRIPT_DIR/imgtool.py
key=$SCRIPT_DIR/k_pub.pem
encrypt=$SCRIPT_DIR/k_prv.pem

infile=$SCRIPT_DIR/zephyr.bin
outfile=$SCRIPT_DIR/firmware.bin


slot_size=0x57000



# Define red color code
RED='\033[0;31m'
NC='\033[0m' 
GREEN='\033[0;32m'

if [ -f "$infile" ]; then
	$imgtool sign --key $key -E $encrypt --header-size 0x200 -S $slot_size --version $ver --confirm --pad  $infile $outfile
else
	echo -e "${RED}============( Error )=============${NC}"
	echo -e "${RED}binary file does not exist.${NC}"	
fi

if [ 1 ]; then
	sudo dfu-util -a 2 -E 1 -D $outfile
	echo -e "${GREEN}Image copied to Device.${NC}"
	echo -e "${GREEN}============( Done )=============${NC}"
else
	echo -e "${RED}============( Error )=============${NC}"
	echo -e "${RED}DFU Device does not exist.${NC}"
fi

