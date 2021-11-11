INCLUDE "globals.def"

SECTION rodata_user

PUBLIC _l2_offset_x
PUBLIC _l2_offset_y
PUBLIC _l2_offset_tile_x
PUBLIC _l2_offset_tile_y
PUBLIC _l2_offset_pixel_x
PUBLIC _l2_offset_pixel_y
PUBLIC _l2_map_data
PUBLIC _l2_map_tiles_x
PUBLIC _l2_map_tiles_y
PUBLIC _l2_map_offset_x
PUBLIC _l2_map_offset_y
PUBLIC _l2_map_offset
PUBLIC _l2_map_index
PUBLIC _l2_screen_tile_x
PUBLIC _l2_screen_tile_y
PUBLIC _l2_screen_x
PUBLIC _l2_screen_y
PUBLIC _l2_screen_bank
PUBLIC _l2_screen_start_page
PUBLIC _l2_screen_page
PUBLIC _l2_screen_index_x
PUBLIC _l2_screen_index_y
PUBLIC _l2_map_address
PUBLIC _l2_tiles_address
PUBLIC _l2_screen_address
PUBLIC _l2_tile_pixel_x
PUBLIC _l2_tile_pixel_y
PUBLIC _l2_tile_x
PUBLIC _l2_tile_y
PUBLIC _l2_tile_data
PUBLIC _l2_tile_id
PUBLIC _l2_tile_page
PUBLIC _l2_tile_attribs
PUBLIC _l2_tile_index
PUBLIC _l2_tile_offset

_l2_offset_x:
	dw $0000
_l2_offset_y:
	dw $0000
_l2_offset_tile_x:
	db $00
_l2_offset_tile_y:
	db $00
_l2_offset_pixel_x:
	dw $0000
_l2_offset_pixel_y:
	dw $0000
_l2_map_data:
	dw $0000
_l2_map_tiles_x:
	db $00
_l2_map_tiles_y:
	db $00
_l2_map_offset_x:
	dw $0000
_l2_map_offset_y:
	dw $0000
_l2_map_offset:
	dw $0000
_l2_map_index:
	dw $0000
_l2_screen_tile_x:
	dw $0000
_l2_screen_tile_y:
	dw $0000
_l2_screen_x:
	dw $0000
_l2_screen_y:
	dw 00000
_l2_screen_bank:
	db $00
_l2_screen_start_page:
	db PAGE_LAYER2
_l2_screen_page:
	db $00
_l2_screen_index_x:
	dw $0000
_l2_screen_index_y:
	db $00
_l2_map_address:
	dw $0000
_l2_tiles_address:
	dw $0000
_l2_screen_address:
	dw $0000
_l2_tile_pixel_x:
	db $00
_l2_tile_pixel_y:
	db $00
_l2_tile_x:
	db $00
_l2_tile_y:
	db $00
_l2_tile_data:
	dw $0000
_l2_tile_id:
	db $00
_l2_tile_page:
	db $00
_l2_tile_attribs:
	db $00
_l2_tile_index:
	dw $0000
_l2_tile_offset:
	dw $0000

IF USE_ASM_VERSION = 1

PUBLIC _layer2_tile_get_offset
PUBLIC _layer2_tilemap_update_column
PUBLIC _layer2_tilemap_update_row
PUBLIC _layer2_tilemap_update
PUBLIC _layer2_tilemap_scroll_update
PUBLIC _layer2_tilemap_scroll_left
PUBLIC _layer2_tilemap_scroll_right
PUBLIC _layer2_tilemap_scroll_up
PUBLIC _layer2_tilemap_scroll_down

EXTERN _layer2_tilemap_draw_tile
EXTERN _layer2_tilemap_draw_column
EXTERN _layer2_tilemap_draw_row
EXTERN _mod320
EXTERN _mod192
EXTERN _asm_bank_set_8k
EXTERN _asm_bank_set_16k
EXTERN _bank_set_16k
EXTERN _zxn_addr_from_mmu
EXTERN _zxn_addr_from_mmu_fastcall

; ---------------------------------
; layer2_tile_get_offset
; ---------------------------------
IF SCREEN_RES = RES_256x192
_layer2_tile_get_offset_flip:
ELIF SCREEN_RES = RES_320x256
_layer2_tile_get_offset:
ENDIF
	ld	hl,(_l2_tile_pixel_x)
	ld	a,(_l2_tile_attribs)
	or	a

	jp	z,layer2_tile_get_offset_none ; 0
	cp	TILEMAP_ATTRIBUTE_Y_MIRROR
	jp	z,layer2_tile_get_l2_offset_y_mirror ; 1
	cp	TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp	z,layer2_tile_get_l2_offset_xy_mirror ; 2
	cp	TILEMAP_ATTRIBUTE_X_MIRROR
	jp	z,layer2_tile_get_l2_offset_x_mirror ; 3
	cp	TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR
	jp	z,layer2_tile_get_offset_rotate_x_mirror ; 4
	cp	TILEMAP_ATTRIBUTE_ROTATE
	jp	z,layer2_tile_get_offset_rotate ; 5
	cp	TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp	z,layer2_tile_get_offset_rotate_xy_mirror ; 6
	cp	TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp	z,layer2_tile_get_offset_rotate_y_mirror ; 7

IF SCREEN_RES = RES_256x192
_layer2_tile_get_offset:
ELIF SCREEN_RES = RES_320x256
_layer2_tile_get_offset_flip:
ENDIF
	ld	hl,(_l2_tile_pixel_x)
	ld	a,(_l2_tile_attribs)
	or	a

	jp	z,layer2_tile_get_offset_rotate_x_mirror ; 4
	cp	TILEMAP_ATTRIBUTE_Y_MIRROR
	jp	z,layer2_tile_get_offset_rotate ; 5
	cp	TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp	z,layer2_tile_get_offset_rotate_y_mirror ; 7
	cp	TILEMAP_ATTRIBUTE_X_MIRROR
	jp	z,layer2_tile_get_offset_rotate_xy_mirror ; 6
	cp	TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR
	jp	z,layer2_tile_get_offset_none ; 0
	cp	TILEMAP_ATTRIBUTE_ROTATE
	jp	z,layer2_tile_get_l2_offset_y_mirror ; 1
	cp	TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp	z,layer2_tile_get_l2_offset_x_mirror ; 3
	cp	TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_Y_MIRROR
	jp	z,layer2_tile_get_l2_offset_xy_mirror ; 2

layer2_tile_get_offset_none:
	; tile_offset = (py << 3) + px; // 0
	ld	a,h
	add	a
	add	a
	add	a
	add	a,l
	ld	(_l2_tile_offset),a
	ret
