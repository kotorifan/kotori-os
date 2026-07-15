#pragma once
#include <drivers/ps2kbd/scancode_tables.h>
#include <stdbool.h>
#include <interrupts/int.h>
#include <drivers/tty/tty.h>
#include <drivers/serial/serial.h>

void code2screen(const uint8_t scancode, const bool shifted);
void keyb_callback(const cpu_state_t* cpu_state __attribute__((unused)));
void keyb_init(void);
