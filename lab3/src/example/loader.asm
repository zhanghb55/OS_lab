BITS 16

offset equ 8000h;实例程序在内存中的位置

org  7c00h


section .text
begin:
  	
Load_program:
	mov cl, 2
	mov ax, cs
	mov es, ax
	mov ah, 2
	mov al, 16
	mov dl, 0
	mov dh, 0
	mov ch, 0
	mov bx, offset
	int 13h		
	jmp offset
	jmp $


