offset_user1 equ 0B300h
offset_user2 equ 0B700h
offset_user3 equ 0BB00h
offset_user4 equ 0BF00h
offset_user5 equ 0AB00h
%macro Modify_Vector 2       ; 写中断向量表；参数：（中断号，中断处理程序地址）
    push ax
    push es
    mov ax, 0
    mov es, ax                  ; ES = 0
    mov word[es:%1*4], %2       ; 设置中断向量的偏移地址
    mov ax,cs
    mov word[es:%1*4+2], ax     ; 设置中断向量的段地址=CS
    pop es
    pop ax
%endmacro

%macro Replace_Vector 2        ; 将参数1的中断向量转移至参数2处
    push ax
    push es
    push si
    mov ax, 0
    mov es, ax
    mov si, [es:%1*4]
    mov [es:%2*4], si
    mov si, [es:%1*4+2]
    mov [es:%2*4+2], si
    pop si
    pop es
    pop ax
%endmacro

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
%macro print_with_color 5	; string, length, x, y
	mov ax, cs
	mov ds, ax
	mov bp, %1
	mov ax, ds
	mov es, ax
	mov cx, %2
	mov ah, 13h
	mov al, 00h
	mov bh, 00h
	mov bl, %5	
	mov dh, %3
	mov dl, %4
	int 10h
%endmacro

%macro register 0       ; 参数：段值
    dw 0                           ; ax，偏移量=+0
    dw 0                           ; cx，偏移量=+2
    dw 0                           ; dx，偏移量=+4
    dw 0                           ; bx，偏移量=+6
    dw 0FE00h                      ; sp，偏移量=+8
    dw 0                           ; bp，偏移量=+10
    dw 0                           ; si，偏移量=+12
    dw 0                           ; di，偏移量=+14
    dw 0                           ; ds，偏移量=+16
    dw 0                           ; es，偏移量=+18
    dw 0                           ; fs，偏移量=+20
    dw 0B800h                      ; gs，偏移量=+22
    dw 0                           ; ss，偏移量=+24
    dw 0                           ; ip，偏移量=+26
    dw 0                           ; cs，偏移量=+28
    dw 512                         ; flags，偏移量=+30
%endmacro
%macro Save 1     ;参数：寄存器状态表
    push ss
    push gs
    push fs
    push es
    push ds
    push di
    push si
    push bp
    push sp
    push bx
    push dx
    push cx
    push ax                     
    mov bp, sp
    mov di, %1
    mov ax, [bp]
    mov [cs:di], ax
    mov ax, [bp+2]
    mov [cs:di+2], ax
    mov ax, [bp+4]
    mov [cs:di+4], ax
    mov ax, [bp+6]
    mov [cs:di+6], ax
    mov ax, [bp+8]
    mov [cs:di+8], ax
    mov ax, [bp+10]
    mov [cs:di+10], ax
    mov ax, [bp+12]
    mov [cs:di+12], ax
    mov ax, [bp+14]
    mov [cs:di+14], ax
    mov ax, [bp+16]
    mov [cs:di+16], ax
    mov ax, [bp+18]
    mov [cs:di+18], ax
    mov ax, [bp+20]
    mov [cs:di+20], ax
    mov ax, [bp+22]
    mov [cs:di+22], ax
    mov ax, [bp+24]
    mov [cs:di+24], ax
    mov ax, [bp+26]
    mov [cs:di+26], ax
    mov ax, [bp+28]
    mov [cs:di+28], ax
    mov ax, [bp+30]
    mov [cs:di+30], ax
%endmacro

%macro Restart 1      ;参数：寄存器状态表 
    mov si, %1                   

    mov ax, [cs:si+0]
    mov cx, [cs:si+2]
    mov dx, [cs:si+4]
    mov bx, [cs:si+6]
    mov sp, [cs:si+8]
    mov bp, [cs:si+10]
    mov di, [cs:si+14]
    mov ds, [cs:si+16]
    mov es, [cs:si+18]
    mov fs, [cs:si+20]
    mov gs, [cs:si+22]
    mov ss, [cs:si+24]
    add sp, 11*2                   

    push word[cs:si+30]           
    push word[cs:si+28]          
    push word[cs:si+26]           

    push word[cs:si+12]
    pop si                      
%endmacro