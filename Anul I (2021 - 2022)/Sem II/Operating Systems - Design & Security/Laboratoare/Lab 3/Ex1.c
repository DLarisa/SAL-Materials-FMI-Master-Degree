/* Create, Delete & Count Access/Modify files in lab3, respectevly lab3->lab31 */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/inotify.h>
#include <unistd.h>
#include <string.h>

#define EVENT_SIZE  ( sizeof (struct inotify_event) )
#define EVENT_BUF_LEN     ( 1024 * ( EVENT_SIZE + 16 ) )

// Structura în care păstrăm nr de câte ori a fost modificat/accesat fișierul
struct filename_counter
 {
    char filename[50];
    int nr;
 } v[30];
  
int main()
{
  int length, i = 0, last_file = 0;
  int fd;
  int wd;
  char buffer[EVENT_BUF_LEN];
  
  /* creating the INOTIFY instance */
  fd = inotify_init();

  /* checking for error */
  if(fd < 0) perror( "inotify_init" );

  /* adding the directory into watch list. Here, the suggestion is to validate the existence of the directory before adding into monitoring list. */
  wd = inotify_add_watch(fd, "/mnt/c/users/Larisa/Desktop/lab3", IN_CREATE | IN_DELETE | IN_MODIFY);

  /* read to determine the event change happens on the directory. Actually this reads blocks until the change event occurs */ 
  do
  {
    i = 0;
    length = read(fd, buffer, EVENT_BUF_LEN); 

	/* checking for error */
    if(length < 0) perror( "read" );
  
	/* actually read return the list of change events happens. Here, read the change event one by one and process it accordingly. */
    while(i < length) 
    {     
      struct inotify_event *event = (struct inotify_event*) &buffer[i];
      if(event->len)
      {
        if(event->mask & IN_CREATE)
        {
          if(event->mask & IN_ISDIR)
			printf("New directory %s created.\n", event->name);
          else 
			printf("New file %s created.\n", event->name);
        }
        else if(event->mask & IN_DELETE)
        {
          if(event->mask & IN_ISDIR) 
			printf("Directory %s deleted.\n", event->name);
          else 
			printf("File %s deleted.\n", event->name);
        }
        else if(event->mask & IN_MODIFY)
        {
          int j, found_file = 0;
		  // căutăm în tot vectorul să vedem dacă fișierul a mai fost accesat sau e la prima accesare
          for(j = 0; j < 30; j++)
          {
			// dacă fișierul a fost accesat
            if(strcmp(v[j].filename, event->name) == 0)
            {
              v[j].nr++;
              found_file = 1; // am marcat faptul că am găsit fișierul
              break;
            }
          }
		  // dacă fișierul nu a mai fost accesat până acum
          if(found_file == 0)
          {
            v[last_file + 1].nr = 1; // marcăm faptul că a fost modificat/accesat o dată
            strcpy(v[last_file + 1].filename, event->name); // punem și numele fișierului
			last_file++; // ultima celulă care are date, ca să știu unde pun noile adăugiri
          }
          if (event->mask & IN_ISDIR)
			if(j < 30)
				printf( "Directory %s accessed (modified) %d times.\n", event->name, v[j].nr);
			else
				printf( "Directory %s accessed (modified) %d times.\n", event->name, v[last_file].nr);
          else
			if(j < 30)
				printf("File %s accessed (modified) %d times.\n", event->name, v[j].nr);
			else 
				printf("File %s accessed (modified) %d times.\n", event->name, v[last_file].nr);
        }
      }
	  i += EVENT_SIZE + event->len;
    }
  } while(1);
  
  /* removing thedirectory from the watch list. */
  inotify_rm_watch(fd, wd);

  /*closing the INOTIFY instance*/
  close(fd);
}