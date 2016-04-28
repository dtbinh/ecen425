; Modify AsmFunction to perform the calculation gvar+(a*(b+c))/(d-e).
; Keep in mind the C declaration:
; int AsmFunction(int a, char b, char c, int d, int e);

	CPU	8086
	align	2

AsmFunction:
	push 	bp
	mov 	bp, sp
	mov		al, byte[bp+6]
	cbw	
	mov		cx, ax
	mov		al, byte[bp+8]
	cbw
	add		ax, cx	
	imul	word[bp+4]
	mov		bx, word[bp+10]
	sub		bx, word[bp+12]
	idiv	bx	
	add		ax, [gvar]
	mov 	sp, bp
	pop		bp
	ret
