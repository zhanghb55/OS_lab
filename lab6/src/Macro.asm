offset_user1 equ 10000h
offset_user2 equ 20000h
offset_user3 equ 30000h
offset_user4 equ 40000h
offset_user5 equ 0AB00h
speed_delay equ 19999999
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

%macro LOAD_TO_MEM 6        ; 读软盘到内存；参数：（扇区数，柱面号，磁头号，扇区号，内存段值，内存偏移量）
    pusha
    push es
    mov ax, %5              ; 段地址; 存放数据的内存基地址
    mov es, ax              ; 设置段地址（不能直接mov es,段地址）
    mov bx, %6              ; 偏移地址; 存放数据的内存偏移地址
    mov ah, 2               ; 功能号
    mov al, %1              ; 扇区数
    mov dl, 0               ; 驱动器号; 软盘为0，硬盘和U盘为80H
    mov dh, %3              ; 磁头号; 起始编号为0
    mov ch, %2              ; 柱面号; 起始编号为0
    mov cl, %4              ; 起始扇区号 ; 起始编号为1
    int 13H                 ; 调用读磁盘BIOS的13h功能
    pop es
    popa
%endmacro

%macro PCB 0       ; 参数：段值
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
    db 0                           ; id，进程ID，偏移量=+32
    db 0                           ; state，{0:新建态; 1:就绪态; 2:运行态}，偏移量=+33
%endmacro