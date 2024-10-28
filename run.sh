#!/bin/bash

ver=1.23



# Define red color code
RED='\033[0;31m'
NC='\033[0m' 
GREEN='\033[0;32m'



imgtool=/home/mhn/zephyrproject/bootloader/mcuboot/scripts/imgtool.py
key=/home/mhn/zephyrproject/bootloader/mcuboot/root-rsa-2048.pem
encrypt=/home/mhn/zephyrproject/bootloader/mcuboot/enc-rsa2048-priv.pem


infile=/home/mhn/zephyrproject/applications/blinky/build/zephyr/zephyr.bin
outfile=/home/mhn/zephyrproject/applications/blinky/build/zephyr/zephyr.signed.confirmed.encrypted.bin

uf2=/home/mhn/zephyrproject/applications/uf2script/uf2conv.py
uf2file=/home/mhn/zephyrproject/applications/uf2script/flash.uf2
uf2dist=/media/mhn/XIAO-SENSE/flash.uf2
uf2dir=/media/mhn/XIAO-SENSE

if [ -f "$infile" ]; then
	$imgtool sign --key $key -E $encrypt --header-size 0x200 -S 0x54000 --version $ver --confirm --pad  $infile $outfile
	python3 $uf2  $outfile  -c -b 0x8c000 -f 0xADA52840
else
	echo -e "${RED}============( Error )=============${NC}"
	echo -e "${RED}binary file does not exist.${NC}"	
fi

if [ -d "$uf2dir" ]; then
	cp $uf2file $uf2dist
	echo -e "${GREEN}Image copied to Device.${NC}"
	echo -e "${GREEN}============( Done )=============${NC}"
else
	echo -e "${RED}============( Error )=============${NC}"
	echo -e "${RED}UF2 Directory does not exist.${NC}"
fi


