RESET:

		push 	ax
		push 	bx
		push 	cx
		push 	dx
		push 	di
		push 	si
		push 	ds
		push 	es
		push 	bp
		mov		si, [currentTask]
		add		si, word 0x4
		mov 		[si], sp

		call		YKEnterISR
		
		sti					;enabling interrupts
		call 	resetHandler	;calling C interrupt handler
		cli					;disabling interrupts
		
		mov		al, 0x20		;Load nonspecific EOI value (0x20) into register al
		out		0x20, al		;Write EOI to PIC (port 0x20)

		call 	YKExitISR

		pop		bp
		pop		es
		pop		ds
		pop		si
		pop		di
		pop		dx
		pop		cx
		pop		bx
		pop		ax	

		iret					;returning from ISR

TICK:

		push 	ax
		push 	bx
		push 	cx
		push 	dx
		push 	di
		push 	si
		push 	ds
		push 	es
		push 	bp
		mov		si, [currentTask]
		add		si, word 0x4
		mov 		[si], sp

		call	YKEnterISR

		sti					;enabling interrupts
		call	tickHandler		;calling C interrupt handler
		cli					;disabling interrupts

		mov 	al, 0x20			;Load nonspecific EOI value (0x20) into register al
		out		0x20, al		;Write EOI to PIC (port 0x20)

		call	YKExitISR

		pop		bp
		pop		es
		pop		ds
		pop		si
		pop		di
		pop		dx
		pop		cx
		pop		bx
		pop		ax

		iret					;returning from ISR

KEYBOARD:

		push 	ax
		push 	bx
		push 	cx
		push 	dx
		push 	di
		push 	si
		push 	ds
		push 	es
		push 	bp
		mov		si, [currentTask]
		add		si, word 0x4
		mov 		[si], sp	
		
		call	YKEnterISR
		
		sti						;enabling interrupts
		call	keyboardHandler ;calling C interrupt handler
		cli						;disabling interrupts

		mov     al, 0x20		;Load nonspecific EOI value (0x20) into register al
		out		0x20, al		;Write EOI to PIC (port 0x20)

		call	YKExitISR

		pop		bp
		pop		es
		pop		ds
		pop		si
		pop		di
		pop		dx
		pop		cx
		pop		bx
		pop		ax

		iret					;returning from ISR

TRAP:

		push 	ax
		push 	bx
		push 	cx
		push 	dx
		push 	di
		push 	si
		push 	ds
		push 	es
		push 	bp
		mov		si, [currentTask]
		add		si, word 0x4
		mov 		[si], sp

		call 	YKEnterISR

		mov 		al, 0x20
		out		0x20, al

		call		YKExitISR

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

