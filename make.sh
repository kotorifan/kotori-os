#!/bin/sh 

AS_BOOT="nasm -fbin -Isrc/boot/"
SRC_DIR="src"
DST_DIR="dst"
IMG_FILE="disk.img"
ISO_FILE="disk.iso"
NAME="kotoriforth"

clean()
{
    rm -f $IMG_FILE
    rm -rf $DST_DIR
}

build()
{
    clean
    mkdir -p $DST_DIR/boot
    $AS_BOOT $SRC_DIR/boot/boot.stage1.asm -o $DST_DIR/s1_boot.bin
    
    dd if=/dev/zero of=$IMG_FILE bs=1M count=2
    dd if=$DST_DIR/s1_boot.bin of=$IMG_FILE conv=notrunc bs=512 count=1
    dd of=$DST_DIR/s2_boot.bin of=$IMG_FILE conv=notrunc bs=512 seek=1 
    S2_SECTORS=$(($(wc -c < "$BOOT_S2") / 512))
    dd of=$DST_DIR/kernel.bin of=$IMG_FILE conv=notrunc bs=512 $((1 + S2_SECTORS))
    
    xorriso -as mkisofs \
            -b $DST_DIR/$IMG_FILE \
            -no-emul-boot \
            -boot-load-size 4 \
            -boot-info-table \
            -iso-level 3 \
            -J \
            -R \
            -V "$NAME" \
            -o $ISO_FILE \
            $ISO_FILE

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
