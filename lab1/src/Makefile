IMG = zhb.img
BIN = zhb.bin

all:	pro img clean

img:$(BIN)
ifeq ($(IMG), $(wildcard $(IMG)))
	rm $(IMG)
endif
	mkfile -n 2880b $(IMG)
	dd if=$(BIN) of=$(IMG) conv=notrunc
	
pro:$(BIN) 
$(BIN):zhb.asm
	nasm  $< -o $@

.PHONY:clean
clean:
	rm -rf *o *bin 


