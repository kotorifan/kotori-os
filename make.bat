@echo off
setlocal enabledelayedexpansion
set OUTPUT=kotori-os
set CC=x86_64-elf-gcc
set LD=x86_64-elf-ld
set AS=nasm

set "CCFLAGS=-Wall -Wextra -isystem src/kernel/ -Isrc/libc/include/ -std=gnu99 -ffreestanding -fno-stack-protector -fno-stack-check -fno-lto -fno-PIC -ffunction-sections -fdata-sections -m64 -march=x86-64 -mabi=sysv -mno-80387 -mno-mmx -mno-sse -mno-sse2 -mno-red-zone -mcmodel=kernel"
set "LDFLAGS=-nostdlib -static -z max-page-size=0x1000 --gc-sections -T linker.lds"
set "ASFLAGS=-f elf64 -Isrc/common/"

if /i "%1"=="clean" goto clean
if /i "%1"=="build_limine" goto build_limine
if /i "%1"=="run" goto run
if /i "%1"=="debug" goto debug
if "%1"=="" goto build
if /i "%1"=="build" goto build
echo Usage: %~nx0 [build^|run^|debug^|clean^|build_limine]
exit /b 1

:clean
if exist build rmdir /s /q build
if exist %OUTPUT% del %OUTPUT%
if exist disk.img del disk.img
if exist other\unscii.psf del other\unscii.psf
exit /b 0

:build_limine
if not exist other mkdir other
if exist other\limine-binary rmdir /s /q other\limine-binary
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/limine-bootloader/limine/releases/latest/download/limine-binary.tar.gz' -OutFile 'other\limine-binary.tar.gz'"
powershell -Command "tar -xf other\limine-binary.tar.gz -C other"
del other\limine-binary.tar.gz
exit /b 0

:build
if not exist build mkdir build

for /r src %%f in (*.c) do (
  echo "Compiling %%f"
  %CC% %CCFLAGS% -MMD -MP -c "%%f" -o "build\%%~nf.o"
)

for /r src %%f in (*.asm) do (
  echo "Assembling %%f"
  %AS% %ASFLAGS% "%%f" -o "build\%%~nf.asm.o" 
)

if not exist other\unscii.psf (
  lua scripts\hex2psf1.lua other\unscii.hex other\unscii.psf
)

x86_64-elf-ld -r -b binary -o build\unscii.o other\unscii.psf

set "objs="
for /f "delims=" %%f in ('dir /b /s build\*.o 2^>nul') do set "objs=!objs! %%f"
%LD% %LDFLAGS% -o kotori-os !objs!

if not exist disk.img (
  fsutil file createnew disk.img 67108864 >nul
  fsutil file setzerodata offset=0 length=67108864 disk.img >nul 
  echo Done creating disk image
  sgdisk64 -o disk.img >nul
  echo Created GPT table
  sgdisk64 -n 1:2048:4095 -t 1:ef02 -c 1:"BIOS boot" disk.img >nul
  echo Created BIOS boot partition
  sgdisk64 -n 2:4096:0 -t 2:ef00 -c 2:"ESP" disk.img >nul
  echo Created ESP partition
)

if exist other\limine-binary\limine-tool-windows-x86\limine.exe (
  other\limine-binary\limine-tool-windows-x86\limine.exe bios-install disk.img

  mformat -F -i disk.img@@2M ::
  mmd -i disk.img@@2M /boot
  mmd -i disk.img@@2M /EFI
  mmd -i disk.img@@2M /EFI/BOOT

  mcopy -i disk.img@@2M limine.conf ::
  mcopy -i disk.img@@2M %OUTPUT% ::/boot
  mcopy -i disk.img@@2M other\limine-binary\limine-bios.sys ::
  mcopy -i disk.img@@2M other\limine-binary\BOOTX64.EFI ::/EFI/BOOT
  mcopy -i disk.img@@2M other\limine-binary\BOOTIA32.EFI ::/EFI/BOOT
)

exit /b 0

:run
qemu-system-x86_64 -drive format=raw,file=disk.img
exit /b 0

:debug
qemu-system-x86_64 -drive format=raw,file=disk.img -S -s -serial mon:stdio -d int -no-shutdown -no-reboot
exit /b 0