#include <stdint.h>
#include <stdbool.h>

bool myst5(uint64_t n) {
    uint64_t rax, rcx;
    rax = 0;
    bool result = false;

    if(n <= 1) goto L1;
    if(n <= 3) goto L6;
    if(n % 2 == 0) goto L1;
    rcx = 2;
    goto L3;

    L4: 
        rax = n / rcx; 
        uint64_t r = n % rcx; 
        if (r == 0) goto L8;
    L3:
        rcx++;
        rax = rcx;
        rax *= rcx;
        if(rax <= n) goto L4;
    L6:
        result = true;
        return result;
    L8:
        result = false;
    L1:
        return result;
}