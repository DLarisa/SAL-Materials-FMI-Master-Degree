#include <stdio.h>
#include <time.h>
#include <x86intrin.h>

// invalidate cache from CPU
static inline void clflush(volatile void *p) 
{
	asm volatile("clflush %0" : "+m" (*(volatile char *)p));
}

int main()
{
	int array[1000000];
	int i, j, sum = 0;
	for(i = 0; i < 1000000; i++) 
	{
		array[i] = 1;
		clflush(&array[i]); // we invalidate them from the cache
	}
	
	// First Scenario
	clock_t t;
    t = clock();
	for(j = 0; j < 1024; j++)
		for(i = 0; i < 1000000; i++) sum += array[i];
	t = clock() - t;
	double time_taken = ((double)t)/CLOCKS_PER_SEC; // in seconds
	printf("Sum: %d\n", sum);
	printf("Seconds First Scenario: %f \n", time_taken);
	
	// Second Scenario
	sum = 0;
	clock_t y;
    y = clock();
	for(j = 0; j < 1024; j++)
		for(i = 0; i < 1000000; i++) 
		{
			sum += array[i];
			clflush(&array[i]);
		}
	y = clock() - y;
	double time = ((double)y)/CLOCKS_PER_SEC; // in seconds
	printf("Sum: %d\n", sum);
	printf("Seconds Second Scenario: %f \n", time);
	
	return 0;
}