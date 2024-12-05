#!/bin/bash


app_dir=/home/mhn/zephyrproject/applications/blinky

port=/dev/ttyACM0

baud=115200


#=================================================

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
imgtool=$SCRIPT_DIR/imgtool/imgtool.py
newtmgr=$SCRIPT_DIR/mynewt/newtmgr
key=$SCRIPT_DIR/keys/k_pub.pem
encrypt=$SCRIPT_DIR/keys/k_prv.pem
outfile=$SCRIPT_DIR/firmware/firmware.bin

CONFIG_FILE="$app_dir/build/zephyr/.config"


# Define red color code
RED='\033[0;31m'
NC='\033[0m' 
GREEN='\033[0;32m'

if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo -e "${RED}Configuration file not found!${NC}"	
    exit 1
fi


infile=$app_dir/build/zephyr/zephyr.bin
if [[ -f "$infile" ]]; then
	echo -e "${GREEN}binary file  found!${NC}"
else
	echo -e "${RED}binary file not found!${NC}"
    exit 1
fi


if [[ -z "$CONFIG_USB_DEVICE_VID" ]]; then
	echo -e "${RED}Error: USB_DEVICE_VID is not set or is empty in the config file.${NC}"
    exit 1
fi
if [[ -z "$CONFIG_USB_DEVICE_PID" ]]; then
	echo -e "${RED}Error: USB_DEVICE_PID is not set or is empty in the config file.${NC}"
    exit 1
fi

# Remove the "0x" prefix if it exists
if [[ "$CONFIG_USB_DEVICE_PID" == 0x* ]]; then
    pid="${CONFIG_USB_DEVICE_PID#0x}"
fi

# Remove the "0x" prefix if it exists
if [[ "$CONFIG_USB_DEVICE_VID" == 0x* ]]; then
    vid="${CONFIG_USB_DEVICE_VID#0x}"
fi

vipi=$vid:$pid


if [[ -z "$CONFIG_MCUBOOT_IMGTOOL_SIGN_VERSION" ]]; then
	echo -e "${RED}Error: MCUBOOT_IMGTOOL_SIGN_VERSION is not set or is empty in the config file.${NC}"
    exit 1
fi
ver=$CONFIG_MCUBOOT_IMGTOOL_SIGN_VERSION


if [[ -z "$CONFIG_FLASH_LOAD_SIZE" ]]; then
	echo -e "${RED}Error: FLASH_LOAD_SIZE is not set or is empty in the config file.${NC}"
    exit 1
fi
slot_size=$CONFIG_FLASH_LOAD_SIZE


echo "-------------------------------"
echo "Slot size:	$slot_size"
echo "version:	$ver"
echo "VID:PID:	$vipi"
echo "-------------------------------"

if [ -f "$infile" ]; then
	$imgtool sign --key $key -E $encrypt --header-size 0x200 -S $slot_size --version $ver --confirm --pad  $infile $outfile
else
	echo -e "${RED}============( Error )=============${NC}"
	echo -e "${RED}binary file does not exist.${NC}"	
fi




if $newtmgr conn add acm0 type="serial" connstring="dev=$port,baud=$baud,mtu=4096"| grep -q "successfully"; then
	echo -e "${GREEN}Port OK.${NC}"
else
	echo -e "${RED}============( Error )=============${NC}"
	echo -e "${RED}Port not found.${NC}"
    exit 1
fi


if $newtmgr -c acm0 image upload $outfile -n 2| tee >(grep -q "done"); then
	echo -e "${GREEN}Image copied to Device.${NC}"
	echo -e "${GREEN}============( Done )=============${NC}"
else
	echo -e "${RED}============( Error )=============${NC}"
	echo -e "${RED}Error in downloading the firmware.${NC}"
    exit 1
fi


if $newtmgr -c acm0 reset| tee >(grep -q "done"); then
	echo -e "${GREEN}System restarted ! ${NC}"
	echo -e "${GREEN}============( Done )=============${NC}"
else
	echo -e "${RED}============( Error )=============${NC}"
	echo -e "${RED}Error in restarting system.${NC}"
    exit 1
fi

