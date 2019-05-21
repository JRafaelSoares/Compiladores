; BSS
segment	.bss
; ALIGN
align	4
; LABEL
$a:
; BYTE
	resb	16
; DATA
segment	.data
; ALIGN
align	4
; LABEL
$b:
; INTEGER
	dd	1
; DATA
segment	.data
; ALIGN
align	4
; LABEL
$c:
; ID
	dd	$_i1
; DATA
segment	.data
; ALIGN
align	4
; LABEL
$_i1:
; CHAR
	db	0x6F
; CHAR
	db	0x6C
; CHAR
	db	0x61
; CHAR
	db	0x00
; DATA
segment	.data
; ALIGN
align	4
; LABEL
$d:
; ID
	dd	$_i2
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL
$_i2:
; CHAR
	db	0x61
; CHAR
	db	0x64
; CHAR
	db	0x65
; CHAR
	db	0x75
; CHAR
	db	0x73
; CHAR
	db	0x00
; DATA
segment	.data
; ALIGN
align	4
; LABEL
$h:
; ID
	dd	$a
; DATA
segment	.data
; ALIGN
align	4
; LABEL
$i:
; ID
	dd	$c
; BSS
segment	.bss
; ALIGN
align	4
; LABEL
$j:
; BYTE
	resb	16
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
	push	dword 0
; ADDR
	push	dword $a
; STORE
	pop	ecx
	pop	eax
	mov	[ecx], eax
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL
$_i3:
; CHAR
	db	0x6F
; CHAR
	db	0x75
; CHAR
	db	0x74
; CHAR
	db	0x00
; TEXT
segment	.text
; ADDR
	push	dword $_i3
; ADDR
	push	dword $j
; STORE
	pop	ecx
	pop	eax
	mov	[ecx], eax
; ADDR
	push	dword $a
; LOAD
	pop	eax
	push	dword [eax]
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; ADDR
	push	dword $b
; LOAD
	pop	eax
	push	dword [eax]
; CALL
	call	$_printi
; TRASH
	add	esp, -4
; ADDR
	push	dword $c
; LOAD
	pop	eax
	push	dword [eax]
; CALL
	call	$_prints
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
; ADDR
	push	dword $d
; LOAD
	pop	eax
	push	dword [eax]
; CALL
	call	$_prints
; TRASH
	add	esp, -4
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL
$_i5:
; CHAR
	db	0x20
; CHAR
	db	0x00
; TEXT
segment	.text
; ADDR
	push	dword $_i5
; CALL
	call	$_prints
; TRASH
	add	esp, -4
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL
$_i6:
; CHAR
	db	0x20
; CHAR
	db	0x00
; TEXT
segment	.text
; ADDR
	push	dword $_i6
; CALL
	call	$_prints
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
; ADDR
	push	dword $h
; LOAD
	pop	eax
	push	dword [eax]
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
$_i8:
; CHAR
	db	0x20
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
; ADDR
	push	dword $i
; LOAD
	pop	eax
	push	dword [eax]
; LOAD
	pop	eax
	push	dword [eax]
; CALL
	call	$_prints
; TRASH
	add	esp, -4
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL
$_i9:
; CHAR
	db	0x20
; CHAR
	db	0x00
; TEXT
segment	.text
; ADDR
	push	dword $_i9
; CALL
	call	$_prints
; TRASH
	add	esp, -4
; ADDR
	push	dword $j
; LOAD
	pop	eax
	push	dword [eax]
; CALL
	call	$_prints
; TRASH
	add	esp, -4
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL
$_i10:
; CHAR
	db	0x0A
; CHAR
	db	0x30
; CHAR
	db	0x31
; CHAR
	db	0x6F
; CHAR
	db	0x6C
; CHAR
	db	0x61
; CHAR
	db	0x20
; CHAR
	db	0x61
; CHAR
	db	0x64
; CHAR
	db	0x65
; CHAR
	db	0x75
; CHAR
	db	0x73
; CHAR
	db	0x34
; CHAR
	db	0x2E
; CHAR
	db	0x31
; CHAR
	db	0x20
; CHAR
	db	0x31
; CHAR
	db	0x2E
; CHAR
	db	0x32
; CHAR
	db	0x20
; CHAR
	db	0x34
; CHAR
	db	0x2E
; CHAR
	db	0x31
; CHAR
	db	0x20
; CHAR
	db	0x30
; CHAR
	db	0x20
; CHAR
	db	0x6F
; CHAR
	db	0x6C
; CHAR
	db	0x61
; CHAR
	db	0x20
; CHAR
	db	0x6F
; CHAR
	db	0x75
; CHAR
	db	0x74
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
	push	dword $_i10
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
