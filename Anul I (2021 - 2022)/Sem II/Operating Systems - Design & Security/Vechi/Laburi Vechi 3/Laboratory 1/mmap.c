#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <signal.h>

// Function used to handle the SIGSEGV signal
void sigsegv_handler(int sig, siginfo_t* si, void* unused) {
    void* addr = si->si_addr;
    // Give write access to that memory
    int val = mprotect(si->si_addr, 20, PROT_WRITE | PROT_READ);
}

int main()
{
    int fd;
    char* addr;
    char* filename = "file.in";
    struct sigaction sa;

    // Opening the file required by mmap
    fd = open(filename, O_RDWR);
    if (fd == -1) {
        printf("Error when opening the file.\n");
        return 1;
    }

    // Allocate the memory with mmap
    addr = mmap(NULL, 20, PROT_READ, MAP_SHARED, fd, 0);
    if (addr == MAP_FAILED) {
        printf("mmap is not working.\n");
        return 1;
    }

    // Registering the SIGSEGV handler
    sa.sa_sigaction = sigsegv_handler;
    sa.sa_flags = SA_SIGINFO;
    sigaction(SIGSEGV, &sa, NULL);

    
    // Try to make a change in memory (will fail)
    printf("%s\n", addr); // "This is the content of the file."
    addr[0] = 'T';
    addr[1] = 'h';
    addr[2] = 'a';
    addr[3] = 't';
    printf("%s\n", addr); // "That is the content of the file."

    // Unmap the allocated memory
    munmap(addr, 20);
    
    return 0;
}
