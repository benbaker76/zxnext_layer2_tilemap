#include "layer2.h"
#include <arch/zxn.h>
#include <arch/zxn/color.h>
#include <intrinsic.h>
#include <z80.h>
#include <string.h>
#include "font.h"
#include "bank.h"
#include "dma.h"
#include "globals.h"
#include "tilemap.h"
#include "tiles.h"
#include "math.h"

inline uint16_t fast_mod(uint16_t x, uint16_t n)
{
	return ((x & (x - 1)) == 0 ? x & (n - 1) : x % n);
}

void layer2_set_palette(const uint16_t *colors, uint16_t length, uint8_t palette_index)
{
    uint8_t *color_bytes = (uint8_t *) colors;
    uint16_t i;

    if ((colors == NULL) || (length == 0))
    {
        return;
    }

    if (palette_index + length > 256)
    {
        length = 256 - palette_index;
    }

	IO_NEXTREG_REG = REG_PALETTE_CONTROL;
    IO_NEXTREG_DAT = (IO_NEXTREG_DAT & 0xFB) | 0x04;
	
    IO_NEXTREG_REG = REG_PALETTE_CONTROL;
    IO_NEXTREG_DAT = (IO_NEXTREG_DAT & 0x8F) | 0x50;

    IO_NEXTREG_REG = REG_PALETTE_INDEX;
    IO_NEXTREG_DAT = palette_index;

    IO_NEXTREG_REG = REG_PALETTE_VALUE_16;

    for (i = 0; i < (length << 1); i++)
    {
        IO_NEXTREG_DAT = color_bytes[i];
    }
}

void layer2_print_char(uint8_t x, uint8_t y, char ch, uint8_t color)
{
	uint8_t px, py;
	uint8_t screen_start_page = ZXN_READ_REG(REG_LAYER_2_RAM_PAGE);
	uint8_t screen_current_page = screen_start_page;
	uint8_t *screen_address = (uint8_t *)zxn_addr_from_mmu(MMU_LAYER2);
	uint16_t screen_x = x * TILE_X;
	uint16_t screen_y = y * TILE_Y;
#if (SCREEN_RES == RES_256x192)
	uint8_t screen_bank = (screen_y % SCREEN_Y) / SCREEN_BANK_Y;
	uint8_t screen_page = screen_start_page + screen_bank;
#elif (SCREEN_RES == RES_320x256)
	uint8_t screen_bank = (screen_x % SCREEN_X) / SCREEN_BANK_X;
	uint8_t screen_page = screen_start_page + screen_bank;
#endif
				
	if (screen_current_page != screen_page)
	{
		screen_current_page = screen_page;
		bank_set_16k(MMU_LAYER2, screen_current_page);
	}
	
	for (py = 0; py < TILE_Y; py++)
	{
		for (px = 0; px < TILE_X; px++)
		{
			uint16_t font_index = (ch - 32) * TILE_Y + py;
#if (SCREEN_RES == RES_256x192)
			uint16_t screen_index_x = (screen_x + px) % SCREEN_X;
			uint16_t screen_index_y = ((screen_y + py) % SCREEN_BANK_Y) * SCREEN_X;
#elif (SCREEN_RES == RES_320x256)
			uint16_t screen_index_x = ((screen_x + px) % SCREEN_BANK_X) * SCREEN_Y;
			uint16_t screen_index_y = (screen_y + py) % SCREEN_Y;
#endif

			screen_address[screen_index_x + screen_index_y] = (font_spr[font_index] >> (7 - px) & 1 ? color : ZXN_RGB332_ZX_BRIGHT_MAGENTA);
		}
	}
}

void layer2_print_number(uint8_t x, uint8_t y, uint16_t num, uint8_t color)
{
	uint8_t text[5]; 
	uint8_t i = 0, j;

	while (num != 0)
	{ 
		text[i++] = (num % 10) + 48;
		num = num / 10; 
	} 

	for (j = 0; j < i; j++)
	{
		layer2_print_char(x + j, y, text[i - j - 1], color);
	}
}