layer2_tile_get_l2_offset_y_mirror:
	; tile_offset = ((TILE_Y - py) << 3) + px - TILE_X; // 1
	ld	a,TILE_Y
	sub	h
	add	a
	add	a
	add	a
	add	a,l
	sub	TILE_X
	ld	(_l2_tile_offset),a
	ret
layer2_tile_get_l2_offset_xy_mirror:
	; tile_offset = ((TILE_Y - py) << 3) - px - 1; // 2
	ld	a,TILE_Y
	sub	h
	add	a
	add	a
	add	a
	sub	l
	dec	a
	ld	(_l2_tile_offset),a
	ret
layer2_tile_get_l2_offset_x_mirror:
	; tile_offset = (py << 3) - px + (TILE_X - 1); // 3
	ld	a,h
	add	a
	add	a
	add	a
	sub	l
	add	a,TILE_X-1
	ld	(_l2_tile_offset),a
	ret
layer2_tile_get_offset_rotate_x_mirror:
	; tile_offset = (px << 3) + py; // 4
	ld	a,l
	add	a
	add	a
	add	a
	add	a,h
	ld	(_l2_tile_offset),a
	ret
layer2_tile_get_offset_rotate:
	; tile_offset = ((TILE_X - px) << 3) + py - TILE_Y; // 5
	ld	a,TILE_X
	sub	l
	add	a
	add	a
	add	a
	add	a,h
	sub	TILE_Y
	ld	(_l2_tile_offset),a
	ret
layer2_tile_get_offset_rotate_xy_mirror:
	; tile_offset = (px << 3) - py + (TILE_Y - 1); // 6
	ld	a,l
	add	a
	add	a
	add	a
	sub	h
	add	a,TILE_Y-1
	ld	(_l2_tile_offset),a
	ret
layer2_tile_get_offset_rotate_y_mirror:
	; tile_offset = ((TILE_X - px) << 3) - py - 1; // 7
	ld	a,TILE_X
	sub	l
	add	a
	add	a
	add	a
	sub	h
	dec	a
	ld	(_l2_tile_offset),a
	ret

; void layer2_tilemap_update_column()
; ---------------------------------
; Function layer2_tilemap_update_column
; ---------------------------------
_layer2_tilemap_update_column:
	; pixel_x = (offset_x & 7);
	ld	a,(_l2_offset_x)
	and	%00000111
	ld	(_l2_offset_pixel_x),a
	; pixel_y = (offset_y & 7);
	ld	a,(_l2_offset_y)
	and	%00000111
	ld	(_l2_offset_pixel_y),a
	; map_l2_offset_x = (offset_x >> 3);
	ld	de,(_l2_offset_x)
	ld	b,3
	bsra	de,b
	ld	a,e
	ld	(_l2_map_offset_x),a
	; map_l2_offset_y = (offset_y >> 3);
	ld	de,(_l2_offset_y)
	bsra	de,b
	ld	a,e
	ld	(_l2_map_offset_y),a
IF MAP_Y_FIRST
	; map_offset = map_l2_offset_y + map_tiles_y * map_l2_offset_x;
	ld	a,(_l2_map_tiles_y)
	ld	d,a
	ld	a, (_l2_map_offset_x)
	ld	e,a
	mul	de
	ld	hl,(_l2_map_offset_y)
	add	hl,de
	ld	(_l2_map_offset),hl
ELSE
	; map_offset = map_l2_offset_y * map_tiles_x + map_l2_offset_x;
	ld	a,(_l2_map_tiles_x)
	ld	e,a
	ld	hl,(_l2_map_offset_y-1)
	ld	d,l
	ld	b,0x08
l_layer2_tilemap_update_column_00140:
	add	hl,hl
	jr	NC,l_layer2_tilemap_update_column_00141
	add	hl,de
l_layer2_tilemap_update_column_00141:
	djnz	l_layer2_tilemap_update_column_00140
	ld	a,(_l2_map_offset_x)
	ld	c,a
	ld	b,0x00
	ld	a,l
	add	a,c
	ld	(_l2_map_offset),a
	ld	a,h
	adc	a,b
	ld	(_l2_map_offset+1),a
ENDIF
	; for (y = 0; y < SCREEN_TILES_Y + 1; y++)
	xor	a
	ld	(_l2_screen_tile_y),a
l_layer2_tilemap_update_column_00109:
	; screen_x = offset_x;
	ld	hl,(_l2_offset_x)
	ld	(_l2_screen_x),hl
	; screen_y = offset_y + (y << 3) - pixel_y;
	ld	a,(_l2_screen_tile_y)
	ld	e,a
	ld	d,0
	ld	b,3
	bsla	de,b
	ld	hl,(_l2_offset_y)
	add	hl,de
	ld	de,(_l2_offset_pixel_y)
	sbc	hl,de
	ld	(_l2_screen_y),hl
	; tile_y = MIN(offset_y + SCREEN_Y - screen_Y, TILE_Y);
	ld	hl,(_l2_offset_y)
	add	hl,SCREEN_Y-TILE_Y
	ld	bc,(_l2_screen_y)
	or	a
	sbc	hl,bc
	ld	bc,TILE_Y
	add	hl,bc
	jr	NC,l_layer2_tilemap_update_column_00114
	ld	b,h
	ld	c,l
l_layer2_tilemap_update_column_00114:
	ld	hl,_l2_tile_y
	ld	(hl),c
IF SCREEN_RES = RES_256x192
	; screen_bank = mod192(screen_y) >> 6;
	ld	hl,(_l2_screen_y)
	call	_mod192
	ld	a,l
	rlca
	rlca
	and	%00000011
	ld	(_l2_screen_bank),a
ELIF SCREEN_RES = RES_320x256
	; screen_bank = mod320(screen_x) >> 6;
	ld	hl,(_l2_screen_x)
	call	_mod320
	sla	e
	rl	d
	sla	e
	rl	d
	ld	a,d
	ld	(_l2_screen_bank),a
ENDIF
	ld	hl,(_l2_screen_start_page)
	add	a,l
	ld	(_l2_screen_page),a
IF MAP_Y_FIRST
	; map_index = screen_l2_tile_y + map_tiles_y * offset_l2_tile_x;
	ld	hl,_l2_offset_tile_x
	ld	e, (hl)
	ld	hl,(_l2_map_tiles_y-1)
	ld	l,0x00
	ld	d, l
	ld	b,0x08
l_layer2_tilemap_update_column_00142:
	add	hl, hl
	jr	NC,l_layer2_tilemap_update_column_00143
	add	hl, de
