BITS 16

[extern kernel]
[extern Timer]
[extern write_8]
[extern write_20h]

global _start


%macro MOVE_INT_VECTOR 2        ; 将参数1的中断向量转移至参数2处
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

_start:
    call write_20h
    MOVE_INT_VECTOR 08h, 34h
    call dword write_8

Enter_kernel:   ;当从中断返回的时候，因为IP是call dword kernel的下一条指令，所以需要重新进入内核
    call dword kernel           
    jmp Enter_kernel                
