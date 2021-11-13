/*******************************************************************************
 * Ben Baker 2020
 *
 * A layer 2 tilemap demo for Sinclair ZX Spectrum Next.
 ******************************************************************************/

#include <arch/zxn.h>
#include <arch/zxn/color.h>
#include <input.h>
#include <z80.h>
#include <intrinsic.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "globals.h"
#include "bank.h"
#include "layer2.h"
#include "ula.h"
#include "font.h"
#include "sprites.h"
#include "tiles.h"
#include "tilemap.h"
#include "dma.h"

/*
 * Define IDE_FRIENDLY in your C IDE to disable Z88DK C extensions and avoid
 * parser errors/warnings in the IDE. Do NOT define IDE_FRIENDLY when compiling
 * the code with Z88DK.
 */
#ifdef IDE_FRIENDLY
#define __z88dk_fastcall
#define __preserves_regs(...)
#endif

/*******************************************************************************
 * Function Prototypes
 ******************************************************************************/

static void hardware_init(void);

static void isr_init(void);

static void create_background(void);

/*******************************************************************************
 * Type Definitions
 ******************************************************************************/

/*******************************************************************************
 * Variables
 ******************************************************************************/

static uint8_t buf_256[256];

static int key = 0;
static uint8_t direction = 0;

/*******************************************************************************
 * Functions
 ******************************************************************************/

static void hardware_init(void)
{
	// Make sure the Spectrum ROM is paged in initially.
	IO_7FFD = IO_7FFD_ROM0;

    // Put Z80 in 28 MHz turbo mode.
    ZXN_NEXTREG(REG_TURBO_MODE, RTM_28MHZ);

    // Disable RAM memory contention.
    ZXN_NEXTREGA(REG_PERIPHERAL_3, ZXN_READ_REG(REG_PERIPHERAL_3) | RP3_DISABLE_CONTENTION);
	
	ZXN_NEXTREG(REG_PALETTE_CONTROL, 0);
	ZXN_NEXTREG(REG_PALETTE_INDEX, 24);
	ZXN_NEXTREG(REG_PALETTE_VALUE_8, ZXN_RGB332_ZX_BRIGHT_MAGENTA);
	
	ZXN_NEXTREG(REG_TILEMAP_TRANSPARENCY_INDEX, 0);
	ZXN_NEXTREG(REG_GLOBAL_TRANSPARENCY_COLOR, ZXN_RGB332_ZX_BRIGHT_MAGENTA);
	ZXN_NEXTREG(REG_SPRITE_TRANSPARENCY_INDEX, ZXN_RGB332_ZX_BRIGHT_MAGENTA);
	
	ZXN_NEXTREGA(REG_SPRITE_LAYER_SYSTEM, RSLS_LAYER_PRIORITY_USL | RSLS_SPRITES_OVER_BORDER | RSLS_SPRITES_VISIBLE);
	
	ZXN_NEXTREG(REG_LAYER_2_RAM_PAGE, PAGE_LAYER2);
	
	IO_LAYER_2_CONFIG = IL2C_SHOW_LAYER_2;
	
	ZXN_NEXTREG(REG_CLIP_WINDOW_LAYER_2, 1);
	ZXN_NEXTREG(REG_CLIP_WINDOW_LAYER_2, 254);
	ZXN_NEXTREG(REG_CLIP_WINDOW_LAYER_2, 1);
	ZXN_NEXTREG(REG_CLIP_WINDOW_LAYER_2, 254);
	
	ZXN_NEXTREG(REG_LAYER_2_OFFSET_X_H, 0);
	ZXN_NEXTREG(REG_LAYER_2_OFFSET_X, 0);
	ZXN_NEXTREG(REG_LAYER_2_OFFSET_Y, 0);

	//ZXN_NEXTREG(REG_ULA_CONTROL, 0x80);
	
#if (SCREEN_RES == RES_256x192)
	ZXN_NEXTREG(REG_LAYER_2_CONTROL, LAYER_2_256x192x8);
#elif (SCREEN_RES == RES_320x256)
	ZXN_NEXTREG(REG_LAYER_2_CONTROL, LAYER_2_320x256x8);
#elif (SCREEN_RES == RES_640x256)
	ZXN_NEXTREG(REG_LAYER_2_CONTROL, LAYER_2_640x256x4);
#endif
}

