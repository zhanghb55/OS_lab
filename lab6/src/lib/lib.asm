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
[global get_segment]
[global get_address]
[global get_name]
[global Run]
[global getTime]
[global switchHotwheel]
[global print_pos]
[global write_vector]
[extern Timer]
[extern write_8]

[global call_int_21h]
[global call_int_22h]
[global shutoff]
[global write_20h]
[extern pflag]
[global int_30h]
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
    mov bl, 25            
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
    mov bl, 25            
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
    mov bl, 25              
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
    mov bl, 25              
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
;short get_segment(short order);
get_segment:
    push bp
    push bx
    mov bp, sp
    add bp, 4+4
    mov al, [bp]           ; al=pid
    add al, -1             ; al=pid-1
    mov bl, 25             ; 每个用户程序的信息块大小为24字节
    mul bl                 ; ax = (pid-1) * 24
    add ax, 1              ; ax = 1 + (pid-1) * 24
    add ax, 21             ; 加上addr在用户程序信息中的偏移
    mov bx, ax
    add bx, offset_user_info
    mov ax, [bx]
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
    mov bl, 25             ; 每个用户程序的信息块大小为24字节
    mul bl                 ; ax = (pid-1) * 24
    add ax, 1              ; ax = 1 + (pid-1) * 24
    add ax, 23             ; 加上addr在用户程序信息中的偏移
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
    mov bl, 25           
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
;void Run(short segment,short addr,char cylinder,char head,char sector,short len);
Run:
    pusha
    mov bp,sp
    add bp,4+16
    mov ax,[bp]
    mov es,ax

    mov bx,[bp + 4]
    mov ah,2
    mov dl,0
    mov ch,[bp + 8]
    mov dh,[bp + 12]
    mov cl,[bp + 16]
    mov al,[bp + 20]
    int 13H


    call dword pushCsIp    ; 用此技巧来手动压栈CS、IP; 此方法详见文档的“实验总结”栏目
    pushCsIp:
    mov si, sp             ; si指向栈顶
    mov word[si], return ; 修改栈中IP的值，这样用户程序返回回来后就可以继续执行了
    push word[bp]          ; 用户程序的段地址CS
    push word[bp+4]          ; 用户程序的偏移量IP
    retf
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

int20h:
    pop ax
    pop bx
    pop cx
    pop ax
    pop bx
    push cx
    push bx
    push ax
    iret
write_20h:
    pusha
    Replace_Vector 20h,39h
    Modify_Vector 20h,int20h
    popa
    ret

int_21h:
    push ax
    mov ah,byte[function]
	cmp ah,01h
	je pro1
	cmp ah,02h
	je pro2
    cmp ah,03h
	je pro3
	cmp ah,04h
	je pro4
pro1:
    call clean
    print_with_color name,name_len,4,16,06h
    print_with_color id,id_len,5,15,06h
    print_with_color msg21h_1,msg21h_1_len,6,7,06h
    jmp out
pro2:
    call clean
    print_with_color name,name_len,4,56,05h
    print_with_color id,id_len,5,55,05h
    print_with_color msg21h_2,msg21h_2_len,6,47,05h
    jmp out
pro3:
    call clean
    print_with_color name,name_len,16,16,04h
    print_with_color id,id_len,17,15,04h
    print_with_color msg21h_3,msg21h_3_len,18,7,04h
    jmp out
pro4:
    call clean
    print_with_color name,name_len,16,56,02h
    print_with_color id,id_len,17,55,02h
    print_with_color msg21h_4,msg21h_4_len,18,47,02h
    jmp out
out:
    mov ax,[delay1]
    cmp ax,65535
    je come_out

temp:
    mov ax,[delay2]
    cmp ax,10000
    je next
    inc word[delay2]
    jmp temp

next:
    mov ax,0
    mov [delay2],ax
    inc word[delay1]
    jmp out

come_out:
    mov ax,0
    mov [delay1],ax
    pop ax
    iret

msg21h db ' This is int 21h, please input function number 1~4 '
msg21h_len equ  $-msg21h
msg21h_1 db 'This is int 21h, ah = 01h'
msg21h_1_len equ  $-msg21h_1
msg21h_2 db 'This is int 21h, ah = 02h'
msg21h_2_len equ  $-msg21h_2
msg21h_3 db 'This is int 21h, ah = 03h'
msg21h_3_len equ  $-msg21h_3
msg21h_4 db 'This is int 21h, ah = 04h'
msg21h_4_len equ  $-msg21h_4

write_21h:
    pusha
    Replace_Vector 21h,39h
    Modify_Vector 21h,int_21h
    popa
    ret

Recover_21h:
    pusha
    Replace_Vector 39h,21h
    popa
    ret 
call_int_21h:
    pusha
    call write_21h
    print msg21h,msg21h_len,13,14
input:
	mov ah, 0
	int 16h
	cmp al, '1'
	jl err
	cmp al, '4'
	jg err
    sub al,'0'
    mov byte[function],al
    int 21h

err:
    call Recover_21h
    popa
    retf

function dw 0;功能号
delay_count equ 0
delay1 dw 0
delay2 dw 0
int_22h:
    push ax
    print msg22h,msg22h_len,13,35
    jmp out

msg22h db ' int 22h '
msg22h_len equ  $-msg22h
write_22h:
    pusha
    Replace_Vector 22h,39h
    Modify_Vector 22h,int_22h
    popa
    ret

Recover_22h:
    pusha
    Replace_Vector 39h,22h
    popa
    ret 
call_int_22h:
    pusha
    call write_22h
    int 22h
    call Recover_22h
    popa
    retf

int_30h:
    mov ax,[cs:pflag]
    iret