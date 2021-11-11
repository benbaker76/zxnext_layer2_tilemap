INCLUDE "globals.def"

SECTION rodata_user

PUBLIC _layer2_tilemap_draw_row

_layer2_tilemap_draw_row:
	; layer2_tilemap_draw_row(uint8_t pixel_y, uint8_t tile_attribs, void *dst, void *src);
	; c = pixel_y
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
	jp z, draw_row_rotate_x_mirror ; 4
	cp TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_row_rotate ; 5
	cp TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_row_rotate_y_mirror ; 7
	cp TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_row_rotate_xy_mirror ; 6
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_row_none ; 0
	cp TILEMAP_ATTRIBUTE_ROTATE
	jp z, draw_row_y_mirror ; 1
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_row_x_mirror ; 3
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_row_xy_mirror ; 2
ELIF SCREEN_RES = RES_320x256
	cp 0
	jp z, draw_row_none ; 0
	cp TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_row_y_mirror ; 1
	cp TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_row_xy_mirror ; 2
	cp TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_row_x_mirror ; 3
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_row_rotate_x_mirror ; 4
	cp TILEMAP_ATTRIBUTE_ROTATE
	jp z, draw_row_rotate ; 5
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_row_rotate_xy_mirror ; 6
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_row_rotate_y_mirror ; 7
ENDIF

draw_row_none:
	; tile_offset = (py << 3) + px; // 0
	ld a,c
	rlca
	rlca
	rlca
	add a,l
	ld l,a
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws

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

draw_row_y_mirror:
	; tile_offset = ((TILE_Y - py) << 3) + px - TILE_X; // 1
	ld a,8
	sub c
	rlca
	rlca
	rlca
	add a,l
	sub 8
	ld l,a
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws

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

draw_row_xy_mirror:
	; tile_offset = ((TILE_Y - py) << 3) - px - 1; // 2
	ld a,8
	sub c
	rlca
	rlca
	rlca
	add a,l
	sub 1
	ld l,a
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws

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

draw_row_x_mirror:
	; tile_offset = (py << 3) - px + (TILE_X - 1); // 3
	ld a,c
	rlca
	rlca
	rlca
	add a,l
	add 7
	ld l,a
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws
	add hl,-2
	ldws

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

draw_row_rotate_x_mirror:
	; tile_offset = (px << 3) + py; // 4
	ld a,c
	add a,l
	ld l,a
	ldws
	add hl,7
	ldws
	add hl,7
	ldws
	add hl,7
	ldws
	add hl,7
	ldws
	add hl,7
	ldws
	add hl,7
	ldws
	add hl,7
	ldws

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

draw_row_rotate:
	; tile_offset = ((TILE_X - px) << 3) + py - TILE_Y; // 5
	ld a,c
	add a,l
	ld l,a
	ld a,d
	add a,7
	ld d,a
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
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

draw_row_rotate_xy_mirror:
	; tile_offset = (px << 3) - py + (TILE_Y - 1); // 6
	ld a,7
	sub c
	add a,l
	ld l,a
	ldws
	add hl,7
	ldws
	add hl,7
	ldws
	add hl,7
	ldws
	add hl,7
	ldws
	add hl,7
	ldws
	add hl,7
	ldws
	add hl,7
	ldws

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

draw_row_rotate_y_mirror:
	; tile_offset = ((TILE_X - px) << 3) - py - 1; // 7
	ld a,7
	sub c
	add a,l
	ld l,a
	ld a,d
	add a,7
	ld d,a
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
	add hl,8
	ld a,(hl)
	ld (de),a
	dec d
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
