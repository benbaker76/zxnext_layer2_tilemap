INCLUDE "globals.def"

SECTION rodata_user

PUBLIC _layer2_tilemap_draw_tile

_layer2_tilemap_draw_tile:
	; layer2_tilemap_draw_tile(uint8_t tile_id, uint8_t tile_attribs, void *dst, void *src);
	; c = tile_id
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
	jp z, draw_tile_rotate_x_mirror ; 4
	cp TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_tile_rotate ; 5
	cp TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_tile_rotate_y_mirror ; 7
	cp TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_tile_rotate_xy_mirror ; 6
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_tile_none ; 0
	cp TILEMAP_ATTRIBUTE_ROTATE
	jp z, draw_tile_y_mirror ; 1
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_tile_x_mirror ; 3
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_tile_xy_mirror ; 2
ELIF SCREEN_RES = RES_320x256
	cp 0
	jp z, draw_tile_none ; 0
	cp TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_tile_y_mirror ; 1
	cp TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_tile_xy_mirror ; 2
	cp TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_tile_x_mirror ; 3
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR
	jp z, draw_tile_rotate_x_mirror ; 4
	cp TILEMAP_ATTRIBUTE_ROTATE
	jp z, draw_tile_rotate ; 5
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_tile_rotate_xy_mirror ; 6
	cp TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp z, draw_tile_rotate_y_mirror ; 7
ENDIF
	
draw_tile_none:
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f801
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f801
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f801
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f801
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f801
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f801
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f801
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

draw_tile_y_mirror:
	; so, still drawing down, but starting with the bottom byte and working up
	; so, e = y
	ld a, e
	add a, 7
	ld e, a
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f7ff
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f7ff
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f7ff
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f7ff
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f7ff
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f7ff
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	ldws
	add de, $f7ff
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

draw_tile_xy_mirror:
	; e = x movement
	add hl, 63
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	dec hl
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	dec hl
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	dec hl
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	dec hl
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	dec hl
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	dec hl
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	dec hl
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	dec hl

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

draw_tile_x_mirror:
	add hl, 7
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	add hl, 15
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	add hl, 15
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	add hl, 15
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	add hl, 15
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	add hl, 15
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	add hl, 15
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	add hl, 15
	add de, $f901
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a
	inc d
	dec hl
	ld a, (hl)
	ld (de), a

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

draw_tile_rotate_x_mirror:
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $00f8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $00f8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $00f8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $00f8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $00f8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $00f8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $00f8
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

draw_tile_rotate:
	ld a, d
	add a, 7
	ld d, a
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $fef8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $fef8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $fef8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $fef8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $fef8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $fef8
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	add de, $fef8
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

draw_tile_rotate_xy_mirror:
	ld a, e
	add a, 7
	ld e, a
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $0107
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $0107
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $0107
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $0107
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $0107
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $0107
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $0107
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl

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

draw_tile_rotate_y_mirror:
	add de, $0707
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $ff07
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $ff07
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $ff07
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $ff07
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $ff07
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $ff07
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl
	add de, $ff07
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	dec e
	inc hl
	ld a, (hl)
	ld (de), a
	inc hl

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
