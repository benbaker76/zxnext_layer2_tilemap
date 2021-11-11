
SECTION rodata_user

PUBLIC _tiles_nxp
PUBLIC _tiles_nxp_end

_tiles_nxp:

	BINARY "binary/tiles.nxp"	; 512 bytes

_tiles_nxp_end:

SECTION BANK_17

PUBLIC _tiles_nxm
PUBLIC _tiles_nxm_end

_tiles_nxm:

	BINARY "binary/tiles.nxm"	; 16000 bytes

_tiles_nxm_end:

SECTION BANK_32

PUBLIC _tiles_0_nxt
PUBLIC _tiles_0_nxt_end

_tiles_0_nxt:

	BINARY "binary/tiles_0.nxt"	; 16384 bytes

_tiles_0_nxt_end:

SECTION BANK_33

PUBLIC _tiles_1_nxt
PUBLIC _tiles_1_nxt_end

_tiles_1_nxt:

	BINARY "binary/tiles_1.nxt"	; 11008 bytes

_tiles_1_nxt_end:
