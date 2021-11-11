divert(-1)

define(`ADDR_LAYER2', 0x0000)
define(`PAGE_LAYER2', 9)
define(`MMU_LAYER2', ADDR_LAYER2>>13)

define(`ADDR_LAYER2_MAP', 0x4000)
define(`PAGE_LAYER2_MAP', 17)
define(`MMU_LAYER2_MAP', ADDR_LAYER2_MAP>>13)

define(`ADDR_LAYER2_TILES', 0xC000)
define(`PAGE_LAYER2_TILES', 32)
define(`MMU_LAYER2_TILES', ADDR_LAYER2_TILES>>13)

define(`ADDR_FONT', 0xC000)
define(`PAGE_FONT', 25)
define(`MMU_FONT', ADDR_FONT>>13)

# Screen resolution: RES_256x192 or RES_320x256
define(`SCREEN_RES', RES_320x256)

# Use the assembly or C version
define(`USE_ASM_VERSION', 1)

# Use align version for mod LUTs
define(`ALIGN_MOD_LUT', 1)

# Use tile y first order
define(`MAP_Y_FIRST', 0)

# Set CRT location as 0x6000 or 0x8000
define(`CRT_6000', 0)

################################################################################
# FILE: zconfig.h
################################################################################

ifelse(TARGET, 1,
`
divert
`#ifndef' _SETTINGS_H
`#define' _SETTINGS_H

`#define' `MMU_LAYER2'				MMU_LAYER2
`#define' `PAGE_LAYER2'				PAGE_LAYER2

`#define' `MMU_LAYER2_MAP'			MMU_LAYER2_MAP
`#define' `PAGE_LAYER2_MAP'			PAGE_LAYER2_MAP

`#define' `MMU_LAYER2_TILES'		MMU_LAYER2_TILES
`#define' `PAGE_LAYER2_TILES'		PAGE_LAYER2_TILES

`#define' `MMU_FONT'				MMU_FONT
`#define' `PAGE_FONT'				PAGE_FONT

`#define' `SCREEN_RES'				SCREEN_RES
`#define' `USE_ASM_VERSION'			USE_ASM_VERSION

`#define' `ALIGN_MOD_LUT'			ALIGN_MOD_LUT

`#define' `MAP_Y_FIRST'				MAP_Y_FIRST

`#define' `CRT_6000'				CRT_6000

`#endif'
divert(-1)
')

################################################################################
# FILE: zconfig.def
################################################################################

ifelse(TARGET, 2,
`
divert
`MMU_LAYER2'				`=' MMU_LAYER2
`PAGE_LAYER2'				`=' PAGE_LAYER2

`MMU_LAYER2_MAP'			`=' MMU_LAYER2_MAP
`PAGE_LAYER2_MAP'			`=' PAGE_LAYER2_MAP

`MMU_LAYER2_TILES'		`=' MMU_LAYER2_TILES
`PAGE_LAYER2_TILES'		`=' PAGE_LAYER2_TILES

`SCREEN_RES'				`=' SCREEN_RES
`USE_ASM_VERSION'			`=' USE_ASM_VERSION

`ALIGN_MOD_LUT'			`=' ALIGN_MOD_LUT

`MAP_Y_FIRST'				`=' MAP_Y_FIRST

`CRT_6000'				`=' CRT_6000

divert(-1)
')

################################################################################
# FILE: zconfig.m4
################################################################################

ifelse(TARGET, 3,
`
divert
divert(-1)
')

################################################################################
# FILE: zpragma.inc
################################################################################

ifelse(TARGET, 4,
`
divert
ifelse(CRT_6000, 1,
`
// Program org
`#pragma' output CRT_ORG_CODE				= 0x6164
',
`
// Program org
`#pragma' output CRT_ORG_CODE				= 0x8184
')dnl
ifelse(ALIGN_MOD_LUT, 1,
`
// Stack pointer with mod LUTs (0xC000-256)
`#pragma' output REGISTER_SP				= 0xBF00
',
`
// Stack pointer
`#pragma' output REGISTER_SP				= 0xC000
')dnl

`#pragma' output CRT_STACK_SIZE			= 128
`#pragma' output CRT_APPEND_MMAP			= 1
`#pragma' output CLIB_MALLOC_HEAP_SIZE	= 0
`#pragma' output CLIB_STDIO_HEAP_SIZE		= 0
`#pragma' output CLIB_FOPEN_MAX			= -1
`#pragma' output `CRT_ORG_BANK_'PAGE_LAYER2_MAP			= ADDR_LAYER2_MAP
`#pragma' output `CRT_ORG_BANK_'eval(PAGE_LAYER2_MAP+1)			= ADDR_LAYER2_MAP
`#pragma' output `CRT_ORG_BANK_'PAGE_LAYER2_TILES			= ADDR_LAYER2_TILES
`#pragma' output `CRT_ORG_BANK_'eval(PAGE_LAYER2_TILES+1)			= ADDR_LAYER2_TILES
`#pragma' output CRT_ORG_BANK_19			= 0xA000

divert(-1)
')

################################################################################
# FILE: zproject.lst
################################################################################

ifelse(TARGET, 5,
`
divert
src/math.asm
src/bank.asm
src/font.asm
src/tiles.asm
src/globals.asm
src/layer2.asm
src/layer2_tilemap_draw_tile.asm
src/layer2_tilemap_draw_column.asm
src/layer2_tilemap_draw_row.asm
src/globals.c
src/bank.c
src/dma.c
src/layer2.c
src/sprites.c
src/tilemap.c
src/main.c
divert(-1)
')

divert(0)dnl