void layer2_draw_char(uint16_t x, uint16_t y, char ch, uint8_t color)
{
	bank_set_16k(MMU_FONT, PAGE_FONT);
	
	uint8_t lines = 8;
	uint8_t *font_address = font_spr + ((ch - 32) << 3);
	uint8_t screen_page = ZXN_READ_REG(REG_LAYER_2_RAM_PAGE);
	uint8_t *screen_address = (uint8_t *)zxn_addr_from_mmu(MMU_LAYER2);
	
	if ((x >= SCREEN_X) || (y >= SCREEN_Y))
	{
		return;
	}

#if (SCREEN_RES == RES_256x192)
	screen_address += x + (y % 64) * SCREEN_X;
	bank_set_16k(MMU_LAYER2, screen_page + (y >> 6));
#elif (SCREEN_RES == RES_320x256)
	screen_address += y + (x % 64) * SCREEN_Y;
	bank_set_16k(MMU_LAYER2, screen_page + (x >> 6));
#endif	

	while (lines--)
	{
		for (uint8_t i = 0; i < 8; i++)
		{
			uint8_t bit = *font_address & (0x80 >> i);
			z80_bpoke(screen_address + i * SCREEN_Y, bit != 0 ? color : ZXN_RGB332_ZX_BRIGHT_MAGENTA);
		}

#if (SCREEN_RES == RES_256x192)
		screen_address += SCREEN_X;
#elif (SCREEN_RES == RES_320x256)
		screen_address++;
#endif	
		font_address++;
	}
}

void layer2_draw_text(uint8_t row, uint8_t column, const char *text, uint8_t color)
{
	uint16_t x = (column << 3);
	uint16_t y = (row << 3);
	char *str = (char *) text;

	if (text == NULL)
	{
		return;
	}

	while (*str != '\0')
	{
		char ch = *str;
		if ((ch < 32) || (ch > 127))
		{
			ch = '?';
		}

		layer2_draw_char(x, y, ch, color);
		
		x += 8;
		str++;
	}
}

void layer2_set_screen(char *p_image, uint8_t image_bank, uint8_t image_page)
{
	void *screen_address = (void *) zxn_addr_from_mmu(MMU_LAYER2);
	uint8_t screen_page = ZXN_READ_REG(REG_LAYER_2_RAM_PAGE);
	uint8_t old_page = bank_set_16k(image_bank, image_page);
	
#if (SCREEN_X == RES_256x192)
	for (uint8_t i = 0; i < 3; i++)
#else
	for (uint8_t i = 0; i < 5; i++)
#endif
	{
		bank_set_16k(image_bank, image_page + i);
		bank_set_16k(MMU_LAYER2, screen_page + i);
		memcpy(screen_address, (void *)p_image[i], BANKSIZE_16K);
	}

	bank_set_16k(image_bank, old_page);
}

void layer2_clear_screen(uint8_t value)
{
	void *screen_address = (void *)zxn_addr_from_mmu(MMU_LAYER2);
#if (SCREEN_RES == RES_256x192)
	for (uint8_t i = 0; i < 3; i++)
#else
	for (uint8_t i = 0; i < 5; i++)
#endif
	{
		bank_set_16k(MMU_LAYER2, PAGE_LAYER2 + i);
		dma_fill(screen_address, value, BANKSIZE_16K);
	}
}

#if (USE_ASM_VERSION == 0)

#if (SCREEN_RES == RES_256x192)
void layer2_tile_get_offset_flip()
#elif (SCREEN_RES == RES_320x256)
void layer2_tile_get_offset()
#endif
{
	switch (l2_tile_attribs)
	{
	case 0:
		l2_tile_offset = (l2_tile_pixel_y << 3) + l2_tile_pixel_x; // 0
		break;
	case TILEMAP_ATTRIBUTE_Y_MIRROR:
		l2_tile_offset = ((TILE_Y - l2_tile_pixel_y) << 3) + l2_tile_pixel_x - TILE_X; // 1
		break;
	case TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR:
		l2_tile_offset = ((TILE_Y - l2_tile_pixel_y) << 3) - l2_tile_pixel_x - 1; // 2
		break;
	case TILEMAP_ATTRIBUTE_X_MIRROR:
		l2_tile_offset = (l2_tile_pixel_y << 3) - l2_tile_pixel_x + (TILE_X - 1); // 3
		break;
	case TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR:
		l2_tile_offset = (l2_tile_pixel_x << 3) + l2_tile_pixel_y; // 4
		break;
	case TILEMAP_ATTRIBUTE_ROTATE:
		l2_tile_offset = ((TILE_X - l2_tile_pixel_x) << 3) + l2_tile_pixel_y - TILE_Y; // 5
		break;
	case TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR:
		l2_tile_offset = (l2_tile_pixel_x << 3) - l2_tile_pixel_y + (TILE_Y - 1); // 6
		break;
	case TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_Y_MIRROR:
		l2_tile_offset = ((TILE_X - l2_tile_pixel_x) << 3) - l2_tile_pixel_y - 1; // 7
		break;
	}
}