l_layer2_tilemap_update_column_00143:
	djnz	l_layer2_tilemap_update_column_00142
	ex	de, hl
	ld	hl,(_l2_screen_tile_y)
	add	hl,de
	ld	(_l2_map_index),hl
ELSE
	; map_index = screen_l2_tile_y * map_tiles_x + offset_l2_tile_x;
	ld	a,(_l2_map_tiles_x)
	ld	e,a
	ld	hl,(_l2_screen_tile_y-1)
	ld	d,l
	ld	b,0x08
l_layer2_tilemap_update_column_00142:
	add	hl,hl
	jr	NC,l_layer2_tilemap_update_column_00143
	add	hl,de
l_layer2_tilemap_update_column_00143:
	djnz	l_layer2_tilemap_update_column_00142
	ld	a,(_l2_offset_tile_x)
	ld	c,a
	ld	a,l
	add	a,c
	ld	(_l2_map_index),a
	ld	a,h
	adc	a,0
	ld	(_l2_map_index+1),a
ENDIF
	; bank_set_16k(MMU_LAYER2_MAP, PAGE_LAYER2_MAP);
	ld	hl,MMU_LAYER2_MAP << 8 | PAGE_LAYER2_MAP
	call	_asm_bank_set_16k
	; tile_data = tiles_nxm[map_offset + map_index];
	ld	hl,(_l2_map_offset)
	ld	de,(_l2_map_index)
	add	hl,de
	add	hl,hl
	ld	de,(_l2_map_data)
	add	hl,de
	ld	de,_l2_tile_data
	ldi
	ld	a,(hl)
	ld	(de),a
	; tile_id = tile_data & 0xff;
	dec	de
	ld	a,(de)
	ld	(_l2_tile_id),a
	; tile_page = PAGE_LAYER2_TILES + ((tile_data >> 8) & 0x1);
	ld	a,(_l2_tile_data+1)
	ld	c,a
	and	%00000001
	add	a,PAGE_LAYER2_TILES
	ld	(_l2_tile_page),a
	; tile_attribs = (tile_data >> 8) & 0xe;
	ld	a,c
	and	%00001110
	ld	(_l2_tile_attribs),a
	; tile_index = tile_id << 6;
	ld	hl,_l2_tile_id
	ld	e,(hl)
	xor	a
	ld	d,a
	ex	de,hl
	srl	h
	rr	l
	rra
	srl	h
	rr	l
	rra
	ld	h,l
	ld	l,a
	ld	(_l2_tile_index),hl
	; bank_set_16k(MMU_LAYER2_TILES, tile_page);
	ld	a,(_l2_tile_page)
	ld	h,MMU_LAYER2_TILES
	ld	l,a
	call	_asm_bank_set_16k
	; bank_set_16k(MMU_LAYER2, screen_page);
	ld	a,(_l2_screen_page)
	ld	h,MMU_LAYER2
	ld	l,a
	call	_asm_bank_set_16k
	; if (tile_y == TILE_Y)
	ld	a,(_l2_tile_y)
	sub	TILE_Y
	jr	NZ,l_layer2_tilemap_update_column_00103
IF SCREEN_RES = RES_256x192
	; screen_index_x = screen_x & 255;
	ld	a,(_l2_screen_x)
	ld	hl,_l2_screen_index_x
	ld	(hl),a
	; screen_index_y = (screen_y & 63) << 8;
	ld	a,(_l2_screen_y)
	and	%00111111
	ld	hl,_l2_screen_index_y+1
	ld	(hl),a
	dec	hl
	ld	(hl),0x00
	; layer2_tilemap_draw_row(pixel_x, tile_attribs, screen_address + screen_index_x + screen_index_y, tiles_address + tile_index);
	ld	hl,(_l2_tiles_address)
	ld	de,(_l2_tile_index)
	add	hl,de
	ex	de,hl
	ld	hl,(_l2_screen_address)
	ld	bc,(_l2_screen_index_x)
	add	hl,bc
	ld	bc,(_l2_screen_index_y)
	ld	a,(_l2_screen_index_y)
	add	hl,a
	add	hl,bc
	ex	de,hl
	ld	a,(_l2_tile_attribs)
	ld	b,a
	ld	a,(_l2_offset_pixel_x)
	ld	c,a
	call	_layer2_tilemap_draw_row
ELIF SCREEN_RES = RES_320x256
	; screen_index_x = (screen_x & 63) << 8;
	ld	a,(_l2_screen_x)
	and	%00111111
	ld	(_l2_screen_index_x+1),a
	xor	a
	ld	(_l2_screen_index_x),a
	; screen_index_y = screen_y & 255;
	ld	a,(_l2_screen_y)
	ld	(_l2_screen_index_y),a
	; layer2_tilemap_draw_column(pixel_x, tile_attribs, screen_address + screen_index_x + screen_index_y, tiles_address + tile_index);
	ld	hl,(_l2_tiles_address)
	ld	de,(_l2_tile_index)
	add	hl,de
	ex	de,hl
	ld	hl,(_l2_screen_address)
	ld	bc,(_l2_screen_index_x)
	add	hl,bc
	ld	bc,(_l2_screen_index_y)
	add	hl,bc
	ex	de,hl
	ld	a,(_l2_tile_attribs)
	ld	b,a
	ld	a,(_l2_offset_pixel_x)
	ld	c,a
	call	_layer2_tilemap_draw_column
ENDIF
	jr	l_layer2_tilemap_update_column_00110
l_layer2_tilemap_update_column_00103:
	; px = pixel_x;
	ld	a,(_l2_offset_pixel_x)
	ld	(_l2_tile_pixel_x),a
	; for (py = 0; py < tile_y; py++)
	xor	a
	ld	(_l2_tile_pixel_y),a
l_layer2_tilemap_update_column_00107:
	ld	a,(_l2_tile_pixel_y)
	ld	hl,_l2_tile_y
	sub	(hl)
	jr	NC,l_layer2_tilemap_update_column_00110
IF SCREEN_RES = RES_256x192
	; layer2_tile_get_offset_flip();
	call	_layer2_tile_get_offset_flip
	; screen_index_x = screen_x & 255;
	ld	a,(_l2_screen_x)
	ld	hl,_l2_screen_index_x
	ld	(hl),a
	; screen_index_y = ((screen_y + py) & 63) << 8;
	ld	a,(_l2_tile_pixel_y)
	ld	c,a
	ld	b,0x00
	ld	hl,_l2_screen_y
	ld	a,(hl)
	add	a,c
	ld	c,a
	inc	hl
	ld	a,(hl)
	adc	a,b
	ld	a,c
	and	%00111111
	ld	hl,_l2_screen_index_y+1
	ld	(hl),a
	dec	hl
	ld	(hl),0x00
