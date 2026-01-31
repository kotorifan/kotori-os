#!/bin/sh 

AS_BOOT=nasm -fbin
SRC_DIR=src
DST_DIR=dst
IMG_FILE=disk.iso

clean()
{
    rm -f $IMG_FILE
    rm -rf $DST_DIR
}

build()
{
    clean()
    $AS_BOOT $SRC_DIR/boot/boot.stage1.asm -o $DST_DIR/s1_boot.bin    
}

run()
{
    qemu-system-x86_64 -cdrom $IMG_FILE
}

debug()
{
    qemu-system-x86_64 -cdrom $IMG_FILE -S -s
}
case $1 in
    "clean") clean ;;
    "build") build ;;
    "run") run ;;
    "debug") debug ;;
    *) echo "Use clean|build|run|debug" ;;
esac
