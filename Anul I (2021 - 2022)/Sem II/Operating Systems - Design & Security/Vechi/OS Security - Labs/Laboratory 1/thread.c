#include <pthread.h>
#include <stdbool.h>
#include <stdio.h>
#include <time.h> 
#include <stdlib.h>
#include <signal.h>
#include <sys/mman.h>

const int n = 3;
pthread_t threads[3];



void delay(int milliseconds) 
{
    clock_t start_time = clock(); 

    while (clock() < start_time + milliseconds); 
} 

// Functions used to handle the SIGSEGV signal
void main_handler(int sig, siginfo_t* si, void* unused) {
    pthread_t thr = pthread_self();
    if(pthread_equal(thr, threads[0])) {
        printf("Thread 1\n");
    } else if (pthread_equal(thr, threads[1])) {
        printf("Thread 2\n");
    } else if (pthread_equal(thr, threads[2])) {
        printf("Thread 3\n");
    } else {
        printf("Main thread\n");
    }
    delay(5000000);
    printf("Handle done\n");
}


void* thread_function(void* args) {
    struct sigaction sa;
    int* x = (int*) args;
    int n = *x;

    printf("Starting with value: %d\n", n);

    raise(SIGSEGV);

    while ((*x) < 1000000) {
        (*x)++;
        delay(1000);
    }
    int* result = (int*) malloc(sizeof(int));
    *result = *x+n;
    return result;
}


int main() {
    int args[n];
    int* return_val[n];
    struct sigaction sa;

    // Registering the SIGSEGV handler
    sa.sa_sigaction = main_handler;
    sa.sa_flags = SA_SIGINFO;
    sigaction(SIGSEGV, &sa, NULL);

    for (int i=0; i<n; ++i) {
        args[i] = i;
        pthread_create(&threads[i], NULL, thread_function, &args[i]);
    }

    raise(SIGSEGV);

    for (int i=0; i<n; ++i) {
        pthread_join(threads[i], (void**)&return_val[i]);
    }
}