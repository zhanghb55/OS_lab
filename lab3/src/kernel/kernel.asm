
;
;  kernel.asm
;  Created by zhanghb on 2020/5/1.
;  Copyright © 2020 zhanghb. All rights reserved.
;
BITS 16


[extern shell]

global _start
_start:
    call dword shell ; 进入命令行界面
