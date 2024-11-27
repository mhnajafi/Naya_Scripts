# Image Generator Script
This script generates a complete image that is
1. signed 
2. encrypted
3. confirmed
4. UF2 formatted
for using in NRF52840 based systems. It also tries to download the firmware.bin file with USB_DFU.


Installing requirenmetns:
	pip3 install --user -r requirements.txt
	
	
	
Updating application using MCUBoot( signed and encrypted firmware )
	dfu-util -a 2 -E 1 -D firmware.bin -d [VID:PID]
	
	
Updating application using MCUBoot( signed and encrypted firmware )
	dfu-util -a 1 -E 1 -D firmware.bin -d [VID:PID]
