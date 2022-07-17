#include <stdlib.h>
#include <stdio.h>

void func()
{
	char buffer[128];
	gets(buffer);
	//dup2(1,0);
}

int main(int argc, char *argv[])
{
	int n = 0;
	while (n < 10);
	func();
	return 0;
}