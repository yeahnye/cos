#! /bin/sh
if [ x$1 != x ]
then
		echo "starting to boot $1..."
else
		echo "wrong params: need a image file name"
		exit 0
fi		

sleep 1
qemu-system-x86_64 -hda $1 -nographic

