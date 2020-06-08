IMG = zhbos.img
INFO = loader.bin user_info.bin
KERNEL = kernel.bin
PRO = a.com b.com c.com d.com

all:	pro img clean


img:$(INFO) $(KERNEL) $(PRO) 
ifeq ($(IMG), $(wildcard $(IMG)))
	rm $(IMG)
endif
	/sbin/mkfs.msdos -C $(IMG) 1440
	dd if=loader.bin of=$(IMG) conv=notrunc
	dd if=user_info.bin of=$(IMG) seek=1 conv=notrunc
	dd if=kernel.bin of=$(IMG) seek=3 conv=notrunc
	dd if=a.com of=$(IMG) seek=18 conv=notrunc
	dd if=b.com of=$(IMG) seek=19 conv=notrunc
	dd if=c.com of=$(IMG) seek=20 conv=notrunc
	dd if=d.com of=$(IMG) seek=21 conv=notrunc	

pro:$(INFO) $(KERNEL) $(PRO) 
loader.bin: loader.asm
	nasm  $< -o $@
user_info.bin: user_info.asm
	nasm  $< -o $@
kernel.bin: kernel.o lib.o libc.o
	ld -m elf_i386 -N -Ttext 0x8000 --oformat binary  $^ -o $@

%.o : %.asm
	nasm -f elf32 $< -o $@

%.o : %.c
	gcc -march=i386 -m16 -mpreferred-stack-boundary=2 -ffreestanding -fno-PIE -masm=intel -c $< -o $@
%.com : %.asm
	nasm $< -o $@

.PHONY:clean
clean:
	rm -rf *o *bin *com