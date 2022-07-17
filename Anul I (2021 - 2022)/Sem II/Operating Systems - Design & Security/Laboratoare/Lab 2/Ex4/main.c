#include <stdio.h>
#include <dlfcn.h>

typedef int (*MYFUNC)();


int main()
{

	void * h = dlopen("./library.so", RTLD_LAZY);
 
	MYFUNC myfct = dlsym(h, "MyFunction");

	myfct();

	if (h)
		dlclose(h);
	return 0;
}
