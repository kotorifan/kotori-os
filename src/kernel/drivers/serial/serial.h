// serial.h
#pragma once

#include <stdint.h>

extern void _outb(uint16_t port, uint8_t value);
extern uint8_t _inb(uint16_t port);

uint32_t init_serial();
char read_serialc();
void write_serialc(const char data);
void write_serial(const char* data);
