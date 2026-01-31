#!/bin/sh 

AS_BOOT="nasm -fbin -Isrc/boot/"
AS_KERN="nasm -fbin -Isrc/boot/ -Isrc/kernel/"
SRC_DIR="src"
DST_DIR="dst"
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
    $AS_BOOT $SRC_DIR/boot/boot.stage1.asm -o $DST_DIR/s1_boot.bin
    $AS_BOOT $SRC_DIR/boot/boot.stage2.asm -o $DST_DIR/s2_boot.bin
    $AS_KERN $SRC_DIR/kernel/kernel.asm -o $DST_DIR/kernel.bin
    dd if=/dev/zero of=disk.img bs=512 count=2048
    dd if=$DST_DIR/s1_boot.bin of=$IMG_FILE conv=notrunc bs=512 count=1
    echo "Written s1_boot.bin to $IMG_FILE"
    dd if=$DST_DIR/s2_boot.bin of=$IMG_FILE conv=notrunc bs=512 seek=1 
    echo "Written s2_boot.bin to $IMG_FILE"
    S2_SECTORS=$(( ($(wc -c < "$DST_DIR/s2_boot.bin") + 511) / 512 ))
    KERNEL_OFFSET=$((1 + S2_SECTORS))
    dd if=$DST_DIR/kernel.bin of=$IMG_FILE conv=notrunc bs=512 \
       seek=$KERNEL_OFFSET status=none
    echo "Written kernel.bin to $IMG_FILE"
    xorriso -as mkisofs \
            -b $IMG_FILE \
            -no-emul-boot \
            -boot-load-size 4 \
            -boot-info-table \
            -iso-level 3 \
            -J \
            -R \
            -V "$NAME" \
            -o $ISO_FILE \
            "$(dirname "$IMG_FILE")"


    if [ -f $ISO_FILE ]; then
        echo "Bootable ISO created"
    fi
    
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