#if (SCREEN_RES == RES_256x192)
void layer2_tile_get_offset()
#elif (SCREEN_RES == RES_320x256)
void layer2_tile_get_offset_flip()
#endif
{
	switch (l2_tile_attribs)
	{
	case 0:
		l2_tile_offset = (l2_tile_pixel_x << 3) + l2_tile_pixel_y; // 4
		break;
	case TILEMAP_ATTRIBUTE_Y_MIRROR:
		l2_tile_offset = ((TILE_X - l2_tile_pixel_x) << 3) + l2_tile_pixel_y - TILE_Y; // 5
		break;
	case TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR:
		l2_tile_offset = ((TILE_X - l2_tile_pixel_x) << 3) - l2_tile_pixel_y - 1; // 7
		break;
	case TILEMAP_ATTRIBUTE_X_MIRROR:
		l2_tile_offset = (l2_tile_pixel_x << 3) - l2_tile_pixel_y + (TILE_Y - 1); // 6
		break;
	case TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR:
		l2_tile_offset = (l2_tile_pixel_y << 3) + l2_tile_pixel_x; // 0
		break;
	case TILEMAP_ATTRIBUTE_ROTATE:
		l2_tile_offset = ((TILE_Y - l2_tile_pixel_y) << 3) + l2_tile_pixel_x - TILE_X; // 1
		break;
	case TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_X_MIRROR | TILEMAP_ATTRIBUTE_Y_MIRROR:
		l2_tile_offset = (l2_tile_pixel_y << 3) - l2_tile_pixel_x + (TILE_X - 1); // 3
		break;
	case TILEMAP_ATTRIBUTE_ROTATE | TILEMAP_ATTRIBUTE_Y_MIRROR:
		l2_tile_offset = ((TILE_Y - l2_tile_pixel_y) << 3) - l2_tile_pixel_x - 1; // 2
		break;
	}
}

