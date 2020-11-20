#! /bin/bash

qemu-system-i386  -drive format=raw,file=./bin/ucore.img -no-reboot
