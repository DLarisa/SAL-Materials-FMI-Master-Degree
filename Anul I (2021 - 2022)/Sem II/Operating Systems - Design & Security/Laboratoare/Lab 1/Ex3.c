/*
	Write a C program which allocates a zone of virtual memory with only read only rights. 
	Register a handler for SIGSEGV signal. Create a pointer to an address in the read only zone 
	you just created and try to write at that address. Find in the handler registered to handle 
	SIGSEGV signal the address where the access violation was produced and change the rights 
	on the page with mprotect function.
*/
#include <stdio.h>
#include <sys/mman.h> //pt mmap, mprotect -> man mmap în terminal pt a acesa manual page
#include <signal.h> // pt sigaction -> SIGSEGV
#include <unistd.h> // pt _exit
#include <stdlib.h> // pt coduri erori

// Atunci când primim semnalul, ar trebui să facem următoarele 
void handler(int sig, siginfo_t *info, void *ucontext) {
	// Unde s-a produs accesarea ilegală
	printf("Încercare de accesare ilegală a memorie la adresa: %p\n", info->si_addr);
	// Funcție care schimbă permisiunile pentru a putea să scriem
	mprotect(info->si_addr, 4096, PROT_WRITE);
}

int main() {
	// Alocare Memorie Virtuală
	/* 
		void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);
		
		addr = The starting address for the new mapping. If addr is NULL, then the kernel 
				chooses the (page-aligned) address at which to create the mapping; 
				this is the most portable method of creating a new mapping.
		length = length of the mapping (which must be greater than 0) --> 4096 = sizeof(int)
		prot = the desired memory protection of the mapping --> PROT_READ = Pages may be read.
		flags = determines whether updates to the mapping are visible to other processes mapping 
				the same region, and whether updates are carried through to the underlying file.
				--> MAP_PRIVATE = Create a private copy-on-write mapping.
				--> MAP_ANONYMOUS = The mapping is not backed by any file; its contents are initialized to 0.
									The offset argument should be zero.
		fd = file descriptor --> 0
		offset = starting the addr at defined offset --> 0
		
	*/
	int *ptr = mmap (NULL, 4096, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
	
	// Register a handler for a signal
	/*
		struct sigaction {
            void     (*sa_handler)(int);
            void     (*sa_sigaction)(int, siginfo_t *, void *);
            sigset_t   sa_mask;
            int        sa_flags;
            void     (*sa_restorer)(void);
        };
		------------------------------------------------------
		If SA_SIGINFO (This flag is meaningful only when establishing a signal handler.) 
		is specified in sa_flags, then sa_sigaction (instead of sa_handler) specifies the 
		signal-handling function. This function receives three arguments, as described: 
		
		void handler(int sig, siginfo_t *info, void *ucontext) 
		{
			sig = The number of the signal that caused invocation of the handler.
			info = A pointer to a siginfo_t, which is a structure containing further information about the signal.
			ucontext = The structure pointed to by this field contains signal context information that was 
						saved on the user-space stack by the kernel.
		}
	*/
	struct sigaction s;
	s.sa_flags = SA_SIGINFO;
	s.sa_sigaction = handler;
	
	// Setup signal handler
	if(sigaction(SIGSEGV, &s, NULL) == -1) {
		perror("Sigaction Error");
		_exit(EXIT_FAILURE);
	}
	
	// Încercăm să scriem (READ_ONLY)
	ptr[0] = 5; // Se cheamă semnalul și mergem în funcția handler
	printf("Acum merge: %d\n", ptr[0]);
	
	return 0;
}

/*  === COMENZI RULARE (Ubuntu for Windows 10): ===
	cd /mnt/c/Users/Larisa/Desktop --> ca să ajung pe Desktop
	
	Compilare: gcc Ex3.c -o ex3 && ./ex3
*/