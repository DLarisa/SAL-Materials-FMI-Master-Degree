#include <stdlib.h> 
#include <stdio.h> 
#include <string.h> 


// Practic 1
/*
	Called the program as follows: ./ex $(python -c 'print (136*"A")')
	Received the message: *** stack smashing detected ***: terminated
*/

// Practic 2
/*
	Called the program as follows: ./ex $(python -c 'print (136*"A")')
	Received Segmentation Fault, since the adress AAAA, cannot be executed.
*/


void func(char *string) 
{ 
 	char buffer[128];
	printf("%#010x\n", &buffer);

	strcpy(buffer, string);
} 

int main(int argc, char *argv[]) 
{
	func(argv[1]); 

	// // Compiled the code with: gcc -g -m32 -fno-stack-protector -z execstack -o ex ex.c
	// char code[] = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";
	// void (*exec_code)() = &code;
	// exec_code();

 	return 0; 
}