void layer2_tilemap_update_column()
{
	l2_offset_pixel_x = (l2_offset_x & 7);
	l2_offset_pixel_y = (l2_offset_y & 7);
	l2_map_offset_x = (l2_offset_x >> 3);
	l2_map_offset_y = (l2_offset_y >> 3);
#if (MAP_Y_FIRST == 1)
	l2_map_offset = l2_map_offset_y + l2_map_tiles_y * l2_map_offset_x;
#else
	l2_map_offset = l2_map_offset_y * l2_map_tiles_x + l2_map_offset_x;
#endif
		
	for (l2_screen_tile_y = 0; l2_screen_tile_y < SCREEN_TILES_Y + 1; l2_screen_tile_y++)
	{
		l2_screen_x = l2_offset_x;
		l2_screen_y = l2_offset_y + (l2_screen_tile_y << 3) - l2_offset_pixel_y;
		//tile_y = MIN(l2_offset_y + SCREEN_Y - l2_screen_y, TILE_Y);
		uint16_t temp = l2_offset_y + SCREEN_Y - TILE_Y - l2_screen_y;
		l2_tile_y = (temp >= 65536-TILE_Y) ? temp + TILE_Y : TILE_Y;

#if (SCREEN_RES == RES_256x192)
		l2_screen_bank = mod192(l2_screen_y) >> 6;
		//l2_screen_bank = (l2_screen_y % SCREEN_Y) >> 6;
#elif (SCREEN_RES == RES_320x256)
		l2_screen_bank = mod320(l2_screen_x) >> 6;
#endif
		l2_screen_page = l2_screen_start_page + l2_screen_bank;

#if (MAP_Y_FIRST == 1)
		l2_map_index = l2_screen_tile_y + l2_map_tiles_y * l2_offset_tile_x;
#else
		l2_map_index = l2_screen_tile_y * l2_map_tiles_x + l2_offset_tile_x;
#endif

		bank_set_16k(MMU_LAYER2_MAP, PAGE_LAYER2_MAP);

		l2_tile_data = l2_map_data[l2_map_offset + l2_map_index];
		l2_tile_id = l2_tile_data & 0xff;
		l2_tile_page = PAGE_LAYER2_TILES + ((l2_tile_data >> 8) & 0x1);
		l2_tile_attribs = (l2_tile_data >> 8) & 0xe;
		l2_tile_index = l2_tile_id << 6;

		bank_set_16k(MMU_LAYER2_TILES, l2_tile_page);
		bank_set_16k(MMU_LAYER2, l2_screen_page);

		if (l2_tile_y == TILE_Y)
		{
#if (SCREEN_RES == RES_256x192)
			l2_screen_index_x = l2_screen_x & 255;
			*(&l2_screen_index_y - 1) = l2_screen_y & 63;

			layer2_tilemap_draw_row(l2_offset_pixel_x, l2_tile_attribs, l2_screen_address + l2_screen_index_x + l2_screen_index_y, l2_tiles_address + l2_tile_index);
#elif (SCREEN_RES == RES_320x256)
			l2_screen_index_x = (l2_screen_x & 63) << 8;
			l2_screen_index_y = l2_screen_y & 255;

			layer2_tilemap_draw_column(l2_offset_pixel_x, l2_tile_attribs, l2_screen_address + l2_screen_index_x + l2_screen_index_y, l2_tiles_address + l2_tile_index);
#endif
		}
		else
		{
			l2_tile_pixel_x = l2_offset_pixel_x;

			for (l2_tile_pixel_y = 0; l2_tile_pixel_y < l2_tile_y; l2_tile_pixel_y++)
			{
#if (SCREEN_RES == RES_256x192)
				layer2_tile_get_offset_flip();
				l2_screen_index_x = l2_screen_x & 255;
				*(&l2_screen_index_y - 1) = (l2_screen_y +l2_tile_pixel_y) & 63;
#elif (SCREEN_RES == RES_320x256)
				layer2_tile_get_offset();
				l2_screen_index_x = (l2_screen_x & 63) << 8;
				l2_screen_index_y = (l2_screen_y + l2_tile_pixel_y) & 255;
#endif
				l2_screen_address[l2_screen_index_x + l2_screen_index_y] = l2_tiles_address[l2_tile_index + l2_tile_offset];
			}
		}
	}
}

