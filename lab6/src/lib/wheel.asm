%include "Macro.asm"
BITS 16
[global Timer]
[extern print_time]
[global pflag]
[global loadProcessMem]

Timer:                             
    cmp word[cs:pflag], 0
    je QuitTimer
    ;压栈，用来保存寄出去，使得作为中间变量的寄存器易于存储
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

Save:                           
    pusha
    mov bp, sp
    add bp, 16                     
    mov di, all_pcb

    mov ax, 34
    mul word[cs:Pid]
    add di, ax                     
    ;将栈中寄存器依次保存到进程控制块
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

    popa
                   
    add sp, 16                  

Schedule:                       
    pusha
    mov si, all_pcb
    mov ax, 34
    mul word[cs:Pid]
    add si, ax                     ;si指向进程控制块表的地址，即第一个进程控制块的地址
    mov byte[cs:si+33], 1          

    mov ah, 01h
	int 16h
	jz NextPCB
	mov ah, 00h
	int 16h
	cmp ax, 2e03h	;检测Ctrl + C
	jne NextPCB

    mov word[cs:Pid], 0
    mov word[cs:pflag], 0     ;将并行标志设置为不允许并行
    call resetAllPcbExceptZero
    jmp QuitSchedule
NextPCB:                  ;找到下一个就绪态
    inc word[cs:Pid]
    add si, 34                 ;si指向下一PCB的首地址
    cmp word[cs:Pid], 9
    jna Exceed         ;若id递增到10，则将其恢复为1
    mov word[cs:Pid], 1
    mov si, all_pcb+34       ;si指向1号进程的PCB的首地址
Exceed:
    cmp byte[cs:si+33], 1      ;判断下一进程是否处于就绪态
    jne NextPCB           ;不是就绪态，则尝试下一个进程
    mov byte[cs:si+33], 2      ;是就绪态，则设置为运行态。调度完毕
QuitSchedule:
    popa
                

Restart:                       
    mov si, all_pcb
    mov ax, 34
    mul word[cs:Pid]
    add si, ax                     ;si指向调度后的PCB的首地址

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
    add sp, 11*2                   ;恢复正确的sp

    push word[cs:si+30]            ;新进程flags
    push word[cs:si+28]            ;新进程cs
    push word[cs:si+26]            ;新进程ip

    push word[cs:si+12]
    pop si                         ;恢复si
QuitParallel:
    push ax
    mov al, 20h
    out 20h, al
    out 0A0h, al
    pop ax
    iret

QuitTimer:
    call now
    push ax
    mov al, 20h
    out 20h, al
    out 0A0h, al
    pop ax
    iret

    pflag dw 0
    Pid dw 0

all_pcb:                   
    pcb_0: PCB        
    pcb_1: PCB
    pcb_2: PCB
    pcb_3: PCB
    pcb_4: PCB
    pcb_5: PCB
    pcb_6: PCB
    pcb_7: PCB
    pcb_8: PCB
    pcb_9: PCB




;extern void loadProcessMem(uint8_t cylinder, uint8_t head, uint8_t sector, uint16_t len, uint16_t seg, uint16_t offset, int progid_to_run);
loadProcessMem:                    ;函数：将某个用户程序加载入内存并初始化其PCB
    pusha
    mov bp, sp
    add bp, 16+4                   ;参数地址
    LOAD_TO_MEM [bp+12], [bp], [bp+4], [bp+8], [bp+16], [bp+20]

    mov si, all_pcb
    mov ax, 34
    mul word[bp+24]                ;progid_to_run
    add si, ax                     ;si指向新进程的PCB

    mov ax, [bp+24]                ;ax=progid_to_run
    mov byte[cs:si+32], al         ;id
    mov ax, [bp+16]                ;ax=用户程序的段值
    mov word[cs:si+16], ax         ;ds
    mov word[cs:si+18], ax         ;es
    mov word[cs:si+20], ax         ;fs
    mov word[cs:si+24], ax         ;ss
    mov word[cs:si+28], ax         ;cs
    mov byte[cs:si+33], 1          ;state设其状态为就绪态
    popa
    retf

resetAllPcbExceptZero:
    push cx
    push si
    mov cx, 9                      ;共10个PCB
    mov si, all_pcb+34

    loop1:
        mov word[cs:si+0], 0       ;ax
        mov word[cs:si+2], 0       ;cx
        mov word[cs:si+4], 0       ;dx
        mov word[cs:si+6], 0       ;bx
        mov word[cs:si+8], 0FE00h  ;sp
        mov word[cs:si+10], 0      ;bp
        mov word[cs:si+12], 0      ;si
        mov word[cs:si+14], 0      ;di
        mov word[cs:si+16], 0      ;ds
        mov word[cs:si+18], 0      ;es
        mov word[cs:si+20], 0      ;fs
        mov word[cs:si+22], 0B800h ;gs
        mov word[cs:si+24], 0      ;ss
        mov word[cs:si+26], 0      ;ip
        mov word[cs:si+28], 0      ;cs
        mov word[cs:si+30], 512    ;flags
        mov byte[cs:si+32], 0      ;id
        mov byte[cs:si+33], 0      ;state=新建态
        add si, 34                 ;si指向下一个PCB
        loop loop1

    pop si
    pop cx
    ret

now:
	push ax
	push ds
	push gs
	push si
	push es

	mov ax,0
	mov es,ax
	mov ax,cs
	mov ds,ax              
	mov	ax,0B800h		
	mov	gs,ax			 ;gs置为显存起始位置
	mov ah,03h			 ;黑底绿字
	dec byte [count]	 ;递减计数变量
	jnz end				 ;非0则跳转返回，4次中断和中断返回做一次切换
	mov byte[count],delay;恢复计数变量

	mov si,wheel		 
	add si,[offset]
	mov al,[si]			
	mov [gs:pos],ax		;打印
	
	
	call dword print_time;执行打印时间
	add byte[offset],1    
	cmp byte[offset], 4  
	jne end                 
	mov byte[offset], 0  



end:
	mov al,20h			;AL = EOI
	out 20h,al			;发送EOI到主8529A
	out 0A0h,al			;发送EOI到从8529A
	pop es
    pop si
    pop gs
    pop ds
    pop ax
	ret			;从中断返回


	delay equ 4		
	count db delay		
	wheel db '-\|/'          
	offset db 0
	pos equ ((80*24+79)*2)
