#!/bin/bash

ver=1.23

imgtool=/home/mhn/zephyrproject/bootloader/mcuboot/scripts/imgtool.py
key=/home/mhn/zephyrproject/bootloader/mcuboot/mhn_pub.pem
encrypt=/home/mhn/zephyrproject/bootloader/mcuboot/mhn_prv.pem

infile=/home/mhn/zephyrproject/applications/blinky/build/zephyr/zephyr.bin
outfile=/home/mhn/zephyrproject/applications/blinky/build/zephyr/zephyr.signed.confirmed.encrypted.bin



slot_size=0x34000
Slot1_address=0x4a000




SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
uf2=$SCRIPT_DIR/uf2conv.py
uf2file=$SCRIPT_DIR/flash.uf2
uf2dist=$uf2dir/flash.uf2
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

