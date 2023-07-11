#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <dirent.h>

int recursie(const char *a1)
{
	DIR *v1 = opendir(a1);
	char *ptr;
	struct dirent *v5;
	DIR *dirp = v1;
	
	if(v1)
	{
		while(1)
		{
			v5 = readdir(dirp);
			if(!v5) break;
			if(v5->d_type == 4)
			{
				if(strcmp(v5->d_name, ".") && strcmp(v5->d_name, ".."))
				{
					asprintf(&ptr, "%s/%s", a1, v5->d_name);
					puts(ptr);
					recursie(ptr);
					free(ptr);
				}
			}
			else
			{
				printf("Not Directory----\n");
				printf("%c ", v5->d_type);
				printf("%s \n", v5->d_name);
				long long t1 = a1;
				long long t2 = v5->d_name;
				printf("Ce primeste functia: %lli, %lli\n", t1, t2);
				printf("Not Directory----\n\n");
			}
		}
	}
	return 0;
}

int main() 
{
	const char *a1 = ".";
	recursie(a1);
	
	return 0;
}