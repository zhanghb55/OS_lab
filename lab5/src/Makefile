IMG = zhbos.img
INFO = loader.bin user_info.bin
KERNEL = kernel.bin
PRO = a.com b.com c.com d.com e.com


KernelSrc= ./kernel/
UserSrc = ./user/
LibSrc = ./lib/
UserLibSrc = ./user_lib/
CUserSrc = ./user/e/

all:	pro img clean


img:$(INFO) $(KERNEL) $(PRO) 
ifeq ($(IMG), $(wildcard $(IMG)))
	rm $(IMG)
endif
	/sbin/mkfs.msdos -C $(IMG) 1440
	dd if=loader.bin of=$(IMG) bs=512 count=1 conv=notrunc
	dd if=user_info.bin of=$(IMG) bs=512 seek=1 count=1 conv=notrunc
	dd if=kernel.bin of=$(IMG) bs=512 seek=2 count=34 conv=notrunc
	dd if=a.com of=$(IMG) bs=512 seek=36 count=2 conv=notrunc
	dd if=b.com of=$(IMG) bs=512 seek=38 count=2 conv=notrunc
	dd if=c.com of=$(IMG) bs=512 seek=40 count=2 conv=notrunc
	dd if=d.com of=$(IMG) bs=512 seek=42 count=2 conv=notrunc
	dd if=e.com of=$(IMG) bs=512 seek=44 count=4 conv=notrunc

pro:$(INFO) $(KERNEL) $(PRO) 
loader.bin:loader.asm
	nasm  $< -o $@
user_info.bin: user_info.asm
	nasm  $< -o $@
kernel.bin: kernel.o lib.o ckernel.o wheel.o
	ld -m elf_i386 -N -Ttext 0x8000 --oformat binary  $^ -o $@
e.com: e.o user_lib.o ce.o
	ld -m elf_i386 -N -Ttext 0x0AB00 --oformat binary  $^ -o $@

%.o : $(KernelSrc)%.asm
	nasm -f elf32 $< -o $@
%.o : $(UserLibSrc)%.asm
	nasm -f elf32 $< -o $@
%.o : $(CUserSrc)%.asm
	nasm -f elf32 $< -o $@
%.o : $(LibSrc)%.asm
	nasm -f elf32 $< -o $@
%.o : $(CUserSrc)%.c
	gcc -march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding -fno-PIE -masm=intel -c $< -o $@
%.o : $(KernelSrc)%.c
	gcc -march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding -fno-PIE -masm=intel -c $< -o $@
%.com : $(UserSrc)%.asm
	nasm $< -o $@

.PHONY:clean
clean:
	rm -rf *o *bin *com
