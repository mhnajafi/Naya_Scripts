from littlefs import lfs

# Define partition parameters
BLOCK_SIZE = 4096       # Set your block size (e.g., 4096 bytes)
BLOCK_COUNT = 256       # Set the total number of blocks for the partition 0x100



cfg = lfs.LFSConfig(block_size=BLOCK_SIZE, block_count=BLOCK_COUNT)
fs = lfs.LFSFilesystem()

# Format and mount the filesystem
lfs.format(fs, cfg)
lfs.mount(fs, cfg)

# Open a file and write some content
fh = lfs.file_open(fs, 'first-fil.txt', 'w')
lfs.file_write(fs, fh, b'Some text to begin with\n')
lfs.file_close(fs, fh)

# Dump the filesystem content to a file
with open('FlashMemory.bin', 'wb') as fh:
    fh.write(cfg.user_context.buffer)
