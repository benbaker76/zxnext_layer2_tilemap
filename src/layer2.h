#ifndef _LAYER2_H
#define _LAYER2_H

#include <stdint.h>
#include <stdbool.h>

#define LAYER_2_256x192x8		0x00
#define LAYER_2_320x256x8		0x10
#define LAYER_2_640x256x4		0x20

#define REG_LAYER_2_CONTROL  	0x70
#define REG_LAYER_2_OFFSET_X_H  0x71

extern uint16_t l2_offset_x;
extern uint16_t l2_offset_y;
extern uint8_t l2_offset_tile_x;
extern uint8_t l2_offset_tile_y;
extern uint16_t l2_offset_pixel_x;
extern uint16_t l2_offset_pixel_y;
extern uint16_t *l2_map_data;
extern uint8_t l2_map_tiles_x;
extern uint8_t l2_map_tiles_y;
extern uint16_t l2_map_offset_x;
extern uint16_t l2_map_offset_y;
extern uint16_t l2_map_offset;
extern uint16_t l2_map_index;
extern uint16_t l2_screen_tile_x;
extern uint16_t l2_screen_tile_y;
extern uint16_t l2_screen_x;
extern uint16_t l2_screen_y;
extern uint8_t l2_screen_bank;
extern uint8_t l2_screen_start_page;
extern uint8_t l2_screen_page;
extern uint16_t l2_screen_index_x;
extern uint8_t l2_screen_index_y;
extern uint8_t *l2_map_address;
extern uint8_t *l2_tiles_address;
extern uint8_t *l2_screen_address;
extern uint8_t l2_tile_pixel_x;
extern uint8_t l2_tile_pixel_y;
extern uint8_t l2_tile_x;
extern uint8_t l2_tile_y;
extern uint16_t l2_tile_data;
extern uint8_t l2_tile_id;
extern uint8_t l2_tile_page;
extern uint8_t l2_tile_attribs;
extern uint16_t l2_tile_index;
extern uint16_t l2_tile_offset;

extern void layer2_tilemap_draw_tile(uint8_t tile_id, uint8_t tile_attribs, void *dst, void *src);
extern void layer2_tilemap_draw_column(uint8_t pixel_x, uint8_t tile_attribs, void *dst, void *src);
extern void layer2_tilemap_draw_row(uint8_t pixel_y, uint8_t tile_attribs, void *dst, void *src);

//extern void layer2_tilemap_draw_tile(uint8_t tile_id, uint8_t tile_attribs, void *dst, void *src);
//extern void layer2_tilemap_draw_column(uint8_t pixel_x, uint8_t tile_attribs, void *dst, void *src);
//extern void layer2_tilemap_draw_row(uint8_t pixel_y, uint8_t tile_attribs, void *dst, void *src);

void layer2_set_palette(const uint16_t *colors, uint16_t length, uint8_t palette_index);
void layer2_draw_char(uint16_t x, uint16_t y, char ch, uint8_t color);
void layer2_draw_text(uint8_t row, uint8_t column, const char *text, uint8_t color);
void layer2_set_screen(char *p_image, uint8_t image_bank, uint8_t image_page);
void layer2_clear_screen(uint8_t value);
// uint16_t offset_x, uint16_t offset_y, uint8_t map_tiles_x, uint8_t map_tiles_y
extern void layer2_tile_get_offset();
extern void layer2_tilemap_update_column();
extern void layer2_tilemap_update_row();
extern void layer2_tilemap_update();
void layer2_tilemap_update_edges();
void layer2_tilemap_scroll_update();
void layer2_tilemap_scroll_left();
void layer2_tilemap_scroll_right();
void layer2_tilemap_scroll_up();
void layer2_tilemap_scroll_down();

#endif