ELIF SCREEN_RES = RES_320x256
	; layer2_tile_get_offset();
	call	_layer2_tile_get_offset
	; screen_index_x = (screen_x & 63) << 8;
	ld	a,(_l2_screen_x)
	and	%00111111
	ld	(_l2_screen_index_x+1),a
	xor	a
	ld	(_l2_screen_index_x),a
	; screen_index_y = (screen_y + py) & 255;
	ld	bc,(_l2_tile_pixel_y)
	ld	a,(_l2_screen_y)
	add	a,c
	ld	(_l2_screen_index_y),a
ENDIF
	; screen_address[screen_index_x + screen_index_y] = tiles_address[tile_index + tile_offset];
	ld	hl,(_l2_screen_index_x)
	ld	de,(_l2_screen_index_y)
	add	hl,de
	ld	de,(_l2_screen_address)
	add	hl,de
	ex	de,hl
	ld	hl,(_l2_tile_index)
	ld	bc,(_l2_tile_offset)
	add	hl,bc
	ld	bc,(_l2_tiles_address)
	add	hl,bc
	ldi
	; for (py = 0; py < tile_y; py++)
	ld	hl,_l2_tile_pixel_y
	inc	(hl)
	jr	l_layer2_tilemap_update_column_00107
l_layer2_tilemap_update_column_00110:
	; for (y = 0; y < SCREEN_TILES_Y + 1; y++)
	ld	hl,_l2_screen_tile_y
	inc	(hl)
	ld	a,(hl)
	sub	SCREEN_TILES_Y+1
	jp	C,l_layer2_tilemap_update_column_00109
	; }
	ret

; void layer2_tilemap_update_row()
; ---------------------------------
; Function layer2_tilemap_update_row
; ---------------------------------
_layer2_tilemap_update_row:
	; pixel_x = (offset_x & 7);
	ld	a,(_l2_offset_x)
	and	%00000111
	ld	(_l2_offset_pixel_x),a
	; pixel_y = (offset_y & 7);
	ld	a,(_l2_offset_y)
	and	%00000111
	ld	(_l2_offset_pixel_y),a
	; map_l2_offset_x = (offset_x >> 3);
	ld	de,(_l2_offset_x)
	ld	b,3
	bsra	de,b
	ld	a,e
	ld	(_l2_map_offset_x),a
	; map_l2_offset_y = (offset_y >> 3);
	ld	de,(_l2_offset_y)
	bsra	de,b
	ld	a,e
	ld	(_l2_map_offset_y),a
IF MAP_Y_FIRST
	; map_offset = map_l2_offset_y + map_tiles_y * map_l2_offset_x;
	ld	a,(_l2_map_tiles_y)
	ld	d,a
	ld	a, (_l2_map_offset_x)
	ld	e,a
	mul	de
	ld	hl,(_l2_map_offset_y)
	add	hl,de
	ld	(_l2_map_offset),hl
ELSE
	; map_offset = map_l2_offset_y * map_tiles_x + map_l2_offset_x;
	ld	a,(_l2_map_tiles_x)
	ld	e,a
	ld	hl,(_l2_map_offset_y-1)
	ld	d,l
	ld	b,0x08
l_layer2_tilemap_update_row_00140:
	add	hl,hl
	jr	NC,l_layer2_tilemap_update_row_00141
	add	hl,de
l_layer2_tilemap_update_row_00141:
	djnz	l_layer2_tilemap_update_row_00140
	ld	a,(_l2_map_offset_x)
	ld	c,a
	ld	b,0x00
	ld	a,l
	add	a,c
	ld	(_l2_map_offset),a
	ld	a,h
	adc	a,b
	ld	(_l2_map_offset+1),a
ENDIF
	; for (x = 0; x < SCREEN_TILES_X + 1; x++)
	xor	a
	ld	(_l2_screen_tile_x),a
l_layer2_tilemap_update_row_00109:
	; screen_x = offset_x + (x << 3) - pixel_x;
	ld	hl,_l2_screen_tile_x
	ld	e,(hl)
	ld	d,0x00
	ex	de,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ex	de,hl
	ld	hl,(_l2_offset_x)
	add	hl,de
	ld	a,(_l2_offset_pixel_x)
	ld	e,a
	xor	a
	ld	d,a
	sbc	hl,de
	ld	(_l2_screen_x),hl
	; screen_y = offset_y;
	ld	hl,(_l2_offset_y)
	ld	(_l2_screen_y),hl
	; tile_x = MIN(offset_x + SCREEN_X - screen_x, TILE_X);
	ld	hl,(_l2_offset_x)
	add	hl,SCREEN_X-TILE_X
	ld	bc,(_l2_screen_x)
	or	a
	sbc	hl,bc
	ld	bc,TILE_X
	add	hl,bc
	jr	NC,l_layer2_tilemap_update_row_00114
	ld	b,h
	ld	c,l
l_layer2_tilemap_update_row_00114:
	ld	hl,_l2_tile_x
	ld	(hl),c
IF SCREEN_RES = RES_256x192
	; screen_bank = mod192(screen_y) >> 6;
	ld	hl,(_l2_screen_y)
	call	_mod192
	ld	a,l
	rlca
	rlca
	and	%00000011
	ld	(_l2_screen_bank),a
ELIF SCREEN_RES = RES_320x256
	; screen_bank = mod320(screen_x) >> 6;
	ld	hl,(_l2_screen_x)
	call	_mod320
	sla	e
	rl	d
	sla	e
	rl	d
	ld	a,d
	ld	(_l2_screen_bank),a
ENDIF
	; screen_page = screen_start_page + screen_bank;
	ld	hl,(_l2_screen_start_page)
	add	a,l
	ld	(_l2_screen_page),a
IF MAP_Y_FIRST
	; map_index = offset_l2_tile_y + map_tiles_y * screen_l2_tile_x;
	ld	a,(_l2_offset_tile_y)
	ld	c,a
	ld	a,(_l2_map_tiles_y)
	ld	e,a
	ld	a,(_l2_screen_tile_x)
	ld	d,a
	mul	de
	ld	a,c
	add	a,e
	ld	hl,_l2_map_index
	ld	(hl),a
	ld	a,0x00
	adc	a,d
	inc	hl
	ld	(hl), a
ELSE
	; map_index = src_y * map_tiles_x + x;
	ld	hl,_l2_map_tiles_x
	ld	e,(hl)
	ld	hl,(_l2_offset_tile_y-1)
	ld	l,0x00
	ld	d,l
	ld	b,0x08
