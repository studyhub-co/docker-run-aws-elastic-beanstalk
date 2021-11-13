#!/bin/bash

SWAPFILE=/var/swapfile
SWAP_MEGABYTES=1200

if [ -f $SWAPFILE ]; then
	echo "Swapfile $SWAPFILE found, assuming already setup"
	/sbin/swapon -s $SWAPFILE
	exit;
fi

/bin/dd if=/dev/zero of=$SWAPFILE bs=1M count=$SWAP_MEGABYTES
/bin/chmod 600 $SWAPFILE
/sbin/mkswap $SWAPFILE
/sbin/swapon $SWAPFILE