#!/bin/bash
rm *.img
rm *.o
rm *.bin

nasm loader.asm -o loader.bin
nasm -f elf32 main.asm -o main.o
nasm -f elf32 count.asm -o count.o
gcc -c -march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding -fno-PIE -masm=intel -c count.c -o c_count.o
ld -m elf_i386 -N -Ttext 0x8000 --oformat binary main.o count.o c_count.o -o program.bin


/sbin/mkfs.msdos -C example.img  1440

dd if=loader.bin of=example.img bs=512 conv=notrunc
dd if=program.bin of=example.img bs=512 seek=1 conv=notrunc

echo "[+] Done."
