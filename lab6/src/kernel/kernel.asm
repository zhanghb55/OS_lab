BITS 16
%include"Macro.asm"

[extern kernel]
[extern Timer]
[extern write_8]
[extern write_20h]
[extern int_30h]

global _start


_start:
    Modify_Vector 30h,int_30h
    call write_20h
    Replace_Vector 08h, 34h
    call dword write_8

Enter_kernel:   ;当从中断返回的时候，因为IP是call dword kernel的下一条指令，所以需要重新进入内核
    call dword kernel           
    jmp Enter_kernel                
