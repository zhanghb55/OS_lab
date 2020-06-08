
;
;  d.asm
;  Created by zhanghb on 2020/4/7.
;  Copyright © 2020 zhanghb. All rights reserved.
;
Dn_Rt equ 1	; D-Down,U-Up,R-right,L-Left
Up_Rt equ 2
Up_Lt equ 3
Dn_Lt equ 4
WIDTH equ 80
HEIGHT equ 25
LENGTH equ 17	; 字符串的长度

Left equ 40
Right equ 80
Up equ 13
Down equ 25

instruction equ 8000h
org 0A900h
section .data
	count dd 1
	x dw 13
	y dw 40
	direct db Dn_Rt	; 向右下运动
	message db '2285075600@qq.com'
section .text
	pusha
	mov ax,0B800h
	mov gs,ax	;将显示内存段地址放入gs寄存器
Loop:
	;计数变量用于制造循环使跳动变慢
	dec dword[count]
	jnz Loop	
	mov dword[count],99999999
	;通过比较direct变量来确定下一个方向，然后跳转到下一个方向到位置
	cmp byte[direct],Dn_Rt
	jz  dnrt
	cmp byte[direct],Up_Rt
	jz  uprt
	cmp byte[direct],Up_Lt
	jz  uplt
	cmp byte[direct],Dn_Lt
	jz  dnlt
dnrt:
	inc word[x]
	inc word[y]
	mov ax,Down-1;判断x是否触到边界
	sub ax,word[x]
	jz  dr2ur
	mov ax,Right-LENGTH;判断y是否触到边界
	sub ax,word[y]
	jz  dr2dl
	jmp Print_empty
dr2ur:
	mov ax,Right-LENGTH;判断y是否触到边界
	sub ax,word[y]
	jz RD_point
	mov byte[direct],Up_Rt
	jmp Print_empty
dr2dl:
	mov byte[direct],Dn_Lt
	jmp Print_empty

RD_point:
	mov byte[direct],Up_Lt
	jmp Print_empty

uprt:
	dec word[x]
	inc word[y]
	mov ax,Up
	sub ax,word[x]
	jz  ur2dr
	mov ax,Right-LENGTH
	sub ax,word[y]
	jz  ur2ul
	jmp Print_empty
ur2dr:
	mov ax,Right-LENGTH
	sub ax,word[y]
	jz  RU_point
	mov byte[direct],Dn_Rt
	jmp Print_empty
ur2ul:
	mov byte[direct],Up_Lt
	jmp Print_empty

RU_point:
	mov byte[direct],Dn_Lt
	jmp Print_empty


uplt:
	dec word[x]
	dec word[y]
	mov ax,Up
	sub ax,word[x]
	jz  ul2dl
	mov ax,Left
	sub ax,word[y]
	jz  ul2ur
	jmp Print_empty
ul2dl:
	mov ax,Left
	sub ax,word[y]
	jz  UL_point
	mov byte[direct],Dn_Lt
	jmp Print_empty
ul2ur:
	mov byte[direct],Up_Rt
	jmp Print_empty

UL_point:
	mov byte[direct],Dn_Rt
	jmp Print_empty	


dnlt:
	inc word[x]
	dec word[y]
	mov ax,Down-1
	sub ax,word[x]
	jz  dl2ul
	mov ax,Left
	sub ax,word[y]
	jz  dl2dr
	jmp Print_empty
dl2ul:
	mov ax,Left
	sub ax,word[y]
	jz  DL_point
	mov byte[direct],Up_Lt
	jmp Print_empty
dl2dr:
	mov byte[direct],Dn_Rt
	jmp Print_empty

DL_point:
	mov byte[direct],Up_Rt
	jmp Print_empty
Print:;用于打印当前位置的字符串
	xor ax,ax
	mov word ax,[x]
	mov bx,WIDTH
	mul bx
	add word ax,[y]
	mov bx,2
	mul bx
	mov bx,ax
	mov dx,bx;将地址保存在dx，用于清除时使用
	mov si, message
	mov cx, LENGTH
	printStr:
		mov byte al,[si]
		and ah,15
		mov [gs:bx],ax;将字符放到显示内存段
		inc si
		inc bx
		inc bx
	loop printStr
	jmp check

Print_empty:;用于清空上次打印到内容
	mov ax, 0B800h
	mov si, 160
	mov cx, 80*25
	mov dx, 0
	clsLoop:
		mov [gs:si], dx
		add si, 2
	loop clsLoop
	jmp Print

check:
	mov ah, 01h
	int 16h
	jz Loop
	mov ah, 00h
	int 16h
	cmp ax, 2e03h	; 检测Ctrl + C
	jne Loop
	jmp click


click:
	popa
	retf
