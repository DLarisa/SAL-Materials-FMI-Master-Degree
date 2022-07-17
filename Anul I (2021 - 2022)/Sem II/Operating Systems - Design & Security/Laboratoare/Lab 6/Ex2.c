// Getting a shell using machine code 
#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<sys/mman.h>

// Machine code for shell
char buffer[] = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";
	
int main()
{
	void *p = mmap(NULL, sizeof(buffer), PROT_READ | PROT_WRITE | PROT_EXEC, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
	if(p == MAP_FAILED) {
		perror("mmap");
		return 1;
	}
	memcpy(p, buffer, sizeof(buffer));
	((int(*)())p)();

	//unreachable code
	munmap(p, sizeof(buffer));
	return 0;
}