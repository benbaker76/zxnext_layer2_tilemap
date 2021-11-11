INCLUDE "globals.def"

SECTION rodata_user

PUBLIC _layer2_tilemap_draw_column

_layer2_tilemap_draw_column:
	; layer2_tilemap_draw_column(uint8_t pixel_x, uint8_t tile_attribs, void *dst, void *src);
	; c = pixel_x
	; b = tile_attribs
	; de = dst
	; hl = src

IF USE_ASM_VERSION = 0
	pop af
	pop bc
	pop de
	pop hl

	push af
	push bc
	push de
	push hl
	push ix
ENDIF

	ld a, b
	and %00001110					; tile_attribs

IF SCREEN_RES = RES_256x192
	cp 0
	jp z, draw_column_rotate_x_mirror ; 4
	cp TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_column_rotate ; 5
	cp TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_column_rotate_y_mirror ; 7
	cp TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_column_rotate_xy_mirror ; 6
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_column_none ; 0
	cp TILEMAP_ATTRIBUTE_ROTATE
	jp z, draw_column_y_mirror ; 1
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_column_x_mirror ; 3
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_column_xy_mirror ; 2
ELIF SCREEN_RES = RES_320x256
	cp 0
	jp z, draw_column_none ; 0
	cp TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_column_y_mirror ; 1
	cp TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_column_xy_mirror ; 2
	cp TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_column_x_mirror ; 3
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_column_rotate_x_mirror ; 4
	cp TILEMAP_ATTRIBUTE_ROTATE
	jp z, draw_column_rotate ; 5
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_column_rotate_xy_mirror ; 6
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_column_rotate_y_mirror ; 7
ENDIF

draw_column_none:
	; tile_offset = (py << 3) + px; // 0
	ld a,c
	add a,l
	ld l,a
	ldi
	add hl,7
	ldi
	add hl,7
	ldi
	add hl,7
	ldi
	add hl,7
	ldi
	add hl,7
	ldi
	add hl,7
	ldi
	add hl,7
	ldi
	
IF USE_ASM_VERSION = 0
	pop ix
	pop hl
	pop de
	pop bc
	pop af

	push hl
	push de
	push bc
	push af
ENDIF

	ret

draw_column_y_mirror:
	; tile_offset = ((TILE_Y - py) << 3) + px - TILE_X; // 1
	ld a,c
	add a,l
	ld l,a
	ld a,e
	add a,7
	ld e,a
	ld a,(hl)
	ld (de),a
	dec e
	add hl,8
	ld a,(hl)
	ld (de),a
	dec e
	add hl,8
	ld a,(hl)
	ld (de),a
	dec e
	add hl,8
	ld a,(hl)
	ld (de),a
	dec e
	add hl,8
	ld a,(hl)
	ld (de),a
	dec e
	add hl,8
	ld a,(hl)
	ld (de),a
	dec e
	add hl,8
	ld a,(hl)
	ld (de),a
	dec e
	add hl,8
	ld a,(hl)
	ld (de),a

IF USE_ASM_VERSION = 0
	pop ix
	pop hl
	pop de
	pop bc
	pop af

	push hl
	push de
	push bc
	push af
ENDIF

	ret

draw_column_xy_mirror:
	; tile_offset = ((TILE_Y - py) << 3) - px - 1; // 2
	add hl,63
	ld a,l
	sub c
	ld l,a
	ldi
	add hl,-9
	ldi
	add hl,-9
	ldi
	add hl,-9
	ldi
	add hl,-9
	ldi
	add hl,-9
	ldi
	add hl,-9
	ldi
	add hl,-9
	ldi

IF USE_ASM_VERSION = 0
	pop ix
	pop hl
	pop de
	pop bc
	pop af

	push hl
	push de
	push bc
	push af
ENDIF

	ret

draw_column_x_mirror:
	; tile_offset = (py << 3) - px + (TILE_X - 1); // 3
	ld a,7
	sub c
	add a,l
	ld l,a
	ldi
	add hl,7
	ldi
	add hl,7
	ldi
	add hl,7
	ldi
	add hl,7
	ldi
	add hl,7
	ldi
	add hl,7
	ldi
	add hl,7
	ldi

IF USE_ASM_VERSION = 0
	pop ix
	pop hl
	pop de
	pop bc
	pop af

	push hl
	push de
	push bc
	push af
ENDIF

	ret

draw_column_rotate_x_mirror:
	; tile_offset = (px << 3) + py; // 4
	ld a,c
	rlca
	rlca
	rlca
	add a,l
	ld l,a

	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi

IF USE_ASM_VERSION = 0
	pop ix
	pop hl
	pop de
	pop bc
	pop af

	push hl
	push de
	push bc
	push af
ENDIF

	ret

draw_column_rotate:
	; tile_offset = ((TILE_X - px) << 3) + py - TILE_Y; // 5
	ld b,c
	ld a,7
	sub b
	rlca
	rlca
	rlca
	and %11111000
	add a,l
	ld l,a

	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi

IF USE_ASM_VERSION = 0
	pop ix
	pop hl
	pop de
	pop bc
	pop af

	push hl
	push de
	push bc
	push af
ENDIF

	ret

draw_column_rotate_xy_mirror:
	; tile_offset = (px << 3) - py + (TILE_Y - 1); // 6
	ld a,c
	rlca
	rlca
	rlca
	add a,l
	add 7
	ld l,a
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi
	
IF USE_ASM_VERSION = 0
	pop ix
	pop hl
	pop de
	pop bc
	pop af

	push hl
	push de
	push bc
	push af
ENDIF

	ret

draw_column_rotate_y_mirror:
	; tile_offset = ((TILE_X - px) << 3) - py - 1; // 7
	ld b,c
	ld a,8
	sub b
	rlca
	rlca
	rlca
	and %11111000
	add a,l
	dec a
	ld l,a
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi
	add hl,-2
	ldi

IF USE_ASM_VERSION = 0
	pop ix
	pop hl
	pop de
	pop bc
	pop af

	push hl
	push de
	push bc
	push af
ENDIF

	ret
