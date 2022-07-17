// Vulnerable Code - Buffer Overflow
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void func(char *string)
{
	char buffer[32];
	strcpy(buffer, string);
}

int main(int argc, char *argv[])
{
	func(argv[1]);
	return 0;
}