l_layer2_tilemap_update_row_00142:
	add	hl,hl
	jr	NC,l_layer2_tilemap_update_row_00143
	add	hl,de
l_layer2_tilemap_update_row_00143:
	djnz	l_layer2_tilemap_update_row_00142
	ld	a,(_l2_screen_tile_x)
	ex	de,hl
	ld	c,a
	ld	b,0x00
	ld	a,e
	add	a,c
	ld	(_l2_map_index),a
	ld	a,d
	adc	a,b
	ld	(_l2_map_index+1),a
ENDIF
	; bank_set_16k(MMU_LAYER2_MAP, PAGE_LAYER2_MAP);
	ld	hl,MMU_LAYER2_MAP << 8 | PAGE_LAYER2_MAP
	call	_asm_bank_set_16k
	; tile_data = tiles_nxm[map_offset + map_index];
	ld	hl,(_l2_map_offset)
	ld	de,(_l2_map_index)
	add	hl,de
	add	hl,hl
	ld	de,(_l2_map_data)
	add	hl,de
	ld	de,_l2_tile_data
	ldi
	ld	a,(hl)
	ld	(de),a
	ex	de,hl
	; tile_id = tile_data & 0xff;
	dec	hl
	ld	a,(hl)
	ld	(_l2_tile_id),a
	; tile_page = PAGE_LAYER2_TILES + ((tile_data >> 8) & 0x1);
	ld	a,(_l2_tile_data+1)
	ld	c,a
	and	%00000001
	add	a,PAGE_LAYER2_TILES
	ld	(_l2_tile_page),a
	; tile_attribs = (tile_data >> 8) & 0xe;
	ld	a,c
	and	%00001110
	ld	(_l2_tile_attribs),a
	; tile_index = tile_id << 6;
	ld	hl,_l2_tile_id
	ld	e,(hl)
	xor	a
	ld	d,a
	ex	de,hl
	srl	h
	rr	l
	rra
	srl	h
	rr	l
	rra
	ld	h,l
	ld	l,a
	ld	(_l2_tile_index),hl
	; bank_set_16k(MMU_LAYER2_TILES, tile_page);
	ld	a,(_l2_tile_page)
	ld	h,MMU_LAYER2_TILES
	ld	l,a
	call	_asm_bank_set_16k
	; bank_set_16k(MMU_LAYER2, screen_page);
	ld	a,(_l2_screen_page)
	ld	h,MMU_LAYER2
	ld	l,a
	call	_asm_bank_set_16k
	; if (tile_x == TILE_X)
	ld	a,(_l2_tile_x)
	sub	TILE_X
	jr	NZ,l_layer2_tilemap_update_row_00103
IF SCREEN_RES = RES_256x192
	; screen_index_x = screen_x & 255;
	ld	a,(_l2_screen_x)
	ld	hl,_l2_screen_index_x
	ld	(hl),a
	; screen_index_y = (screen_y & 63) << 8;
	ld	a,(_l2_screen_y)
	and	%00111111
	ld	hl,_l2_screen_index_y+1
	ld	(hl),a
	dec	hl
	ld	(hl),0x00
	; layer2_tilemap_draw_column(pixel_y, tile_attribs, screen_address + screen_index_x + screen_index_y, tiles_address + tile_index);
	ld	hl,(_l2_tiles_address)
	ld	de,(_l2_tile_index)
	add	hl,de
	ex	de,hl
	ld	hl,(_l2_screen_address)
	ld	bc,(_l2_screen_index_x)
	add	hl,bc
	ld	bc,(_l2_screen_index_y)
	add	hl,bc
	ex	de,hl
	ld	a,(_l2_tile_attribs)
	ld	b,a
	ld	a,(_l2_offset_pixel_y)
	ld	c,a
	call	_layer2_tilemap_draw_column
ELIF SCREEN_RES = RES_320x256
	; screen_index_x = (screen_x & 63) << 8;
	ld	a,(_l2_screen_x)
	and	%00111111
	ld	(_l2_screen_index_x+1),a
	xor	a
	ld	(_l2_screen_index_x),a
	; screen_index_y = screen_y & 255;
	ld	a,(_l2_screen_y)
	ld	(_l2_screen_index_y),a
	; layer2_tilemap_draw_row(pixel_y, tile_attribs, screen_address + screen_index_x + screen_index_y, tiles_address + tile_index);
	ld	hl,(_l2_tiles_address)
	ld	de,(_l2_tile_index)
	add	hl,de
	ex	de,hl
	ld	hl,(_l2_screen_address)
	ld	bc,(_l2_screen_index_x)
	add	hl,bc
	ld	bc,(_l2_screen_index_y)
	ld	a,(_l2_screen_index_y)
	add	hl,a
	ex	de,hl
	ld	a,(_l2_tile_attribs)
	ld	b,a
	ld	a,(_l2_offset_pixel_y)
	ld	c,a
	call	_layer2_tilemap_draw_row
ENDIF
	jr	l_layer2_tilemap_update_row_00110
l_layer2_tilemap_update_row_00103:
	; py = pixel_y;
	ld	a,(_l2_offset_pixel_y)
	ld	(_l2_tile_pixel_y),a
	; for (px = 0; px < tile_x; px++)
	ld	hl,_l2_tile_pixel_x
	ld	(hl),0x00
l_layer2_tilemap_update_row_00107:
	ld	a,(_l2_tile_pixel_x)
	ld	hl,_l2_tile_x
	sub	(hl)
	jr	NC,l_layer2_tilemap_update_row_00110
IF SCREEN_RES = RES_256x192
	; layer2_tile_get_offset_flip();
	call	_layer2_tile_get_offset_flip
	; screen_index_x = (screen_x + px) & 255;
	ld	a,(_l2_tile_pixel_x)
	ld	c,a
	ld	b,0x00
	ld	hl,_l2_screen_x
	ld	a,(hl)
	add	a,c
	ld	c,a
	inc	hl
	ld	a,(hl)
	adc	a,b
	ld	hl,_l2_screen_index_x
	ld	(hl),c
	; screen_index_y = (screen_y & 63) << 8;
	ld	a,(_l2_screen_y)
	and	%00111111
	ld	hl,_l2_screen_index_y+1
	ld	(hl),a
	dec	hl
	ld	(hl),0x00
