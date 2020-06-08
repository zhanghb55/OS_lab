%include"Macro.asm"

struc user_info
		.name:	    resb	16
		.size:	    resw	1
		.cylinder:	resb    1
        .head:      resb    1
        .sector:    resb    1
        .addr:      resw    1
endstruc

count_of_program db 4

user1:
istruc user_info		
	at	user_info.name,	    db		'a'
	at	user_info.size, 	dw		1024
	at	user_info.cylinder,	db		1
    at	user_info.head,	    db		0
    at	user_info.sector,	db		1
    at	user_info.addr, 	dw		offset_user1
iend

user2:
istruc user_info		
	at	user_info.name,	    db		'b'
	at	user_info.size, 	dw		1024
	at	user_info.cylinder,	db		1
    at	user_info.head,	    db		0
    at	user_info.sector,	db		3
    at	user_info.addr, 	dw		offset_user2
iend

user3:
istruc user_info		
	at	user_info.name,	    db		'c'
	at	user_info.size, 	dw		1024
	at	user_info.cylinder,	db		1
    at	user_info.head,	    db		0
    at	user_info.sector,	db		5
    at	user_info.addr, 	dw		offset_user3
iend

user4:
istruc user_info		
	at	user_info.name,	    db		'd'
	at	user_info.size, 	dw		1024
	at	user_info.cylinder,	db		1
    at	user_info.head,	    db		0
    at	user_info.sector,	db		7
    at	user_info.addr, 	dw		offset_user4
iend

    times 512-($-$$) db 0
