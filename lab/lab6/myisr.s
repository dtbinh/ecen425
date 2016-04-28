RESET:

		call 	resetHandler	;calling C interrupt handler


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
		call		YKGetISRCallDepth
		test		ax, ax
		jnz		tick_1
		mov		si, [currentTask]
		add		si, word 0x4
		mov 		[si], sp

tick_1:
		call	YKEnterISR

		sti					;enabling interrupts
		call	tickHandler		;calling C interrupt handler
		cli					;disabling interrupts

		mov 		al, 0x20			;Load nonspecific EOI value (0x20) into register al
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
		call		YKGetISRCallDepth
		test		ax, ax
		jnz		keyboard_1
		mov		si, [currentTask]
		add		si, word 0x4
		mov 		[si], sp	

keyboard_1:		
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

		call 	YKScheduler

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

