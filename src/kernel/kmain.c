// kmain.c
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <limine.h>

#include <string.h>
#include <drivers/tty/tty.h>
#include <drivers/serial/serial.h>
#include <interrupts/int.h>

extern void _disable_int(void);
extern void _init_pic(void);

__attribute__((used, section(".limine_requests")))
static volatile uint64_t limine_base_revision[] = LIMINE_BASE_REVISION(6);

__attribute__((used, section(".limine_requests")))
volatile struct limine_framebuffer_request framebuffer_request = {
    .id = LIMINE_FRAMEBUFFER_REQUEST_ID,
    .revision = 0
};

__attribute__((used, section(".limine_requests_start")))
static volatile uint64_t limine_requests_start_marker[] = LIMINE_REQUESTS_START_MARKER;

__attribute__((used, section(".limine_requests_end")))
static volatile uint64_t limine_requests_end_marker[] = LIMINE_REQUESTS_END_MARKER;


inline static void halt_catch_fire(void)
{
	for(;;) asm volatile("pause");
}

struct limine_framebuffer* fb;

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
	fb = framebuffer_request.response->framebuffers[0];
	_disable_int();
	_init_pic();	
	idt_init(); // also enables interrupts
	font_init();
	tty_init();
	
	kwrite("Booted okay so far\n");
    halt_catch_fire();
}
