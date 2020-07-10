;
;  lib.asm
;  Created by zhanghb on 2020/5/1.
;  Copyright © 2020 zhanghb. All rights reserved.
;

BITS 16


[global clean]
[global print_at_point]
[global putchar]
[global getch]
[global print_pos]

begin_pos equ ((80*24+50)*2)


;输出一个字符
putchar:                   ; 函数：在光标处打印一个字符
    push bp
    push ax
    push bx
    mov bp, sp
    add bp, 6+4            ; 参数地址
    mov al, [bp]           ; al=要打印的字符
    mov ah, 0Eh            ; 功能号：打印一个字符
    mov bh, 0              ; bh=页码
    int 10h                ; 打印字符
    pop bx
    pop ax
    pop bp
    ret

getch:                     
    mov ah, 0              
    int 16h                
    mov ah, 0           
    ret

;void print_at_point(char string[16],int len,int x,int y)
print_at_point:                
    pusha
    mov si,sp
    add si, 16+4  ;找到首个参数
	mov ax, cs
	mov ds, ax
	mov bp, [si]
	mov ax, ds
	mov es, ax
	mov cx, [si+4]
	mov ah, 13h
	mov al, 01h
	mov bh, 00h
	mov bl, 07h	
	mov dh, [si+8]
	mov dl, [si+12]
	int 10h
    popa
    ret

clean:               
    push ax
    mov ax, 0003h
    int 10h              
    pop ax
    ret


;void print_pos(char s,int x,int y)
print_pos:
    pusha
    mov si,sp
    add si, 16+4  ;找到首个参数
	mov ax, cs
	mov ds, ax
	mov bp, [si]

	xor ax,ax
	mov word ax,[si+4]
	mov bx,80
	mul bx
	add word ax,[si+8]
	mov bx,2
	mul bx
	mov bx,ax
	mov dx,bx;将地址保存在dx，用于清除时使用

    mov ax,[si]
    mov ah,03h
    mov [gs:bx],ax;将字符放到显示内存段

    popa
    retf
