from littlefs import lfs
import os

firmware_file="firmware/module_fw.sfp"
lfs_file="module_fw.sfp"
image_file="firmware/FlashMemory.bin"

# Define partition parameters
BLOCK_SIZE = 4096       # Set your block size (e.g., 4096 bytes)
#BLOCK_COUNT = 256       # Set the total number of blocks for the partition 0x100
BLOCK_COUNT = 384       # Set the total number of blocks for the partition 0x100

if  os.path.exists(image_file):
	os.remove(image_file)

cfg = lfs.LFSConfig(block_size=BLOCK_SIZE, block_count=BLOCK_COUNT)
fs = lfs.LFSFilesystem()

# Format and mount the filesystem
lfs.format(fs, cfg)
lfs.mount(fs, cfg)


if not os.path.exists(firmware_file):
	print(f"Error: The local file '{firmware_file}' does not exist.")
else:

	with open(firmware_file, 'rb') as local_file:
        # Read the content of the local file
        	file_data = local_file.read()
	# Open the LittleFS file 'first-fil.txt' for writing
	fh = lfs.file_open(fs, lfs_file, 'w')
	# Write the content of the local file into LittleFS file
	lfs.file_write(fs, fh, file_data)	
	lfs.file_close(fs, fh)
	print(f"Successfully copied the content from '{firmware_file}' to '{lfs_file}' on LittleFS.")

	# Dump the filesystem content to a file
	with open(image_file, 'wb') as fh:
		fh.write(cfg.user_context.buffer)
		print(f"Successfully generated '{image_file}'")
    
    
    

    
    
    

    
    
    
