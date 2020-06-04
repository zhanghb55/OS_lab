OffSetOfUserPrg equ 0A100h
org  7c00h


%macro print 4	; string, length, x, y
	mov ax, cs
	mov ds, ax
	mov bp, %1
	mov ax, ds
	mov es, ax
	mov cx, %2
	mov ah, 13h
	mov al, 00h
	mov bh, 00h
	mov bl, 07h	
	mov dh, %3
	mov dl, %4
	int 10h
%endmacro



section .text
begin:
  	call cls
	print msg2, msglen2,5,35
	print msg3, msglen3,6,29
	print msg, msglen,15,8
input:
	mov ah, 0
	int 16h
	cmp al, '1'
	jl input
	cmp al, '4'
	jg input
	mov [chosse], al
	call cls
	print msg1, msglen1, 0, 14
	print chosse, 1, 0, 22

  	mov cl, [chosse]
  	sub cl, '0'-1  ;从第二个扇区开始
	mov ax, cs
	mov es, ax
	mov ah, 2
	mov al, 1
	mov dl, 0
	mov dh, 0
	mov ch, 0
  	mov bx, OffSetOfUserPrg
	int 13H
	jmp OffSetOfUserPrg
cls:
	mov ax, 0B800h
	mov es, ax
	mov si, 0
	mov cx, 80*25
	mov dx, 0
	clsLoop:
		mov [es:si], dx
		add si, 2
	loop clsLoop
	ret

	msg db ' Welcome to ZhbOS, input a number from 1 to 4 to chosse a program!'
	msglen equ ($-msg)
	msg1 db 'Program 0 is here, you can press Ctrl + C to return!'
	msglen1 equ ($-msg1)
	msg2 db 'ZhbOS V1.0'
	msglen2 equ ($-msg2)
	msg3 db 'Zhang Hongbin,18340208'
	msglen3 equ ($-msg3)
	
	chosse db '1'


	times 510-($-$$) db 0  ;重复n次每次填充值为0
  	dw 55aah