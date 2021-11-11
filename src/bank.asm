INCLUDE "globals.def"

SECTION rodata_user

PUBLIC _zxn_addr_from_mmu
PUBLIC _zxn_page_from_mmu
PUBLIC _asm_bank_set_8k
PUBLIC _asm_bank_set_16k

_zxn_addr_from_mmu:
	; return start address of mmu slot
	; enter : l = mmu 0-7
	; exit  : hl = address
	; uses  : af, hl

	ld a,l
	rrca
	rrca
	rrca
	and $e0
	ld h,a
	ld l,0
	ret

_zxn_page_from_mmu:
	; enter : l = mmu 0-7
	; exit  : l = page

	ld	a,$50
	add	a,l
	ld	d,a
	ld	l,d
	ld	bc,IO_NEXTREG_REG
	out	(c),l
	inc	b
	in	l,(c)
	srl	l
	ret

	; enter : h = mmu 0-7
	;       : l = page
_asm_bank_set_8k:
	; mmu += $50
	ld	a,$50
	add	a,h
	ld	h,a
	; page <<= 1
	ld	a,l
	rl	a
	ld	l,a
	ld	bc,IO_NEXTREG_REG
	out	(c),h
	inc	b
	out	(c),l
	ret

	; enter : h = mmu 0-7
	;       : l = page
_asm_bank_set_16k:
	; mmu += $50
	ld	a,$50
	add	a,h
	ld	h,a
	; page <<= 1
	ld	a,l
	rl	a
	ld	l,a
	ld	bc,IO_NEXTREG_REG
	out	(c),h
	inc	b
	out	(c),l
	; mmu += 1 page += 1
	ld	a,h
	inc	a
	ld	h,a
	ld	a,l
	inc	a
	ld	l,a
	ld	bc,IO_NEXTREG_REG
	out	(c),h
	inc	b
	out	(c),l
	ret
