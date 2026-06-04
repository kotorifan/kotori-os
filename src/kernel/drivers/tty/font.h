// tty.h
#include <stdint.h>
#include <limine.h>

#define PSF_MAGIC_NUM 0x0436
#define FONT_SCALE 3

// requires the unscii font in ./other/unscii.psf
// to be linked to the kernel binary
extern const uint8_t _binary___other_unscii_psf_start[];
extern const uint8_t _binary___other_unscii_psf_end[];

extern volatile struct limine_framebuffer_request framebuffer_request;
extern struct limine_framebuffer* fb;

typedef struct {
	uint16_t magic;
	uint8_t mode;
	uint8_t charsize;
} __attribute__((packed)) psf1_font_header_t;

typedef struct {
	psf1_font_header_t* header;
	uint8_t* glyphs;
	uint16_t num_glyphs;
	uint8_t width, height;
}  psf1_font_t;

static uint64_t fb_pitch_pixels;

static inline void init_font(psf1_font_t* font)
{

	if(!fb || !fb->address) return;
	fb_pitch_pixels = fb->pitch/4;

	font->header = (psf1_font_header_t*)_binary___other_unscii_psf_start;

	if(font->header->magic != PSF_MAGIC_NUM) return;

	font->width = 8;
	font->height = font->header->charsize;
	font->num_glyphs = (font->header->mode & 1) ? 512 : 256;
	font->glyphs = (uint8_t*)(_binary___other_unscii_psf_start + 4);
}

// add boundary checking
static void limine_putpixel(uint32_t pos_x, uint32_t pos_y, uint32_t color) 
{
    if((pos_x < fb->width) && (pos_y < fb->height)) {
		uint32_t* fb_addr = (uint32_t*)fb->address;
		fb_addr[pos_y * fb_pitch_pixels + pos_x] = color;
	}
}

static inline void limine_putblock(uint32_t pos_x, uint32_t pos_y, uint32_t scale, uint32_t color)
{
	for(uint32_t i = 0; i < scale; i++) {
		for(uint32_t j = 0; j < scale; j++) {
			// Draws to the linear framebuffer
			limine_putpixel(pos_x + i, pos_y + j, color);
		}
	}
}

static inline void tty_putchar(psf1_font_t* font,
							  uint32_t c,
							  uint32_t pos_x,
							  uint32_t pos_y,
							  uint32_t fg,
							  uint32_t bg)
{
	if(!font || !font->glyphs) return;
	if(c >= font->num_glyphs) c = 0;
	
	uint8_t* glyph = font->glyphs + (c * font->height);
	for(uint32_t row = 0; row < font->header->charsize; row++) {
		uint8_t bits = glyph[row];
		for(uint32_t col = 0; col < 8; col++) {
			limine_putblock(
			   pos_x + col * FONT_SCALE,
			   pos_y + row * FONT_SCALE,
			   FONT_SCALE,
			   (bits & (0x80 >> col)) ? fg : bg
			);
		}
	}
	
}



