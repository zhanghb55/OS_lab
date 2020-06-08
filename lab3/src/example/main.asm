;
;  main.asm
;  Created by zhanghb on 2020/5/7.
;  Copyright © 2020 zhanghb. All rights reserved.
;

BITS 16
[extern fun]
global _start
_start:
    push msg
    call dword fun ; 进入命令行界面
    add ax,'0'
    mov ah, 0Eh            ; 功能号：打印一个字符
    mov bh, 0              ; bh=页码
    int 10h                ; 打印字符
    mov al,' '
    mov ah, 0Eh            ; 功能号：打印一个字符
    mov bh, 0              ; bh=页码
    int 10h                ; 打印字符
    mov al,'a'
    mov ah, 0Eh            ; 功能号：打印一个字符
    mov bh, 0              ; bh=页码
    int 10h                ; 打印字符
    mov al,'!'
    mov ah, 0Eh            ; 功能号：打印一个字符
    mov bh, 0              ; bh=页码
    int 10h                ; 打印字符
    jmp $

msg db 'I am zhanghb',0
