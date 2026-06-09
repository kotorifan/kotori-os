// serial.h
#pragma once

#include <stdint.h>

extern void _outb(uint16_t port, uint8_t value);
extern uint8_t _inb(uint16_t port);

uint32_t serial_init();
char serial_readc();
void serial_writec(const char data);
void serial_write(const char* data);
