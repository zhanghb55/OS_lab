%include"Macro.asm"

struc user_info
		.name:	    resb	16
		.size:	    resw	1
		.cylinder:	resb    1
        .head:      resb    1
        .sector:    resb    1
        .segment    resw    1
        .addr:      resw    1
endstruc

count_of_program db 5

user1:
istruc user_info		
	at	user_info.name,	    db		'a'
	at	user_info.size, 	dw		1024
	at	user_info.cylinder,	db		1
    at	user_info.head,	    db		1
    at	user_info.sector,	db		1
    at	user_info.segment, 	dw		offset_user1 >> 4 & 0F000h
    at	user_info.addr, 	dw		offset_user1 & 0FFFFh
iend

user2:
istruc user_info		
	at	user_info.name,	    db		'b'
	at	user_info.size, 	dw		1024
	at	user_info.cylinder,	db		1
    at	user_info.head,	    db		1
    at	user_info.sector,	db		3
    at	user_info.segment, 	dw		offset_user2 >> 4 & 0F000h
    at	user_info.addr, 	dw		offset_user2 & 0FFFFh
iend

user3:
istruc user_info		
	at	user_info.name,	    db		'c'
	at	user_info.size, 	dw		1024
	at	user_info.cylinder,	db		1
    at	user_info.head,	    db		1
    at	user_info.sector,	db		5
    at	user_info.segment, 	dw		offset_user3 >> 4 & 0F000h
    at	user_info.addr, 	dw		offset_user3 & 0FFFFh
iend

user4:
istruc user_info		
	at	user_info.name,	    db		'd'
	at	user_info.size, 	dw		1024
	at	user_info.cylinder,	db		1
    at	user_info.head,	    db		1
    at	user_info.sector,	db		7
    at	user_info.segment, 	dw		offset_user4 >> 4 & 0F000h
    at	user_info.addr, 	dw		offset_user4 & 0FFFFh
iend
user5:
istruc user_info		
	at	user_info.name,	    db		'e'
	at	user_info.size, 	dw		2048
	at	user_info.cylinder,	db		1
    at	user_info.head,	    db		1
    at	user_info.sector,	db		9
    at	user_info.segment, 	dw		offset_user5 >> 4 & 0F000h
    at	user_info.addr, 	dw		offset_user5 & 0FFFFh
iend

    times 512-($-$$) db 0
