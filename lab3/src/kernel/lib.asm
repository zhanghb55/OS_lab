
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
[global Poweroff]
[global Reboot]
[global get_number_of_program]
[global get_size]
[global get_cylinder]
[global get_head]
[global get_sector]
[global get_address]
[global get_name]
[global Run]
[global getTime]
offset_user_info equ 7E00h;用户程序在内存中位置
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


;char get_number_of_program();
get_number_of_program:
    mov al, [offset_user_info]
    ret
;short get_size(short order);
get_size:
    push bx
    push bp
    mov bp, sp
    add bp, 4+4
    mov al, [bp]           
    add al, -1             
    mov bl, 23            
    mul bl                             
    add ax, 16            
    add ax, 1
    mov bx, ax
    add bx, offset_user_info
    mov ax, [bx]
    pop bp
    pop bx
    ret    

;char get_cylinder(short order);
get_cylinder:
    push bx
    push bp
    mov bp, sp
    add bp, 4+4
    mov al, [bp]          
    add al, -1             
    mov bl, 23            
    mul bl                
    add ax, 18             
    add ax, 1 
    mov bx, ax
    add bx, offset_user_info
    mov al, [bx]
    mov ah, 0
    pop bp
    pop bx
    ret
    
;char get_head(short order);
get_head:
    push bp
    push bx
    mov bp, sp
    add bp, 4+4
    mov al, [bp]           
    add al, -1              
    mov bl, 23              
    mul bl                
    add ax, 19             
    add ax, 1            
    mov bx, ax
    add bx, offset_user_info
    mov al, [bx]
    mov ah, 0
    pop bx
    pop bp
    ret
;char get_sector(short order);
get_sector:
    push bp
    push bx
    mov bp, sp
    add bp, 4+4
    mov al, [bp]          
    add al, -1             
    mov bl, 23              
    mul bl                
    add ax, 20              
    add ax, 1           
    mov bx, ax
    add bx, offset_user_info
    mov al, [bx]
    mov ah, 0
    pop bx
    pop bp
    ret
;short get_address(short order);
get_address:
    push bp
    push bx
    mov bp, sp
    add bp, 4+4
    mov al, [bp]           ; al=pid
    add al, -1             ; al=pid-1
    mov bl, 23             ; 每个用户程序的信息块大小为24字节
    mul bl                 ; ax = (pid-1) * 24
    add ax, 1              ; ax = 1 + (pid-1) * 24
    add ax, 21             ; 加上addr在用户程序信息中的偏移
    mov bx, ax
    add bx, offset_user_info
    mov ax, [bx]
    pop bx
    pop bp
    ret
get_name:
    push bp
    push bx
    mov bp, sp
    add bp, 4+4
    mov al, [bp]         
    add al, -1             
    mov bl, 23           
    mul bl                
    add ax, 1            
    add ax, offset_user_info  
    pop bx
    pop bp
    ret
;清屏函数
clean:               
    push ax
    mov ax, 0003h
    int 10h              
    pop ax
    ret

;关机                
Poweroff:                  
	mov ax,5307H ;高级电源管理功能,设置电源状态 
	mov bx,0001H ;设备ID,1:所有设备 
	mov cx,0003H ;状态,3:表示关机 
	int 15H 
	jmp $ ;loop at current postion

    
;重启
Reboot:                     
    mov al, 0FEh
    out 64h, al
    ret
;运行程序
;void Run(short addr,char cylinder,char head,char sector,short len);
Run:
    pusha
    mov bp,sp
    add bp,4+16
    mov ax,cs
    mov es,ax

    mov bx,[bp]
    mov ah,2
    mov dl,0
    mov ch,[bp + 4]
    mov dh,[bp + 8]
    mov cl,[bp + 12]
    mov al,[bp + 16]
    int 13H


    call dword pushCsIp    ; 用此技巧来手动压栈CS、IP; 此方法详见文档的“实验总结”栏目
    pushCsIp:
    mov si, sp             ; si指向栈顶
    mov word[si], return ; 修改栈中IP的值，这样用户程序返回回来后就可以继续执行了
    jmp [bp]
return:
    popa
    ret


getTime:                   
    push bp
    push sp
    mov bp, sp
    add bp, 4+4
    mov al,[bp]
    out 70h, al
    in al, 71h
    mov ah, 0
    pop sp
    pop bp
    ret
