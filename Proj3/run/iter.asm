; TEXT
segment	.text
; ALIGN
align	4
; GLOBL
global	$_factorial:function
; LABEL
$_factorial:
; ENTER
	push	ebp
	mov	ebp, esp
	sub	esp, 8
; IMM
	push	dword 1
; I2D
	fild	dword [esp]
	sub	esp, byte 4
	fstp	qword [esp]
; COPY2
	push	dword [esp+4]
	push	dword [esp+4]
; LOCAL
	lea	eax, [ebp+-8]
	push	eax
; STORE2
	pop	ecx
	pop	eax
	mov	[ecx], eax
	pop	eax
	mov	[ecx+4], eax
; TRASH
	add	esp, 8
; LOCAL
	lea	eax, [ebp+8]
	push	eax
; LOAD
	pop	eax
	push	dword [eax]
; IMM
	push	dword 0
; GT
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setg	cl
	mov	[esp], ecx
; JZ
	pop	eax
	cmp	eax, byte 0
	je	near $_i1
; LABEL
$_i2:
; LOCAL
	lea	eax, [ebp+-8]
	push	eax
; LOAD2
	pop	eax
	push	dword [eax+4]
	push	dword [eax]
; LOCAL
	lea	eax, [ebp+8]
	push	eax
; LOAD
	pop	eax
	push	dword [eax]
; I2D
	fild	dword [esp]
	sub	esp, byte 4
	fstp	qword [esp]
; DMUL
	fld	qword [esp]
	add	esp, byte 8
	fld	qword [esp]
	fmulp	st1
	fstp	qword [esp]
; COPY2
	push	dword [esp+4]
	push	dword [esp+4]
; LOCAL
	lea	eax, [ebp+-8]
	push	eax
; STORE2
	pop	ecx
	pop	eax
	mov	[ecx], eax
	pop	eax
	mov	[ecx+4], eax
; TRASH
	add	esp, 8
; LABEL
$_i4:
; LOCAL
	lea	eax, [ebp+8]
	push	eax
; COPY
	push	dword [esp]
; DECR
	pop	eax
	sub	dword [eax], 1
; LOAD
	pop	eax
	push	dword [eax]
; IMM
	push	dword 1
; GT
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setg	cl
	mov	[esp], ecx
; JNZ
	pop	eax
	cmp	eax, byte 0
	jne	near $_i2
; LABEL
$_i3:
; LABEL
$_i1:
; LOCAL
	lea	eax, [ebp+-8]
	push	eax
; LOAD2
	pop	eax
	push	dword [eax+4]
	push	dword [eax]
; DPOP
	fld	qword [esp]
	add	esp, byte 8
; LEAVE
	leave
; RET
	ret
