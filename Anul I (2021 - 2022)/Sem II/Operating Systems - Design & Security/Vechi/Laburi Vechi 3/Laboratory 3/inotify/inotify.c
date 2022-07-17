/*This is the sample program to notify us for the file creation and file deletion takes place in “/tmp” directory*/
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/inotify.h>
#include <unistd.h>
#include <string.h>

#define EVENT_SIZE (sizeof(struct inotify_event))
#define EVENT_BUF_LEN (1024 * (EVENT_SIZE + 16))
#define MAX_NUMBER_FILES 1024

int find_in_list(char* filename, char** list_of_files, int size_of_list)
{
  for (unsigned int i=0; i<size_of_list; ++i) 
  {
    if (strcmp(filename, list_of_files[i]) == 0)
    {
      return i;
    }
  }
  return -1;
}

int main()
{
  int length, i = 0;
  int fd;
  int wd;
  int wd2;
  char buffer[EVENT_BUF_LEN];

  int no_files = 0;
  char* filenames[MAX_NUMBER_FILES];
  int no_accesses[MAX_NUMBER_FILES];
  int pos;

  /*creating the INOTIFY instance*/
  fd = inotify_init();

  /*checking for error*/
  if (fd < 0)
  {
    perror("inotify_init");
  }

  /*adding the “/tmp” directory into watch list. Here, the suggestion is to validate the existence of the directory before adding into monitoring list.*/
  // wd2 = inotify_add_watch(fd, "/tmp", IN_CREATE | IN_DELETE | IN_ACCESS);
  // wd2 = inotify_add_watch(fd, "/home", IN_CREATE | IN_DELETE | IN_ACCESS);
  wd2 = inotify_add_watch(fd, "/home/lab3", IN_CREATE | IN_DELETE | IN_ACCESS);

  /*read to determine the event change happens on “/tmp” directory. Actually this read blocks until the change event occurs*/
  do
  {
    i = 0;
    length = read(fd, buffer, EVENT_BUF_LEN);

    /*checking for error*/
    if (length < 0)
    {
      perror("read");
    }

    /*actually read return the list of change events happens. Here, read the change event one by one and process it accordingly.*/
    while (i < length)
    {
      struct inotify_event *event = (struct inotify_event *)&buffer[i];
      if (event->len)
      {
        if (event->mask & IN_CREATE)
        {
          if (event->mask & IN_ISDIR)
          {
            printf("New directory %s created.\n", event->name);
          }
          else
          {
            printf("New file %s created.\n", event->name);
          }
        }
        else if (event->mask & IN_DELETE)
        {
          if (event->mask & IN_ISDIR)
          {
            printf("Directory %s deleted.\n", event->name);
          }
          else
          {
            printf("File %s deleted.\n", event->name);
          }
        }
        else 
        {
          if (event->mask & IN_ACCESS)
          {
            pos = find_in_list(event->name, filenames, no_files);
            
            if(pos == -1) {
              filenames[no_files] = (char*) malloc(strlen(event->name) + 1);
              strcpy(filenames[no_files], event->name);
              no_accesses[no_files] = 1;
              no_files += 1;
            }
            else {
              no_accesses[pos] += 1;
            }


            // printf("Accessed %s.\n", event->name);
            for (unsigned int i=0; i<no_files; ++i) {
              printf("%s: %d\n", filenames[i], no_accesses[i]);
            }
            printf("\n\n");
          }
        }
      }
      i += EVENT_SIZE + event->len;
    }
  } while (1);
  /*removing the “/tmp” directory from the watch list.*/
  inotify_rm_watch(fd, wd);
  inotify_rm_watch(fd, wd2);

  /*closing the INOTIFY instance*/
  close(fd);
}
