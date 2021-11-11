INCLUDE "globals.def"

SECTION rodata_user

PUBLIC _breakpoint
PUBLIC _wait_vblank
PUBLIC _set_border_color

NEXTREG_REGISTER_SELECT_PORT	= $243b
RASTER_LINE_MSB_REGISTER	= $1e
RASTER_LINE_LSB_REGISTER	= $1f

COLOR_BLACK 			= 0
COLOR_BLUE 			= 1
COLOR_RED 			= 2
COLOR_MAGENTA 			= 3
COLOR_GREEN 			= 4
COLOR_CYAN 			= 5
COLOR_YELLOW	 		= 6
COLOR_WHITE	 		= 7
P_BLACK				= 0
P_BLUE				= 1 << 3
P_RED				= 2 << 3
P_MAGENTA			= 3 << 3
P_GREEN				= 4 << 3
P_CYAN				= 5 << 3
P_YELLOW			= 6 << 3
P_WHITE				= 7 << 3
	
_breakpoint:
	DEFB $dd, $01
	ret

_wait_vblank:
	ld bc, NEXTREG_REGISTER_SELECT_PORT
	ld a, RASTER_LINE_MSB_REGISTER
	out (c), a
	inc b
_wait_vblank_loop1:
	in a, (c)
	and 1
	jp nz, _wait_vblank_loop1
	dec b
	ld a, RASTER_LINE_LSB_REGISTER
	out (c), a
	inc b
_wait_vblank_loop2:
	in a, (c)
	cp 192-64
	jp nz, _wait_vblank_loop2
	ret

_set_border_color:
	pop af
	pop bc

	push af
	push bc
	push de
	push hl
	push ix

	ld a, c
	out ($fe), a

	pop ix
	pop hl
	pop de
	pop bc
	pop af

	push bc
	push af
	ret
