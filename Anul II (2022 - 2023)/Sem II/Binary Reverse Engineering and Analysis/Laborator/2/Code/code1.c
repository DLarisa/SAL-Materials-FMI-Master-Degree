#include <stdint.h>

uint64_t myst2(char v[]) {
    uint64_t i = 0;
    while(v[i] != '\0') i++;
    return i;
}