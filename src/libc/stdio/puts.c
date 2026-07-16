// puts.c
#include <drivers/tty/tty.h>
#include <stdio.h>

int puts(const char* data)
{
	kwrite(data);
	kwrite("\n");
	return 0;
}