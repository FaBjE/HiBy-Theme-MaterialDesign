#!/bin/bash

# Note: Install required binaries with: 
#   apt-get install mtd-utils

# Usage:
# - place "r3pro.upd" file in this folder
# - Run script
# - Firmware contents is mounted to "PlayerRootFS" subfolder


#------------------ Check if root (required for mounting stuff)
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


#------------------ Extract UBI image files from firmware update download image

#Make (temp) dirs
mkdir mount
mkdir extract

#Mount update ISO image to temp folder
mount -o loop r3pro.upt mount/

#Copy all contents to extract folder
cp -a mount/. extract/

#Unmount and remove temp dir
umount mount/
rmdir mount


#------------------ Mount RootFS extracted from firmware image
#  Filesystem/Flash info
#   mtd4
#   Name:                           rootfs
#   Type:                           nand
#   Eraseblock size:                131072 bytes, 128.0 KiB
#   Amount of eraseblocks:          512 (67108864 bytes, 64.0 MiB)
#   Minimum input/output unit size: 2048 bytes
#   Sub-page size:                  2048 bytes
#   OOB size:                       64 bytes
#   Character device major/minor:   90:8
#   Bad blocks are allowed:         true
#   Device is writable:             true

#Make mount point for player rootfs
mkdir PlayerRootFS

# Create simulated Nand flash device page size of 2048 bytes
modprobe nandsim first_id_byte=0x2c second_id_byte=0xda third_id_byte=0x90 fourth_id_byte=0x95
flash_erase /dev/mtd0 0 0
ubiformat /dev/mtd0 -s 2048 -O 2048

#Create UBI volume
modprobe ubi
ubiattach -m 0 -d 0 -O 2048

#Make ubi volume with size of flash (64MiB)
ubimkvol /dev/ubi0 -N volname -s 64MiB

#Load extracted fs data from firmware to ubi volume
ubiupdatevol /dev/ubi0_0 extract/system.ubi

#Mount UBI volume device to "PlayerRootFS" folder
mount /dev/ubi0_0 PlayerRootFS