ELIF SCREEN_RES = RES_320x256
	; layer2_tile_get_offset();
	call	_layer2_tile_get_offset
	; screen_index_x = ((screen_x + px) & 63) << 8;
	ld	a,(_l2_tile_pixel_x)
	ld	c,a
	ld	b,0x00
	ld	hl,_l2_screen_x
	ld	a,(hl)
	add	a,c
	ld	c,a
	inc	hl
	ld	a,(hl)
	adc	a,b
	ld	a,c
	and	%00111111
	ld	(_l2_screen_index_x+1),a
	xor	a
	ld	(_l2_screen_index_x),a
	; screen_index_y = screen_y & 255;
	ld	a,(_l2_screen_y)
	ld	(_l2_screen_index_y),a
ENDIF
	; screen_address[screen_index_x + screen_index_y] = tiles_address[tile_index + tile_offset];
	ld	hl,(_l2_screen_index_x)
	ld	bc,(_l2_screen_index_y)
	add	hl,bc
	ld	bc,(_l2_screen_address)
	add	hl,bc
	ld	a,(_l2_tile_offset)
	ld	e,a
	ld	d,0x00
	ld	c,l
	ld	b,h
	ld	hl,(_l2_tile_index)
	add	hl,de
	ex	de,hl
	ld	hl,(_l2_tiles_address)
	add	hl,de
	ld	a,(hl)
	ld	(bc),a
	; for (px = 0; px < tile_x; px++)
	ld	hl,_l2_tile_pixel_x
	inc	(hl)
	jr	l_layer2_tilemap_update_row_00107
l_layer2_tilemap_update_row_00110:
	; for (x = 0; x < SCREEN_TILES_X + 1; x++)
	ld	hl,_l2_screen_tile_x
	ld	a,(hl)
	inc	a
	ld	(hl),a
	sub	SCREEN_TILES_X+1
	jp	C,l_layer2_tilemap_update_row_00109
	; }
	ret

; void layer2_tilemap_update()
; ---------------------------------
; Function layer2_tilemap_update
; ---------------------------------
_layer2_tilemap_update:
	; pixel_x = (offset_x & 7);
	ld	a,(_l2_offset_x)
	and	%00000111
	ld	(_l2_offset_pixel_x),a
	; pixel_y = (offset_y & 7);
	ld	a,(_l2_offset_y)
	and	%00000111
	ld	(_l2_offset_pixel_y),a
	; map_l2_offset_x = (offset_x >> 3);
	ld	de,(_l2_offset_x)
	ld	b,3
	bsra	de,b
	ld	a,e
	ld	(_l2_map_offset_x),a
	; map_l2_offset_y = (offset_y >> 3);
	ld	de,(_l2_offset_y)
	bsra	de,b
	ld	a,e
	ld	(_l2_map_offset_y),a
IF MAP_Y_FIRST
	; map_offset = map_l2_offset_y + map_tiles_y * map_l2_offset_x;
	ld	a,(_l2_map_tiles_y)
	ld	d,a
	ld	a, (_l2_map_offset_x)
	ld	e,a
	mul	de
	ld	hl,(_l2_map_offset_y)
	add	hl,de
	ld	(_l2_map_offset),hl
ELSE
	; map_offset = map_l2_offset_y * map_tiles_x + map_l2_offset_x;
	ld	a,(_l2_map_tiles_x)
	ld	e,a
	ld	hl,(_l2_map_offset_y-1)
	ld	d,l
	ld	b,0x08
l_layer2_tilemap_update_00174:
	add	hl,hl
	jr	NC,l_layer2_tilemap_update_00175
	add	hl,de
l_layer2_tilemap_update_00175:
	djnz	l_layer2_tilemap_update_00174
	ld	a,(_l2_map_offset_x)
	ld	c,a
	ld	b,0x00
	ld	a,l
	add	a,c
	ld	(_l2_map_offset),a
	ld	a,h
	adc	a,b
	ld	(_l2_map_offset+1),a
ENDIF
	; map_address = (uint8_t *)zxn_addr_from_mmu(MMU_LAYER2_MAP);
	ld	l,MMU_LAYER2_MAP
	call	_zxn_addr_from_mmu_fastcall
	ld	(_l2_map_address),hl
	; tiles_address = (uint8_t *)zxn_addr_from_mmu(MMU_LAYER2_TILES);
	ld	e,MMU_LAYER2_TILES
	ex	de,hl
	call	_zxn_addr_from_mmu_fastcall
	ld	(_l2_tiles_address),hl
	; screen_address = (uint8_t *)zxn_addr_from_mmu(MMU_LAYER2);
	ld	e,MMU_LAYER2
	ex	de,hl
	call	_zxn_addr_from_mmu_fastcall
	ld	(_l2_screen_address),hl
	; for (y = 0; y < SCREEN_TILES_Y + 1; y++)
	xor	a
	ld	(_l2_screen_tile_y),a
l_layer2_tilemap_update_00116:
	; for (x = 0; x < SCREEN_TILES_X + 1; x++)
	xor	a
	ld	(_l2_screen_tile_x),a
l_layer2_tilemap_update_00114:
	; screen_x = offset_x + (x << 3) - pixel_x;
	ld	a,(_l2_screen_tile_x)
	ld	e,a
	ld	d,0
	ld	b,3
	bsla	de,b
	ld	hl,(_l2_offset_x)
	add	hl,de
	ld	de,(_l2_offset_pixel_x)
	sbc	hl,de
	ld	(_l2_screen_x),hl
	; screen_y = offset_y + (y << 3) - pixel_y;
	ld	a,(_l2_screen_tile_y)
	ld	e,a
	ld	d,0
	ld	b,3
	bsla	de,b
	ld	hl,(_l2_offset_y)
	add	hl,de
	ld	de,(_l2_offset_pixel_y)
	sbc	hl,de
	ld	(_l2_screen_y),hl
	; tile_x = MIN(offset_x + SCREEN_X - screen_x, TILE_X);
	ld	hl,(_l2_offset_x)
	add	hl,SCREEN_X-TILE_X
	ld	bc,(_l2_screen_x)
	or	a
	sbc	hl,bc
	ld	bc,TILE_X
	add	hl,bc
	jr	NC,l_layer2_tilemap_update_00121
	ld	b,h
	ld	c,l
l_layer2_tilemap_update_00121:
	ld	hl,_l2_tile_x
	ld	(hl),c
	; tile_y = MIN(offset_y + SCREEN_Y - screen_Y, TILE_Y);
	ld	hl,(_l2_offset_y)
	add	hl,SCREEN_Y-TILE_Y
	ld	bc,(_l2_screen_y)
	or	a
	sbc	hl,bc
	ld	bc,TILE_Y
	add	hl,bc
	jr	NC,l_layer2_tilemap_update_00123
	ld	b,h
	ld	c,l
