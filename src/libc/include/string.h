#pragma once

#include <sys/cdefs.h>
#include <stddef.h>

int memcmp(const void*, const void*, size_t);
void* memmove(void*, const void*, size_t);
void* memset(void*, int, size_t);
