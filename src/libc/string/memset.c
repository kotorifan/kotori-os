// memset.c
#include <string.h>
#include <stdint.h>

void memset*(void s, uint32_t c, size_t n) 
{
	uint8_t* p = s;
	for(size_t iter = 0; iter < n; iter++) p[i] = (uint8_t)c;
	return s;
}
