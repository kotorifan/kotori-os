#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <limine.h>

#include <string.h>

__attribute__((used, section(".limine_requests")))
static volatile uint64_t limine_base_revision[] = LIMINE_BASE_REVISION(6);

__attribute__((used, section(".limine_requests")))
static volatile struct limine_framebuffer_request framebuffer_request = {
    .id = LIMINE_FRAMEBUFFER_REQUEST_ID,
    .revision = 0
};

__attribute__((used, section(".limine_requests_start")))
static volatile uint64_t limine_requests_start_marker[] = LIMINE_REQUESTS_START_MARKER;

__attribute__((used, section(".limine_requests_end")))
static volatile uint64_t limine_requests_end_marker[] = LIMINE_REQUESTS_END_MARKER;


inline static void halt_catch_fire(void)
{
	for(;;) asm("hlt");
}

void kmain(void)
{
	// Ensure the bootloader understands our base revision
	if(LIMINE_BASE_REVISION_SUPPORTED(limine_base_revision) == false) {
		// Add errors here
		halt_catch_fire();
	}
	if(framebuffer_request.response == NULL || framebuffer_request.response->framebuffer_count < 1) {
		halt_catch_fire();
	}

	struct limine_framebuffer* fb = framebuffer_request.response->framebuffers[0];

	volatile int* fb_ptr = fb->address;
	for(size_t iter_y = 0; iter_y < fb->height; iter_y++) {
		for(size_t iter_x = 0; iter_x < fb->width; iter_x++) {
			uint32_t nX = iter_x * 255 / fb->width;
			uint32_t nY = iter_y * 255 / fb->height;
			fb_ptr[iter_y * (fb->pitch / 4) + iter_x] = (nY << 8) | nX;
		}
	}
	halt_catch_fire();
}
