// ps2kdb.c
#include <drivers/ps2kbd/scancode_tables.h>
#include <stdbool.h>
#include <interrupts/int.h>
#include <drivers/ps2kbd/ps2kbd.h>
#include <drivers/tty/tty.h>
#include <drivers/serial/serial.h>

#define KEYBD_BUFFER_SIZE_MAX 255
#define IRQ1 33

void code2screen(const uint8_t scancode, const bool shifted)
{
	if(scancode >= SCANCODE_LEN(scancodes)) return;
	char c =  shifted ? scancodes[scancode].letter_up
		: scancodes[scancode].letter_low;
	char str[2]= {c, '\0'};	  
	kwrite(str);
}

void keyb_callback(const cpu_state_t* cpu_state __attribute__((unused)))
{
	const uint8_t scancode = _inb(0x60);
	code2screen(scancode, false);
}

void keyb_init(void)
{
	register_int_handler(IRQ1, keyb_callback);
}
