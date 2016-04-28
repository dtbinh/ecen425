YKIdleTask:
	
		push		bp
		mov		bp, sp

yak_loop:
		inc		word [YKIdleCount]		
		jmp		yak_loop

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

YKEnterMutex:

		cli
		ret

YKExitMutex:
		
		sti
		ret
