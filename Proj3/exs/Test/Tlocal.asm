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
	sub	esp, 8
; IMM
	push	dword 4
; LOCAL
	lea	eax, [ebp+-4]
	push	eax
; STORE
	pop	ecx
	pop	eax
	mov	[ecx], eax
; IMM
	push	dword 1
; LOCAL
	lea	eax, [ebp+8]
	push	eax
; STORE
	pop	ecx
	pop	eax
	mov	[ecx], eax
; LOCAL
	lea	eax, [ebp+8]
	push	eax
; LOAD
	pop	eax
	push	dword [eax]
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; LOCAL
	lea	eax, [ebp+-4]
	push	eax
; LOAD
	pop	eax
	push	dword [eax]
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
	db	0x0A
; CHAR
	db	0x31
; CHAR
	db	0x34
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
	push	dword $_i1
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
; EXTRN
extern	$_printd
