#!/bin/sh

OUTPUT=kotori-os
CC=x86_64-elf-gcc
LD=x86_64-elf-ld
AS=nasm
CCFLAGS="-Wall \
    -Wextra \
    -isystem src/kernel/ \
    -Isrc/libc/include/ \
    -std=gnu99 \
    -ffreestanding \
    -fno-stack-protector \
    -fno-stack-check \
    -fno-lto \
    -fno-PIC \
    -ffunction-sections \
    -fdata-sections \
    -m64 \
    -march=x86-64 \
    -mabi=sysv \
    -mno-80387 \
    -mno-mmx \
    -mno-sse \
    -mno-sse2 \
    -mno-red-zone \
    -mcmodel=kernel"
LDFLAGS=" -m elf_x86_64 \
    -nostdlib \
    -static \
    -z max-page-size=0x1000 \
    --gc-sections \
    -T linker.lds"
ASFLAGS="-felf64"



clean()
{
    rm -rf build $OUTPUT
}

build_limine()
{
    rm -rf limine-binary limine-binary.tar.gz
    curl -L https://github.com/Limine-Bootloader/Limine/releases/latest/download/limine-binary.tar.gz | gunzip | tar -xf -
    make -C limine-binary && \
    echo "Done building Limine"
}

build()
{
    mkdir -p build

    find src -name '*.c' | while IFS= read -r f; do
        mkdir -p "build/$(dirname "$f")"
        $CC $CCFLAGS -MMD -MP -c "$f" -o "build/${f%.c}.o"    
    done

    find src -name "*.asm" | while IFS= read -r f; do
        mkdir -p "build/$(dirname "$f")"
        $AS $ASFLAGS "$f" -o "build/${f%.asm}.o"
    done

    find build -name "*.o" | xargs $LD $LDFLAGS -o $OUTPUT

    dd if=/dev/zero bs=1M count=0 seek=64 of=disk.img
    
    /sbin/parted -s disk.img \
           mklabel gpt \
           mkpart ESP fat32 2048s 100% \
           set 1 esp on

    if [ -f "./limine-binary/limine" ]; then
        ./limine-binary/limine bios-install disk.img
        mformat -F disk.img@@1M
        mmd -i disk.img@@1M ::/EFI ::/EFI/BOOT ::/boot/ ::/boot/limine
        
        mcopy -i disk.img@@1M $OUTPUT ::/boot
        mcopy -i disk.img@@1M limine.conf limine-binary/limine-bios.sys ::/boot/limine
        mcopy -i disk.img@@1M limine-binary/BOOTX64.EFI ::/EFI/BOOT
        mcopy -i disk.img@@1M limine-binary/BOOTIA32.EFI ::/EFI/BOOT
    fi
    
}   

debug()
{
    qemu-system-x86_64 -hdd disk.img -S -s -monitor stdio
}

run()
{
    qemu-system-x86_64 -hdd disk.img 
}

case "$1" in
    clean)
        clean
        exit 0
        ;;
    build|'')
        build
        exit 0
        ;;
    build_limine)
        build_limine
        exit 0
        ;;
    run)
        run
        exit 0
        ;;
    debug)
        debug
        exit 0
        ;;
    *)
        echo "Wrong arguments"
        exit 1
        ;;
esac