void layer2_tilemap_update_row()
{
	l2_offset_pixel_x = (l2_offset_x & 7);
	l2_offset_pixel_y = (l2_offset_y & 7);
	l2_map_offset_x = (l2_offset_x >> 3);
	l2_map_offset_y = (l2_offset_y >> 3);
#if (MAP_Y_FIRST == 1)
	l2_map_offset = l2_map_offset_y + l2_map_tiles_y * l2_map_offset_x;
#else
	l2_map_offset = l2_map_offset_y * l2_map_tiles_x + l2_map_offset_x;
#endif

	for (l2_screen_tile_x = 0; l2_screen_tile_x < SCREEN_TILES_X + 1; l2_screen_tile_x++)
	{
		l2_screen_x = l2_offset_x + (l2_screen_tile_x << 3) - l2_offset_pixel_x;
		l2_screen_y = l2_offset_y;
		//l2_tile_x = MIN(l2_offset_x + SCREEN_X - l2_screen_x, TILE_X);
		uint16_t temp = l2_offset_x + SCREEN_X - TILE_X - l2_screen_x;
		l2_tile_x = (temp >= 65536-TILE_X) ? temp + TILE_X : TILE_X;

#if (SCREEN_RES == RES_256x192)
		//l2_screen_bank = (l2_screen_y % SCREEN_Y) >> 6;
		l2_screen_bank = mod192(l2_screen_y) >> 6;
#elif (SCREEN_RES == RES_320x256)
		l2_screen_bank = mod320(l2_screen_x) >> 6;
#endif
		l2_screen_page = l2_screen_start_page + l2_screen_bank;

#if (MAP_Y_FIRST == 1)
		l2_map_index = l2_offset_tile_y + l2_map_tiles_y * l2_screen_tile_x;
#else
		l2_map_index = l2_offset_tile_y * l2_map_tiles_x + l2_screen_tile_x;
#endif

		bank_set_16k(MMU_LAYER2_MAP, PAGE_LAYER2_MAP);

		l2_tile_data = l2_map_data[l2_map_offset + l2_map_index];
		l2_tile_id = l2_tile_data & 0xff;
		l2_tile_page = PAGE_LAYER2_TILES + ((l2_tile_data >> 8) & 0x1);
		l2_tile_attribs = (l2_tile_data >> 8) & 0xe;
		l2_tile_index = l2_tile_id << 6;

		bank_set_16k(MMU_LAYER2_TILES, l2_tile_page);
		bank_set_16k(MMU_LAYER2, l2_screen_page);

		if (l2_tile_x == TILE_X)
		{
#if (SCREEN_RES == RES_256x192)
			l2_screen_index_x = l2_screen_x & 255;
			*(&l2_screen_index_y - 1) = l2_screen_y & 63;

			layer2_tilemap_draw_column(l2_offset_pixel_y, l2_tile_attribs, l2_screen_address + l2_screen_index_x + l2_screen_index_y, l2_tiles_address + l2_tile_index);
#elif (SCREEN_RES == RES_320x256)
			l2_screen_index_x = (l2_screen_x & 63) << 8;
			l2_screen_index_y = l2_screen_y & 255;

			layer2_tilemap_draw_row(l2_offset_pixel_y, l2_tile_attribs, l2_screen_address + l2_screen_index_x + l2_screen_index_y, l2_tiles_address + l2_tile_index);
#endif
		}
		else
		{
			l2_tile_pixel_y = l2_offset_pixel_y;

			for (l2_tile_pixel_x = 0; l2_tile_pixel_x < l2_tile_x; l2_tile_pixel_x++)
			{
#if (SCREEN_RES == RES_256x192)
				layer2_tile_get_offset_flip();
				l2_screen_index_x = (l2_screen_x + l2_tile_pixel_x) & 255;
				*(&l2_screen_index_y - 1) = l2_screen_y & 63;
#elif (SCREEN_RES == RES_320x256)
				layer2_tile_get_offset();
				l2_screen_index_x = ((l2_screen_x + l2_tile_pixel_x) & 63) << 8;
				l2_screen_index_y = l2_screen_y & 255;
#endif
				l2_screen_address[l2_screen_index_x + l2_screen_index_y] = l2_tiles_address[l2_tile_index + l2_tile_offset];
			}
		}
	}
}

