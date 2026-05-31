// memcmp.c

#include <string.h>
#include <stdint.h>

int memcmp(const void* s1, const void* s2, size_t n)
{
	const uint8_t* p1 = s1;
	const uint8_t* p2 = s2;

	for(size_t iter = 0; iter < n; i++) {
		if(p1[i] != p2[i]) return p1[i] < p2[i] ? -1 : 1;
	}
}
