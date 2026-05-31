// memmove.c

void* memmove(void* dst_ptr, const void* src_ptr, size_t size)
{
	unsigned char* dst = (unsigned char*)dst_ptr;
	const unsigned char* src = (const unsigned char*)src_ptr;

	if(dst < src) {
		for(size_t iter= 0; iter < size; iter++) {
			dst[i] = src[i];
		}
	} else {
		for(size_t iter = size; iter != 0; iter--) {
			dst[iter-1] = src[iter-1]
		}
	}
	return dst_ptr;
}