void layer2_tilemap_update()
{
	l2_offset_pixel_x = (l2_offset_x & 7);
	l2_offset_pixel_y = (l2_offset_y & 7);
	l2_map_offset_x = (l2_offset_x >> 3);
	l2_map_offset_y = (l2_offset_y >> 3);
#if (MAP_Y_FIRST == 1)
	l2_map_offset = l2_map_offset_y + l2_map_tiles_y * l2_map_offset_x;
#else
	l2_map_offset = l2_map_offset_y * l2_map_tiles_x + l2_map_offset_x;
#endif
	l2_map_address = (uint8_t *)zxn_addr_from_mmu(MMU_LAYER2_MAP);
	l2_tiles_address = (uint8_t *)zxn_addr_from_mmu(MMU_LAYER2_TILES);
	l2_screen_address = (uint8_t *)zxn_addr_from_mmu(MMU_LAYER2);

	for (l2_screen_tile_y = 0; l2_screen_tile_y < SCREEN_TILES_Y + 1; l2_screen_tile_y++)
	{
		for (l2_screen_tile_x = 0; l2_screen_tile_x < SCREEN_TILES_X + 1; l2_screen_tile_x++)
		{
			l2_screen_x = l2_offset_x + (l2_screen_tile_x << 3) - l2_offset_pixel_x;
			l2_screen_y = l2_offset_y + (l2_screen_tile_y << 3) - l2_offset_pixel_y;

			//l2_tile_x = MIN(l2_offset_x + SCREEN_X - l2_screen_x, TILE_X);
			//l2_tile_y = MIN(l2_offset_y + SCREEN_Y - l2_screen_y, TILE_Y);

			uint16_t temp = l2_offset_x + SCREEN_X - TILE_X - l2_screen_x;
  			l2_tile_x = (temp >= 65536-TILE_X) ? temp + TILE_X : TILE_X;

			temp = l2_offset_y + SCREEN_Y - TILE_Y - l2_screen_y;
  			l2_tile_y = (temp >= 65536-TILE_Y) ? temp + TILE_Y : TILE_Y;

#if (SCREEN_RES == RES_256x192)
			//l2_screen_bank = (l2_screen_y % SCREEN_Y) >> 6;
			l2_screen_bank = mod192(l2_screen_y) >> 6;
#elif (SCREEN_RES == RES_320x256)
			l2_screen_bank = mod320(l2_screen_x) >> 6;
#endif
			l2_screen_page = l2_screen_start_page + l2_screen_bank;
		
#if (MAP_Y_FIRST == 1)
			l2_map_index = l2_screen_tile_y + l2_map_tiles_y * l2_screen_tile_x;
#else
			l2_map_index = l2_screen_tile_y * l2_map_tiles_x + l2_screen_tile_x;
#endif

			bank_set_16k(MMU_LAYER2_MAP, PAGE_LAYER2_MAP);

			l2_tile_data = l2_map_data[l2_map_offset + l2_map_index];
			l2_tile_id = l2_tile_data & 0xff;
			l2_tile_page = PAGE_LAYER2_TILES + ((l2_tile_data >> 8) & 0x1);
			l2_tile_attribs = (l2_tile_data >> 8) & 0xe;
			l2_tile_index = l2_tile_id << 6;

			bank_set_16k(MMU_LAYER2_TILES, l2_tile_page);
			bank_set_16k(MMU_LAYER2, l2_screen_page);

			if ((l2_tile_x & l2_tile_y) >> 3)
			{
#if (SCREEN_RES == RES_256x192)
				l2_screen_index_x = l2_screen_x & 255;
				*(&l2_screen_index_y - 1) = l2_screen_y & 63;
#elif (SCREEN_RES == RES_320x256)
				l2_screen_index_x = (l2_screen_x & 63) << 8;
				l2_screen_index_y = l2_screen_y & 255;
#endif

				layer2_tilemap_draw_tile(l2_tile_id, l2_tile_attribs, l2_screen_address + l2_screen_index_x + l2_screen_index_y, l2_tiles_address + l2_tile_index);
			}
			else
			{
				for (l2_tile_pixel_y = 0; l2_tile_pixel_y < l2_tile_y; l2_tile_pixel_y++)
				{
					for (l2_tile_pixel_x = 0; l2_tile_pixel_x < l2_tile_x; l2_tile_pixel_x++)
					{
#if (SCREEN_RES == RES_256x192)
						layer2_tile_get_offset_flip();
						l2_screen_index_x = (l2_screen_x + l2_tile_pixel_x) & 255;
						*(&l2_screen_index_y - 1) = (l2_screen_y + l2_tile_pixel_y) & 63;
#elif (SCREEN_RES == RES_320x256)
						layer2_tile_get_offset();
						l2_screen_index_x = ((l2_screen_x + l2_tile_pixel_x) & 63) << 8;
						l2_screen_index_y = (l2_screen_y + l2_tile_pixel_y) & 255;
#endif
						l2_screen_address[l2_screen_index_x + l2_screen_index_y] = l2_tiles_address[l2_tile_index + l2_tile_offset];
					}
				}
			}
		}
	}
}

void layer2_tilemap_update_edges()
{
	l2_offset_tile_x = 0;
	layer2_tilemap_update_column();		// Left
	l2_offset_tile_x = SCREEN_TILES_X;
	layer2_tilemap_update_column();		// Right
	l2_offset_tile_y = 0;
	layer2_tilemap_update_row();		// Up
	l2_offset_tile_y = SCREEN_TILES_Y;
	layer2_tilemap_update_row();		// Down
}

void layer2_tilemap_scroll_update()
{
 	ZXN_WRITE_REG(REG_LAYER_2_OFFSET_X_H, l2_offset_x >> 8);
	ZXN_WRITE_REG(REG_LAYER_2_OFFSET_X, l2_offset_x);
#if (SCREEN_RES == RES_256x192)
	ZXN_WRITE_REG(REG_LAYER_2_OFFSET_Y, mod192(l2_offset_y));
#elif (SCREEN_RES == RES_320x256)
	ZXN_WRITE_REG(REG_LAYER_2_OFFSET_Y, l2_offset_y);
#endif
}

#endif