l_layer2_tilemap_update_00123:
	ld	hl,_l2_tile_y
	ld	(hl),c
IF SCREEN_RES = RES_256x192
	; screen_bank = mod192(screen_y) >> 6;
	ld	hl,(_l2_screen_y)
	call	_mod192
	ld	a,l
	rlca
	rlca
	and	%00000011
	ld	(_l2_screen_bank),a
ELIF SCREEN_RES = RES_320x256
	; screen_bank = mod320(screen_x) >> 6;
	ld	hl,(_l2_screen_x)
	call	_mod320
	sla	e
	rl	d
	sla	e
	rl	d
	ld	a,d
	ld	(_l2_screen_bank),a
ENDIF
	; screen_page = screen_start_page + screen_bank;
	ld	hl,(_l2_screen_start_page)
	add	a,l
	ld	(_l2_screen_page),a
IF MAP_Y_FIRST
	; map_index = screen_l2_tile_y + map_tiles_y * screen_l2_tile_x;
	ld	a,(_l2_map_tiles_y)
	ld	d,a
	ld	a, (_l2_screen_tile_x)
	ld	e,a
	mul	de
	ld	hl,(_l2_screen_tile_y)
	add	hl,de
	ld	(_l2_map_index),hl
ELSE
	; map_index = y * map_tiles_x + x;
	ld	a,(_l2_map_tiles_x)
	ld	e,a
	ld	hl,(_l2_screen_tile_y-1)
	ld	d,l
	ld	b,0x08
l_layer2_tilemap_update_00176:
	add	hl,hl
	jr	NC,l_layer2_tilemap_update_00177
	add	hl,de
l_layer2_tilemap_update_00177:
	djnz	l_layer2_tilemap_update_00176
	ld	a,(_l2_screen_tile_x)
	ex	de,hl
	ld	c,a
	ld	b,0x00
	ld	a,e
	add	a,c
	ld	(_l2_map_index),a
	ld	a,d
	adc	a,b
	ld	(_l2_map_index+1),a
ENDIF
	; bank_set_16k(MMU_LAYER2_MAP, PAGE_LAYER2_MAP);
	ld	hl,MMU_LAYER2_MAP << 8 | PAGE_LAYER2_MAP
	call	_asm_bank_set_16k
	; tile_data = tiles_nxm[map_offset + map_index];
	ld	hl,(_l2_map_offset)
	ld	de,(_l2_map_index)
	add	hl,de
	add	hl,hl
	ld	de,(_l2_map_data)
	add	hl,de
	ld	de,_l2_tile_data
	ldi
	ld	a,(hl)
	ld	(de),a
	ex	de,hl
	; tile_id = tile_data & 0xff;
	dec	hl
	ld	a,(hl)
	ld	(_l2_tile_id),a
	; tile_page = PAGE_LAYER2_TILES + ((tile_data >> 8) & 0x1);
	ld	a,(_l2_tile_data+1)
	ld	c,a
	and	%00000001
	add	a,PAGE_LAYER2_TILES
	ld	(_l2_tile_page),a
	; tile_attribs = (tile_data >> 8) & 0xe;
	ld	a,c
	and	%00001110
	ld	(_l2_tile_attribs),a
	; tile_index = tile_id << 6;
	ld	hl,_l2_tile_id
	ld	e,(hl)
	xor	a
	ld	d,a
	ex	de,hl
	srl	h
	rr	l
	rra
	srl	h
	rr	l
	rra
	ld	h,l
	ld	l,a
	ld	(_l2_tile_index),hl
	; bank_set_16k(MMU_LAYER2_TILES, tile_page);
	ld	a,(_l2_tile_page)
	ld	h,MMU_LAYER2_TILES
	ld	l,a
	call	_asm_bank_set_16k
	; bank_set_16k(MMU_LAYER2, screen_page);
	ld	a,(_l2_screen_page)
	ld	h,MMU_LAYER2
	ld	l,a
	call	_asm_bank_set_16k
	; if ((tile_x & tile_y) >> 3)
	ld	a,(_l2_tile_x)
	ld	hl,_l2_tile_y
	and	(hl)
	rrca
	rrca
	rrca
	and	%00011111
	jr	Z,l_layer2_tilemap_update_00104
IF SCREEN_RES = RES_256x192
	; screen_index_x = screen_x & 255;
	ld	a,(_l2_screen_x)
	ld	hl,_l2_screen_index_x
	ld	(hl),a
	; screen_index_y = (screen_y & 63) << 8;
	ld	a,(_l2_screen_y)
	and	%00111111
	ld	hl,_l2_screen_index_y+1
	ld	(hl),a
	dec	hl
	ld	(hl),0x00
ELIF SCREEN_RES = RES_320x256
	; screen_index_x = (screen_x & 63) << 8;
	ld	a,(_l2_screen_x)
	and	%00111111
	ld	(_l2_screen_index_x+1),a
	xor	a
	ld	(_l2_screen_index_x),a
	; screen_index_y = screen_y & 255;
	ld	a,(_l2_screen_y)
	ld	(_l2_screen_index_y),a
ENDIF
	; layer2_tilemap_draw_tile(tile_id, tile_attribs, screen_address + screen_index_x + screen_index_y, tiles_address + tile_index);
	ld	hl,(_l2_tiles_address)
	ld	de,(_l2_tile_index)
	add	hl,de
	ex	de,hl
	ld	hl,(_l2_screen_address)
	ld	bc,(_l2_screen_index_x)
	add	hl,bc
	ld	bc,(_l2_screen_index_y)
	add	hl,bc
	ex	de,hl
	ld	a,(_l2_tile_attribs)
	ld	b,a
	call	_layer2_tilemap_draw_tile
	jp	l_layer2_tilemap_update_00115
l_layer2_tilemap_update_00104:
	; for (py = 0; py < tile_y; py++)
	ld	hl,_l2_tile_pixel_y
	ld	(hl),0x00
l_layer2_tilemap_update_00112:
	ld	a,(_l2_tile_pixel_y)
	ld	hl,_l2_tile_y
	sub	(hl)
	jr	NC,l_layer2_tilemap_update_00115
	; for (px = 0; px < tile_x; px++)
	ld	hl,_l2_tile_pixel_x
	ld	(hl),0x00
l_layer2_tilemap_update_00109:
	ld	a,(_l2_tile_pixel_x)
	ld	hl,_l2_tile_x
	sub	(hl)
	jr	NC,l_layer2_tilemap_update_00113
