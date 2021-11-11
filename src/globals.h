#ifndef _GLOBALS_H
#define _GLOBALS_H

#include "bank.h"

#define RES_256x192				0
#define RES_320x256				1
#define RES_640x256				2

#include "zconfig.h"

#define RTM_28MHZ				0x03

#define WFRAMES					4

#define TILE_X					8
#define TILE_Y					8
#define TILE_SIZE				(TILE_X * TILE_Y)
#define TILE_BANK_COUNT			(BANKSIZE_16K / TILE_SIZE)

#if (SCREEN_RES == RES_256x192)
#define SCREEN_X				256
#define SCREEN_Y				192
#elif (SCREEN_RES == RES_320x256)
#define SCREEN_X				320
#define SCREEN_Y				256
#elif (SCREEN_RES == RES_640x256)
#define SCREEN_X				640
#define SCREEN_Y				256
#endif

#define SCREEN_SIZE				(SCREEN_X * SCREEN_Y)
#define SCREEN_TILES_X			(SCREEN_X / TILE_X)
#define SCREEN_TILES_Y			(SCREEN_Y / TILE_Y)
#define SCREEN_TILES_COUNT		(SCREEN_TILES_X * SCREEN_TILES_Y)

#define SCREEN_BANK_X			(BANKSIZE_16K / SCREEN_Y)
#define SCREEN_BANK_Y			(BANKSIZE_16K / SCREEN_X)

#define MIN(a, b)				(((a) < (b)) ? (a) : (b))
#define MAX(a, b)				(((a) > (b)) ? (a) : (b))
#define CLAMP(x, lower, upper)	(MIN(upper, MAX(x, lower)))
#define printAt(col, row, str)	printf("\x16%c%c%s", (col), (row), (str))

extern void breakpoint();
extern void wait_vblank();
extern void set_border_color(uint8_t color);

#endif
