// Create a loop in your program, to prevent it from ending
#include <stdio.h>

int main(int argc, char *argv[]) {
	while(1) {
		printf("Hello World!\n");
	}
	return 0;
}

/*  === COMENZI RULARE (Ubuntu for Windows 10): ===
	cd /mnt/c/Users/Larisa/Desktop --> ca să ajung pe Desktop
	
	Compilare:
	gcc Ex2.c -o ex2
	./ex2
	
	În paralel, aka într-un terminal nou (în timp ce rulează programul): 
		pidof ex2 (ne interesează doar primul PID)
		cat /proc/PID/maps
	
	Comandă (nu neapărat în timp ce rulează): ldd ex2
*/