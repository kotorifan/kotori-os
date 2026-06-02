// stdio.h
#pragma once

#include <stdint.h>

#define EOF (-1)

int printf(const char* __restrict, ...);
int putchar(uint32_t);
int puts(const char*);
