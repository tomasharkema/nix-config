#!/bin/sh
set -e
if [ ! -e /key ]; then
    mkdir -p /key
    sleep 3
fi

usbdevice=$(readlink -f /dev/disk/by-partlabel/a7098897-2784-4776-bd3d-0e217d85963d)
if mount -t vfat $usbdevice /key 2>/dev/null; then
    if [ -e /key/key ]; then
        cat /key/key
        # umount $usbdevice
        exit
    fi
    umount $usbdevice
fi
/lib/cryptsetup/askpass "Insert USB key and press ENTER: "
