;
;  lib.asm
;  Created by zhanghb on 2020/5/1.
;  Copyright © 2020 zhanghb. All rights reserved.
;
%include"Macro.asm"
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
[global switchHotwheel]
[global print_pos]
[global write_vector]
[extern Timer]
[extern write_8]
[global write_33_36]
[global call_int_33]
[global call_int_34]
[global call_int_35]
[global call_int_36]
[global shutoff]


begin_pos equ ((80*24+50)*2)
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

switchHotwheel:                 ; 函数：打开或关闭风火轮
    pusha
    push es
    mov ax, 0
    mov es, ax
    mov ax, [es:08h*4]          
    cmp ax, Timer               ;判断8号中断向量处是否为自己写的时间中断
    je turnoff                  ;是则关闭
    call dword write_8          ;不是则关闭
    mov ax, 1                   
    jmp switchDone
turnoff:
    Replace_Vector 34h, 08h
    mov	ax, 0B800h              
    mov	gs, ax                   
    mov cx,50
    mov bx,begin_pos
Loop:
    cmp cx,80
    jz clear_end
    mov ah, 0Fh                 ;黑色背景    
    mov al, ' '               
    mov [gs:bx], ax             ;打印空格
    inc cx
    inc bx
    inc bx
    jmp Loop
clear_end:
    mov ax, 0                   ; 返回0表示风火轮已关闭
switchDone:
    pop es
    popa
    retf

shutoff:                         ;关闭风火轮
    pusha
    push es
    mov ax, 0
    mov es, ax
    mov ax, [es:08h*4]          
    cmp ax, Timer               ;检查08h号中断处理程序是否是风火轮
    je turnoff                  ;如果是，则关闭
    mov ax, 1                   ;如果不是，说明原来的就是关闭的
    jmp switchDone

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
    
write_vector:
    pusha
    push es
    mov si,sp
    add si, 18+4  ;找到首个参数
    mov ax, 0
    mov es, ax                  ; ES = 0
    mov bx,[si]
    mov ax,[si+4]
    mov word[es:bx],ax        ; 设置中断向量的偏移地址
    mov ax,cs
    add bx,2
    mov word[es:bx], ax     ; 设置中断向量的段地址=CS
    pop es
    popa
    retf


int_33:
    push ax
    push si
    push ds
    push gs
    print_with_color name,name_len,4,16,06h
    print_with_color id,id_len,5,15,06h
    print_with_color msg1,msg1_len,6,13,06h
check0:
	mov ah, 01h
	int 16h
	jz check0
	mov ah, 00h
	int 16h
	cmp ax, 2e03h	; 检测Ctrl + C
	jne check0
    pop gs
    pop ds
    pop si
    pop ax
    iret
int_34:
    push ax
    push si
    push ds
    push gs
    print_with_color name,name_len,4,56,05h
    print_with_color id,id_len,5,55,05h
    print_with_color msg2,msg2_len,6,53,05h
check1:
	mov ah, 01h
	int 16h
	jz check1
	mov ah, 00h
	int 16h
	cmp ax, 2e03h	; 检测Ctrl + C
	jne check1
    pop gs
    pop ds
    pop si
    pop ax
    iret
int_35:
    push ax
    push si
    push ds
    push gs
    print_with_color name,name_len,16,16,04h
    print_with_color id,id_len,17,15,04h
    print_with_color msg3,msg3_len,18,13,04h
check2:
	mov ah, 01h
	int 16h
	jz check2
	mov ah, 00h
	int 16h
	cmp ax, 2e03h	; 检测Ctrl + C
	jne check2
    pop gs
    pop ds
    pop si
    pop ax
    iret
int_36:
    push ax
    push si
    push ds
    push gs
    print_with_color name,name_len,16,56,02h
    print_with_color id,id_len,17,55,02h
    print_with_color msg4,msg4_len,18,53,02h
check3:
	mov ah, 01h
	int 16h
	jz check3
	mov ah, 00h
	int 16h
	cmp ax, 2e03h	; 检测Ctrl + C
	jne check3
    pop gs
    pop ds
    pop si
    pop ax
    iret
name db 'zhanghb'
name_len equ  $-name
id db '18340208'
id_len equ  $-id
msg1 db 'This is int 33'
msg1_len equ  $-msg1
msg2 db 'This is int 34'
msg2_len equ  $-msg2
msg3 db 'This is int 35'
msg3_len equ  $-msg3
msg4 db 'This is int 36'
msg4_len equ  $-msg4

delay_value dw 0
write_33:
    pusha
    Replace_Vector 33,39h
    Modify_Vector 33,int_33
    popa
    ret
Recover_33:
    pusha
    Replace_Vector 39h,33
    popa
    ret 

write_34:
    pusha
    Replace_Vector 34,39h
    Modify_Vector 34,int_34
    popa
    ret
Recover_34:
    pusha
    Replace_Vector 39h,34
    popa
    ret 

write_35:
    pusha
    Replace_Vector 35,39h
    Modify_Vector 35,int_35
    popa
    ret
Recover_35:
    pusha
    Replace_Vector 39h,35
    popa
    ret 
write_36:
    pusha
    Replace_Vector 36,39h
    Modify_Vector 36,int_36
    popa
    ret
Recover_36:
    pusha
    Replace_Vector 39h,36
    popa
    ret 
call_int_33:
    pusha
    call write_33
    int 33
    call Recover_33
    popa
    retf

call_int_34:
    pusha
    call write_34
    int 34
    call Recover_34
    popa
    retf

call_int_35:
    pusha
    call write_35
    int 35
    call Recover_35
    popa
    retf

call_int_36:
    pusha
    call write_36
    int 36
    call Recover_36
    popa
    retf
