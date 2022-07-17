// Create a perfect deadlock by adding a barrier after each thread takes the first resource.
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

pthread_mutex_t mtx[2];
pthread_barrier_t barrier;

void *ThrFunc(void *p)
{
	int *param = (int*)p;
	pthread_mutex_lock(&mtx[*param]); // here the thread takes the first resource
	printf("Thread %d before lock\n", *param);
	pthread_barrier_wait(&barrier); // here the thread waits for the other thread to (take the first resource and) reach the barrier
	pthread_mutex_lock(&mtx[1-*param]);
	return 0;
}

int main()
{
	pthread_t thr1;
	pthread_t thr2;
	int i1 = 0, i2 = 1;
	pthread_barrier_init(&barrier, NULL, 3); // initializing synchronization barrier with a count of the total number of threads that must be synchronized to the barrier before the threads may carry on
	pthread_mutex_init(&mtx[0], NULL);
	pthread_mutex_init(&mtx[1], NULL);
	pthread_create(&thr1, NULL, ThrFunc, &i1);
	pthread_create(&thr2, NULL, ThrFunc, &i2);

	pthread_join(thr1, NULL);
	pthread_join(thr2, NULL);
	pthread_mutex_destroy(&mtx[0]);
	pthread_mutex_destroy(&mtx[1]);

	pthread_barrier_destroy(&barrier); // destroying synchronization barrier
	return 0;
}

/*  === COMENZI RULARE (Ubuntu for Windows 10): ===
	cd /mnt/c/Users/Larisa/Desktop --> ca să ajung pe Desktop
	
	Compilare:
	gcc -pthread -o deadlock deadlock1.c && ./deadlock
*/