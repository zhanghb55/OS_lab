BITS 16
%include "Macro.asm"
[extern main]

global _start


_start:
    Replace_Vector 34h, 08h
    call dword main  
    int 20h
