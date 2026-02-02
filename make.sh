#!/bin/sh 

AS_BOOT="nasm -felf32 -Isrc/boot/"
AS_KERN="nasm -felf32 -Isrc/boot/ -Isrc/kernel/"
SRC_DIR="src"
DST_DIR="dst"
LD="ld -T linker.ld -m elf_i386 -nostdlib"
LD_FILE="linked.o"
IMG_FILE="disk.img"
ISO_FILE="disk.iso"
NAME="kotoriforth"

clean()
{
    rm -f $IMG_FILE
    rm -f $ISO_FILE
    rm -rf $DST_DIR
}

build()
{
    clean
    mkdir -p $DST_DIR/boot
    mkdir -p $DST_DIR/objs
    $AS_BOOT $SRC_DIR/boot/boot.stage1.asm -o $DST_DIR/objs/s1_boot.o
    $AS_BOOT $SRC_DIR/boot/boot.stage2.asm -o $DST_DIR/objs/s2_boot.o
    $AS_KERN $SRC_DIR/kernel/kernel.asm -o $DST_DIR/objs/kernel.o
    
    $LD $DST_DIR/objs/s1_boot.o \
        $DST_DIR/objs/s2_boot.o \
        $DST_DIR/objs/kernel.o \
        -o $LD_FILE
    
    objcopy -O binary $LD_FILE $DST_DIR/$IMG_FILE
}

run()
{
    qemu-system-i386 -cdrom $IMG_FILE
}

debug()
{
    qemu-system-i386 -cdrom $IMG_FILE -S -s
}
case $1 in
    "clean") clean ;;
    "build") build ;;
    "run") run ;;
    "debug") debug ;;
    *) echo "Use clean|build|run|debug" ;;
esac
