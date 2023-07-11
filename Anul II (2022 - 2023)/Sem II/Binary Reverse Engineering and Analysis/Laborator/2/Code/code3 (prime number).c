#include <stdint.h>

uint64_t myst5(uint64_t n) {
    if(n <= 1) return 0;

    uint64_t aux = 2;
    while(aux * aux <= n){
        if(n % aux == 0) return 0;
        aux++;
    }
    return 1;
}