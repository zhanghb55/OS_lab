offset_user1 equ 0B300h
offset_user2 equ 0B700h
offset_user3 equ 0BB00h
offset_user4 equ 0BF00h
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
