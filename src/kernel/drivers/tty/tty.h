// tty.h
#include <stdint.h>
#include <limine.h>

extern const uint8_t _binary___other_unscii_pcf_start;
extern const uint8_t _binary___other_unscii_pcf_size;
extern const uint8_t _binary___other_unscii_pcf_end;

typedef struct {
	uint8_t width, height;
	uint16_t num_glyphs;
	uint8_t reserved[4];
	uint8_t glyphs[];
} psf1_font_t;


