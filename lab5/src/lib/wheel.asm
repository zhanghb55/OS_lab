%include "Macro.asm"

BITS 16
[global Timer]
[extern print_time]

state:register                         ;定义寄存器状态

Timer:                             ; 08h号时钟中断处理程序
    Save state            
    add sp, 16+2                   ; 丢弃参数

    call Wheel               		; 进程调度

    Restart state
QuitTimer:
    push ax
    mov al, 20h
    out 20h, al
    out 0A0h, al
    pop ax
    iret

Wheel:
	push ax
	push ds
	push gs
	push si
	mov ax,cs
	mov ds,ax              
	mov	ax,0B800h		
	mov	gs,ax			 ;gs置为显存起始位置
	mov ah,03h			 ;黑底绿字
	dec byte [count]	 ;递减计数变量
	jnz end				 ;非0则跳转返回，4次中断和中断返回做一次切换
	mov byte[count],delay;恢复计数变量

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
	mov al,20h			; AL = EOI
	out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A

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
