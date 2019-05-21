; TEXT
segment	.text
; ALIGN
align	4
; GLOBL
global	$_entry:function
; LABEL
$_entry:
; ENTER
	push	ebp
	mov	ebp, esp
	sub	esp, 4
; IMM
	push	dword 1
; IMM
	push	dword 3
; ADD
	pop	eax
	add	dword [esp], eax
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 3
; IMM
	push	dword 1
; SUB
	pop	eax
	sub	dword [esp], eax
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 2
; IMM
	push	dword 3
; MUL
	pop	eax
	imul	dword eax, [esp]
	mov	[esp], eax
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 4
; IMM
	push	dword 2
; DIV
	pop	ecx
	pop	eax
	cdq
	idiv	ecx
	push	eax
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 3
; IMM
	push	dword 2
; MOD
	pop	ecx
	pop	eax
	cdq
	idiv	ecx
	push	edx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 2
; NEG
	neg	dword [esp]
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL
$_i1:
; CHAR
	db	0x20
; CHAR
	db	0x00
; TEXT
segment	.text
; ADDR
	push	dword $_i1
; CALL
	call	$_prints
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; IMM
	push	dword 3
; LT
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setl	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; IMM
	push	dword 3
; GT
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setg	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; IMM
	push	dword 3
; EQ
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	sete	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; IMM
	push	dword 1
; EQ
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	sete	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; COPY
	push	dword [esp]
; JZ
	pop	eax
	cmp	eax, byte 0
	je	near $_i2
; TRASH
	add	esp, 4
; IMM
	push	dword 3
; IMM
	push	dword 0
; GT
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setg	cl
	mov	[esp], ecx
; LABEL
$_i2:
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; COPY
	push	dword [esp]
; JZ
	pop	eax
	cmp	eax, byte 0
	je	near $_i3
; TRASH
	add	esp, 4
; IMM
	push	dword 0
; IMM
	push	dword 0
; GT
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setg	cl
	mov	[esp], ecx
; LABEL
$_i3:
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL
$_i4:
; CHAR
	db	0x20
; CHAR
	db	0x00
; TEXT
segment	.text
; ADDR
	push	dword $_i4
; CALL
	call	$_prints
; TRASH
	add	esp, -4
; IMM
	push	dword 0
; COPY
	push	dword [esp]
; JNZ
	pop	eax
	cmp	eax, byte 0
	jne	near $_i5
; TRASH
	add	esp, 4
; IMM
	push	dword 0
; LABEL
$_i5:
; IMM
	push	dword 0
; GT
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setg	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; COPY
	push	dword [esp]
; JNZ
	pop	eax
	cmp	eax, byte 0
	jne	near $_i6
; TRASH
	add	esp, 4
; IMM
	push	dword 0
; LABEL
$_i6:
; IMM
	push	dword 0
; GT
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setg	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; IMM
	push	dword 1
; GE
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setge	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; IMM
	push	dword 2
; GE
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setge	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; IMM
	push	dword 0
; LE
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setle	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; IMM
	push	dword 1
; LE
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setle	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL
$_i7:
; CHAR
	db	0x20
; CHAR
	db	0x00
; TEXT
segment	.text
; ADDR
	push	dword $_i7
; CALL
	call	$_prints
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; IMM
	push	dword 0
; NE
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setne	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; IMM
	push	dword 1
; NE
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setne	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 1
; IMM
	push	dword 0
; EQ
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	sete	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; IMM
	push	dword 0
; IMM
	push	dword 0
; EQ
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	sete	cl
	mov	[esp], ecx
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL
$_i8:
; CHAR
	db	0x0A
; CHAR
	db	0x34
; CHAR
	db	0x32
; CHAR
	db	0x36
; CHAR
	db	0x32
; CHAR
	db	0x31
; CHAR
	db	0x2D
; CHAR
	db	0x32
; CHAR
	db	0x20
; CHAR
	db	0x31
; CHAR
	db	0x30
; CHAR
	db	0x30
; CHAR
	db	0x31
; CHAR
	db	0x31
; CHAR
	db	0x30
; CHAR
	db	0x20
; CHAR
	db	0x30
; CHAR
	db	0x31
; CHAR
	db	0x31
; CHAR
	db	0x30
; CHAR
	db	0x30
; CHAR
	db	0x31
; CHAR
	db	0x20
; CHAR
	db	0x31
; CHAR
	db	0x30
; CHAR
	db	0x30
; CHAR
	db	0x31
; CHAR
	db	0x20
; CHAR
	db	0x3C
; CHAR
	db	0x2D
; CHAR
	db	0x20
; CHAR
	db	0x65
; CHAR
	db	0x78
; CHAR
	db	0x70
; CHAR
	db	0x65
; CHAR
	db	0x63
; CHAR
	db	0x74
; CHAR
	db	0x65
; CHAR
	db	0x64
; CHAR
	db	0x0A
; CHAR
	db	0x00
; TEXT
segment	.text
; ADDR
	push	dword $_i8
; CALL
	call	$_prints
; TRASH
	add	esp, -4
; LEAVE
	leave
; RET
	ret
; EXTRN
extern	$_prints
; EXTRN
extern	$_printi