IF SCREEN_RES = RES_256x192
	; layer2_tile_get_offset_flip();
	call	_layer2_tile_get_offset_flip
	; screen_index_x = (screen_x + px) & 255;
	ld	a,(_l2_tile_pixel_x)
	ld	c,a
	ld	b,0x00
	ld	hl,_l2_screen_x
	ld	a,(hl)
	add	a,c
	ld	c,a
	inc	hl
	ld	a,(hl)
	adc	a,b
	ld	hl,_l2_screen_index_x
	ld	(hl),c
	xor	a
	inc	hl
	ld	(hl),a
	; screen_index_y = ((screen_y + py) & 63) << 8;
	ld	a,(_l2_tile_pixel_y)
	ld	c,a
	ld	b,0x00
	ld	hl,_l2_screen_y
	ld	a,(hl)
	add	a,c
	ld	c,a
	inc	hl
	ld	a,(hl)
	adc	a,b
	ld	a,c
	and	%00111111
	ld	hl,_l2_screen_index_y+1
	ld	(hl),a
	dec	hl
	ld	(hl),0x00
ELIF SCREEN_RES = RES_320x256
	; layer2_tile_get_offset();
	call	_layer2_tile_get_offset
	; screen_index_x = ((screen_x + px) & 63) << 8;
	ld	a,(_l2_tile_pixel_x)
	ld	c,a
	ld	b,0x00
	ld	hl,_l2_screen_x
	ld	a,(hl)
	add	a,c
	ld	c,a
	inc	hl
	ld	a,(hl)
	adc	a,b
	ld	a,c
	and	%00111111
	ld	hl,_l2_screen_index_x+1
	ld	(hl),a
	dec	hl
	ld	(hl),0x00
	; screen_index_y = (screen_y + py) & 255;
	ld	bc,(_l2_tile_pixel_y)
	ld	a,(_l2_screen_y)
	add	a,c
	ld	(_l2_screen_index_y),a
ENDIF
	; screen_address[screen_index_x + screen_index_y] = tiles_address[tile_index + tile_offset];
	ld	hl,(_l2_screen_index_x)
	ld	bc,(_l2_screen_index_y)
	add	hl,bc
	ld	bc,(_l2_screen_address)
	add	hl,bc
	ld	a,(_l2_tile_offset)
	ld	e,a
	ld	d,0x00
	ld	c,l
	ld	b,h
	ld	hl,(_l2_tile_index)
	add	hl,de
	ex	de,hl
	ld	hl,(_l2_tiles_address)
	add	hl,de
	ld	a,(hl)
	ld	(bc),a
	; for (px = 0; px < tile_x; px++)
	ld	hl,_l2_tile_pixel_x
	inc	(hl)
	jr	l_layer2_tilemap_update_00109
l_layer2_tilemap_update_00113:
	; for (py = 0; py < tile_y; py++)
	ld	hl,_l2_tile_pixel_y
	inc	(hl)
	jr	l_layer2_tilemap_update_00112
l_layer2_tilemap_update_00115:
	; for (x = 0; x < SCREEN_TILES_X + 1; x++)
	ld	hl,_l2_screen_tile_x
	ld	a,(hl)
	inc	a
	ld	(hl),a
	sub	SCREEN_TILES_X+1
	jp	C,l_layer2_tilemap_update_00114
	; for (y = 0; y < SCREEN_TILES_Y + 1; y++)
	ld	hl,_l2_screen_tile_y
	ld	a,(hl)
	inc	a
	ld	(hl),a
	sub	SCREEN_TILES_Y+1
	jp	C,l_layer2_tilemap_update_00116
	; }
	ret

_layer2_tilemap_scroll_update:
	ld	de,(_l2_offset_x)
	ld	a,e
	nextreg	REG_LAYER_2_OFFSET_X,a
	ld	a,d
	and	1
	nextreg	REG_LAYER_2_OFFSET_X_H,a
IF SCREEN_RES = RES_256x192
	ld	hl,(_l2_offset_y)
	call	_mod192
	ld	a,l
ELSE
	ld	de,(_l2_offset_y)
	ld	a,e
ENDIF
	nextreg	REG_LAYER_2_OFFSET_Y,a
	ret

_layer2_tilemap_scroll_left:
	ld	hl,(_l2_offset_x)
	ld	a,h
	or	a,l
	jr	Z,_layer2_tilemap_scroll_left_end

	ld	a,0
	ld	(_l2_offset_tile_x),a
	call	_layer2_tilemap_update_column

	ld	de,(_l2_offset_x)
	add	de,-1
	ld	(_l2_offset_x),de
	jp	_layer2_tilemap_scroll_update
_layer2_tilemap_scroll_left_end:
	ret

_layer2_tilemap_scroll_right:
	ld	hl,(_l2_map_tiles_x)
	ld	h,0x00
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	de,0xffff-SCREEN_X
	add	hl,de
	ld	c,l
	ld	b,h
	ld	hl,_l2_offset_x
	ld	a,(hl)
	sub	c
	inc	hl
	ld	a,(hl)
	sbc	a,b
	jr	NC,_layer2_tilemap_scroll_right_end

	ld	a,SCREEN_TILES_X
	ld	(_l2_offset_tile_x),a
	call	_layer2_tilemap_update_column

	ld	de,(_l2_offset_x)
	add	de,1
	ld	(_l2_offset_x),de
	jp	_layer2_tilemap_scroll_update
_layer2_tilemap_scroll_right_end:
	ret

_layer2_tilemap_scroll_up:
	ld	hl,(_l2_offset_y)
	ld	a,h
	or	a,l
	jp	Z,_layer2_tilemap_scroll_up_end

	ld	a,0
	ld	(_l2_offset_tile_y),a
	call	_layer2_tilemap_update_row

	ld	de,(_l2_offset_y)
	add	de,-1
	ld	(_l2_offset_y),de
	jp	_layer2_tilemap_scroll_update
_layer2_tilemap_scroll_up_end:
	ret

_layer2_tilemap_scroll_down:
	ld	hl,(_l2_map_tiles_y)
	ld	h,0x00
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	de,0xffff-SCREEN_Y
	add	hl,de
	ld	c,l
	ld	b,h
	ld	hl,_l2_offset_y
	ld	a,(hl)
	sub	c
	inc	hl
	ld	a,(hl)
	sbc	a,b
	jp	NC,_layer2_tilemap_scroll_down_end

	ld	a,SCREEN_TILES_Y
	ld	(_l2_offset_tile_y),a
	call	_layer2_tilemap_update_row

	ld	de,(_l2_offset_y)
	add	de,1
	ld	(_l2_offset_y),de
	jp	_layer2_tilemap_scroll_update
_layer2_tilemap_scroll_down_end:
	ret

ENDIF