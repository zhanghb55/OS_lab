BITS 16

offset_user_info equ 7E00h;用户程序在内存中位置
offset_kernel equ 8000h;内核在内存中的位置

org  7c00h

;为了输出方便在网上找了一个轮子
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

section .data
	msg db 'Welcome to ZhbOS, press Enter to start!'
	msglen equ ($-msg)
	msg1 db 'ZhbOS V2.0'
	msglen1 equ ($-msg1)
	msg2 db 'Zhang Hongbin,18340208'
	msglen2 equ ($-msg2)

section .text
begin:
  	call cls
	print msg2,msglen2,7,29
	print msg1,msglen1,5,35
	print msg,msglen,20,24 

Loop:
    mov ah, 0
    int 16h
    cmp al, 0dh      ; 按下回车
    jne Loop     ; 无效按键，重新等待用户按键

	mov cx,2607H
	int 10h
Load_user_pro_info:
	mov cl, 2
	mov ax, cs
	mov es, ax
	mov ah, 2
	mov al, 1
	mov dl, 0
	mov dh, 0
	mov ch, 0
	mov bx, offset_user_info
	int 13h

Load_kernel:
	mov cl, 3
	mov ax, cs
	mov es, ax
	mov ah, 2
	mov al, 34
	mov dl, 0
	mov dh, 0
	mov ch, 0
	mov bx, offset_kernel
	int 13h		



	jmp offset_kernel

	jmp $
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


