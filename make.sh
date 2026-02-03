#!/bin/sh 

AS_BOOT="nasm -fbin -Isrc/boot/ -Isrc/"
AS_KERN="nasm -fbin -Isrc/boot/ -Isrc/kernel/ -Isrc/"
SRC_DIR="src"
DST_DIR="dst"

IMG_FILE="disk.img"

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
    $AS_BOOT $SRC_DIR/boot/boot.stage1.asm -o $DST_DIR/objs/s1_boot.bin
    $AS_BOOT $SRC_DIR/boot/boot.stage2.asm -o $DST_DIR/objs/s2_boot.bin
    $AS_KERN $SRC_DIR/kernel/kernel.asm -o $DST_DIR/objs/kernel.bin

    dd if=/dev/zero of=$IMG_FILE bs=512 count=14336

    dd if=$DST_DIR/objs/s1_boot.bin of=$IMG_FILE bs=512 count=1 conv=notrunc
    dd if=$DST_DIR/objs/s2_boot.bin of=$IMG_FILE bs=512 seek=1 conv=notrunc
    dd if=$DST_DIR/objs/kernel.bin of=$IMG_FILE bs=512 seek=10 conv=notrunc
}

run()
{
    qemu-system-i386 -drive format=raw,file=$IMG_FILE
}

debug()
{
    qemu-system-i386 -drive format=raw,file=$IMG_FILE -S -s
}

case $1 in
    "clean") clean ;;
    "build") build ;;
    "run") run ;;
    "debug") debug ;;
    *) echo "Use clean|build|run|debug" ;;
esac
