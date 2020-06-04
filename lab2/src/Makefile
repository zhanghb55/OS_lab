IMG = zhbOS.img
PRO = loader.com a.com b.com c.com d.com

all:	pro img clean


img:$(PRO) 
ifeq ($(IMG), $(wildcard $(IMG)))
	rm $(IMG)
endif
	mkfile -n 2880b $(IMG)
	dd if=loader.com of=$(IMG) conv=notrunc
	dd if=a.com of=$(IMG) seek=1 conv=notrunc
	dd if=b.com of=$(IMG) seek=2 conv=notrunc
	dd if=c.com of=$(IMG) seek=3 conv=notrunc
	dd if=d.com of=$(IMG) seek=4 conv=notrunc	

pro:

%.com : %.asm
	nasm $< -o $@

.PHONY:clean
clean:
	rm -rf *com



