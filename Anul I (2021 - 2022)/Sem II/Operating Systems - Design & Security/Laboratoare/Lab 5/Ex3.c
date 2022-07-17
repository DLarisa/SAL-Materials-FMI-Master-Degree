#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <x86intrin.h>
#include <setjmp.h>
#include <signal.h>

sigjmp_buf _jmp;

struct gdt_desc
{
	unsigned short limit;
	unsigned int base;
} __attribute__((packed));

void store_gdt_desc(struct gdt_desc *location) 
{
	asm volatile ("sidt %0" : : "m"(*location) : "memory");
}

unsigned long inl_gdt(unsigned long gdt_mem_base)
{
	__asm__ __volatile__("sidt %0":"=m"(gdt_mem_base)::"memory");
	return gdt_mem_base;
}

void sigsegv_handler()
{
	siglongjmp(_jmp, 1);
}

int main() 
{
	char * p = inl_gdt;
	signal(SIGSEGV, sigsegv_handler);
	if (sigsetjmp(_jmp, 1) == 0)
	{
		printf("first branch.\n");
		char kd = *p;
	}
	else
	{
		printf("SIGSEGV\n");
	}
	printf("Program still alive with stolen secret.\n");
	
	//return 0;
}