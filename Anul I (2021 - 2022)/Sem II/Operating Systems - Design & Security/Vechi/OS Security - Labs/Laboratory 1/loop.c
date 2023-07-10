#include<stdio.h>
#include<stdlib.h>

int main()
{
    int* x;
    x = (int*) malloc(sizeof(int));
    *x = 0;
    while (*x>=0) {
        (*x)++;
        (*x)--;
    }
    printf("Hello World!\n");
    return 0;
}
