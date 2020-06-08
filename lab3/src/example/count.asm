;
;  count.asm
;  Created by zhanghb on 2020/5/7.
;  Copyright © 2020 zhanghb. All rights reserved.
;

BITS 16


[global clean]
[global putchar]

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

;清屏函数
clean:               
    push ax
    mov ax, 0003h
    int 10h              
    pop ax
    ret
