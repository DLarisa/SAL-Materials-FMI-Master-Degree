#include <stdio.h>

long getfilesize(const char* fname)
{
	FILE* fp;
	fp = fopen(fname, "r");
	fseek(fp, 0, SEEK_END);
	long sz = ftell(fp);
	fclose(fp);
	return sz;
}

int main()
{
	long fsize = getfilesize("asg1");

	FILE* fp;
	fp = fopen("asg1", "r");
	char fstr[fsize];
	fread(fstr, 1, fsize, fp);
	fclose(fp);
	
	int start = 0x1842;
	int end = 0x19D2;
	for(int i = start; i < end; i++)
		fstr[i] ^= 0x42;
	
	fp = fopen("patched_asg1", "w");
	fwrite(fstr, 1, fsize, fp);
	fclose(fp);

	return 0;
}