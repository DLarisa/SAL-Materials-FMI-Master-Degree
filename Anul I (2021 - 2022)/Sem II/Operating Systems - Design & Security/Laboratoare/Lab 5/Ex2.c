#include <stdio.h>
#include <stdlib.h>
#include <x86intrin.h>

// invalidate cache from CPU
static inline void clflush(volatile void *p) 
{
	asm volatile("clflush %0" : "+m" (*(volatile char *)p));
}

int main()
{
	char *array[256];
	int i, sum = 0;
	
	for(i = 0; i < 256; i++)
		array[i] = (char*)malloc(4096);
	for(i = 0; i < 256; i++)
		clflush(&array[i][1000]);
	
	array[11][1000] = 58;
	
	unsigned int dummy;
	unsigned long long t1, t2;
	for(i = 0; i < 256; i++)
	{
		t1 = __rdtscp(&dummy);
		sum += array[i][1000];
		t2 = __rdtscp(&dummy);
		printf("Time %d: %llu \n", i, t2 - t1);
	}
	
	return 0;
}