static void isr_init(void)
{
	// Set up IM2 interrupt service routine:
	// Put Z80 in IM2 mode with a 257-byte interrupt vector table located
	// at 0x6000 (before CRT_ORG_CODE) filled with 0x61 bytes. Install an
	// empty interrupt service routine at the interrupt service routine
	// entry at address 0x8181.

#if (CRT_6000 == 1)
	intrinsic_di();
	im2_init((void *) 0x6000);
	memset((void *) 0x6000, 0x61, 257);
	z80_bpoke(0x6161, 0xFB);
	z80_bpoke(0x6162, 0xED);
	z80_bpoke(0x6163, 0x4D);
	intrinsic_ei();
#else
	intrinsic_di();
	im2_init((void *) 0x8000);
	memset((void *) 0x8000, 0x81, 257);
	z80_bpoke(0x8181, 0xFB);
	z80_bpoke(0x8182, 0xED);
	z80_bpoke(0x8183, 0x4D);
	intrinsic_ei();
#endif
}

static void background_create(void)
{
	zx_cls(INK_WHITE | PAPER_BLACK | BRIGHT);
}

uint8_t *screen_get_addr(uint8_t x, uint8_t y)
{
	IO_LAYER_2_CONFIG = (y & 0xC0) | IL2C_ENABLE_LOWER_16K | IL2C_SHOW_LAYER_2;
	
	return (uint8_t *)(((y & 0x3F) << 8) | x);
}

int main(void)
{
	hardware_init();
	isr_init();
	background_create();
	layer2_clear_screen(0);
	sprites_clear();

	layer2_set_palette((const uint16_t *)&tiles_nxp, 128, 0);
	layer2_set_palette((const uint16_t *)&tiles_nxp + 128, 128, 128);

	l2_map_tiles_x = 100;
	l2_map_tiles_y = 80;
	l2_map_data = (uint16_t *)&tiles_nxm;
	
	layer2_tilemap_update();
	
    while (true)
    {
		wait_vblank();
		zx_border(INK_RED);
		
		key = in_inkey();
		
#if (USE_ASM_VERSION == 0)
		switch(key)
		{
		case 'a': // Left
			if (l2_offset_x > 0)
			{
				l2_offset_tile_x = 0;
				layer2_tilemap_update_column();
				
				l2_offset_x--;
				layer2_tilemap_scroll_update();
			} 
			break;
		case 'd': // Right
			if (l2_offset_x < (l2_map_tiles_x * TILE_X) - SCREEN_X - 1)
			{
				l2_offset_tile_x = SCREEN_TILES_X;
				layer2_tilemap_update_column();
				
				l2_offset_x++;
				layer2_tilemap_scroll_update();
			}
			break;
		case 'w': // Up
			if (l2_offset_y > 0)
			{
				l2_offset_tile_y = 0;
				layer2_tilemap_update_row();

				l2_offset_y--;
				layer2_tilemap_scroll_update();
			}
			break;
		case 's': // Down
			if (l2_offset_y < (l2_map_tiles_y * TILE_Y) - SCREEN_Y - 1)
			{
				l2_offset_tile_y = SCREEN_TILES_Y;
				layer2_tilemap_update_row();
		
				l2_offset_y++;
				layer2_tilemap_scroll_update();
			}
			break;
		case 'r': // Refresh
			layer2_clear_screen(0);
			layer2_tilemap_update();
			break;
		}
#endif

#if (USE_ASM_VERSION == 1)
	switch(key)
		{
		case 'a': // Left
			layer2_tilemap_scroll_left();
			break;
		case 'd': // Right
			layer2_tilemap_scroll_right();
			break;
		case 'w': // Up
			layer2_tilemap_scroll_up();
			break;
		case 's': // Down
			layer2_tilemap_scroll_down();
			break;
		case 'r': // Refresh
			layer2_clear_screen(0);
			layer2_tilemap_update();
			break;
		}
#endif

		zx_border(INK_BLACK);
    }

    // Trig a soft reset. The Next hardware registers and I/O ports will be reset by NextZXOS after a soft reset.
    ZXN_NEXTREG(REG_RESET, RR_SOFT_RESET);
    return 0;
}
