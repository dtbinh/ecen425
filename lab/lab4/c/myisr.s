reset:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds
	
	sti
	call reset_handler
	cli

	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)
	
	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	iret

tick:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds
	
	
	sti
	call tick_handler
	call YKTickHandler
	cli	
	
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)
		
	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	iret
	
keyboard:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds
	
	sti
	call keyboard_handler
	cli	
	
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)	
	
	
	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	iret
	
YKDispatcher:

		cli
		push 	bp
		mov		bp, sp		

		mov		bx, [bp+4]	;Obtain stack pointer from TCB
		mov		sp, [bx+4]	;Load stack pointer into SP

		pop		bp
		pop		es
		pop		ds
		pop		si
		pop		di
		pop		dx
		pop		cx
		pop		bx
		pop		ax

		iret

