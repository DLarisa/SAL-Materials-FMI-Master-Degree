/* Monitorizăm fișierul lab3. Pt fiecare fișier creat, accesat sau modificat, verificăm cu API să nu fie virus.
Dacă este virus, îl ștergem. */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/inotify.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <curl/curl.h>
#include <openssl/md5.h>

#define EVENT_SIZE  ( sizeof (struct inotify_event) )
#define EVENT_BUF_LEN     ( 1024 * ( EVENT_SIZE + 16 ) )
#define MAXCHAR 10000


unsigned char result[MD5_DIGEST_LENGTH];

// Get the size of the file by its file descriptor
unsigned long get_size_by_fd(int fd) {
    struct stat statbuf;
    if(fstat(fd, &statbuf) < 0) exit(-1);
    return statbuf.st_size;
}

unsigned char* computeSHA_file(char *file) 
{
	int file_descript;
    unsigned long file_size;
    char* file_buffer;

    file_descript = open(file, O_RDONLY);
    if(file_descript < 0) exit(-1);

    file_size = get_size_by_fd(file_descript);

    file_buffer = mmap(0, file_size, PROT_READ, MAP_SHARED, file_descript, 0);
    MD5((unsigned char*) file_buffer, file_size, result);
    munmap(file_buffer, file_size); 

    return result;
}

size_t write_callback(char *ptr, size_t size, size_t nmemb, void *userdata)
{
	return fwrite(ptr, size, nmemb, (FILE *) userdata);
}

  
int main()
{
  int length, i = 0, last_file = 0;
  int fd;
  int wd;
  char buffer[EVENT_BUF_LEN];
  char working_directory[] = "/mnt/c/users/Larisa/Desktop/lab3";
  
  CURL *curl;
  CURLcode res;
  FILE * f = NULL; 
  char response_buffer[MAXCHAR];
  
  const char* base_url = "https://www.virustotal.com/vtapi/v2/file/report?apikey=";
  //my API key
  const char* api_key = "1e5c8a20708ee442ef7393f7d7ed4c714137d2dd3ee7d9dcccf5c5eaeeac5127";
  const char* resourse_string = "&resource=";
  const int hash_length = 64;
  
  /* creating the INOTIFY instance */
  fd = inotify_init();

  /* checking for error */
  if(fd < 0) perror( "inotify_init" );

  /* adding the directory into watch list. Here, the suggestion is to validate the existence of the directory before adding into monitoring list. */
  wd = inotify_add_watch(fd, working_directory, IN_CREATE | IN_ACCESS | IN_MODIFY);

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
        if(event->mask & IN_MODIFY) // Dacă se crează un nou fișier, automat intră în IN_MODIFY (nu mai are sens să avem un if cu IN_CREATE)
        {
			// Determine the absolute path of the file
            char * filename = (char*) malloc(strlen(working_directory) + strlen(event->name) + 2);
            strcpy(filename, working_directory);
            strcat(filename, "/");
            strcat(filename, event->name);
			
			// compute hash
			unsigned char* hash = computeSHA_file(filename);
			char total[1000];
			for(int i = 0; i < MD5_DIGEST_LENGTH; i++) {
				sprintf(&total[i*2], "%02x", (unsigned int)hash[i]);
			}
			
			// Generate the url to the virus API
            char *url = (char*) malloc(strlen(base_url) + strlen(api_key) + strlen(resourse_string) + strlen(total) + 1);
            strcpy(url, base_url);
            strcat(url, api_key);
            strcat(url, resourse_string);
			strcat(url, total);
			
			// Sent the request to the virus total API
            curl = curl_easy_init();
            if(curl) {
              curl_easy_setopt(curl, CURLOPT_URL, url);
              f = fopen("tmp.txt", "w+");
              curl_easy_setopt(curl, CURLOPT_WRITEDATA, f);
              curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
              /* Perform the request, res will get the return code */ 
              res = curl_easy_perform(curl);
              /* Check for errors */ 
              if(res != CURLE_OK)
                fprintf(stderr, "curl_easy_perform() failed: %s\n",
                        curl_easy_strerror(res));
              fclose(f);
              /* always cleanup */ 
              curl_easy_cleanup(curl);
            }
			
			// Read the output from the API and search it for the number of positive detections.
            // If this number is bigger than 0, then the file will be removed.
            if(!(f = fopen( "tmp.txt", "r")))
            {
                perror( "fopen" );
                return( 1 );
            }
            while (fgets(response_buffer, MAXCHAR-1, f) != NULL) {
              int no_positives;
              char* positive_ptr = strstr(response_buffer, "positives");
              if(positive_ptr != NULL) {
                positive_ptr = positive_ptr + strlen("positives\": ");
                positive_ptr = strtok(positive_ptr, ",");
                no_positives = atoi(positive_ptr);
                if(no_positives > 0) {
                  if (remove(filename) == 0)
                    printf("Deleted successfully the file %s.\n", filename);
                  else
                    printf("Unable to delete the file %s.\n", filename);
                }
              }
            }
            fclose(f);
            free(filename);
            free(url);
        }
		else if(event->mask & IN_ACCESS) 
		{
			// Determine the absolute path of the file
            char * filename = (char*) malloc(strlen(working_directory) + strlen(event->name) + 2);
            strcpy(filename, working_directory);
            strcat(filename, "/");
            strcat(filename, event->name);
			
			// compute hash
			unsigned char* hash = computeSHA_file(filename);
			char total[1000];
			for(int i = 0; i < MD5_DIGEST_LENGTH; i++) {
				sprintf(&total[i*2], "%02x", (unsigned int)hash[i]);
			}
			
			// Generate the url to the virus API
            char *url = (char*) malloc(strlen(base_url) + strlen(api_key) + strlen(resourse_string) + strlen(total) + 1);
            strcpy(url, base_url);
            strcat(url, api_key);
            strcat(url, resourse_string);
			strcat(url, total);
			
			// Sent the request to the virus total API
            curl = curl_easy_init();
            if(curl) {
              curl_easy_setopt(curl, CURLOPT_URL, url);
              f = fopen("tmp.txt", "w+");
              curl_easy_setopt(curl, CURLOPT_WRITEDATA, f);
              curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
              /* Perform the request, res will get the return code */ 
              res = curl_easy_perform(curl);
              /* Check for errors */ 
              if(res != CURLE_OK)
                fprintf(stderr, "curl_easy_perform() failed: %s\n",
                        curl_easy_strerror(res));
              fclose(f);
              /* always cleanup */ 
              curl_easy_cleanup(curl);
            }
			
			// Read the output from the API and search it for the number of positive detections.
            // If this number is bigger than 0, then the file will be removed.
            if(!(f = fopen( "tmp.txt", "r")))
            {
                perror( "fopen" );
                return( 1 );
            }
            while (fgets(response_buffer, MAXCHAR-1, f) != NULL) {
              int no_positives;
              char* positive_ptr = strstr(response_buffer, "positives");
              if(positive_ptr != NULL) {
                positive_ptr = positive_ptr + strlen("positives\": ");
                positive_ptr = strtok(positive_ptr, ",");
                no_positives = atoi(positive_ptr);
                if(no_positives > 0) {
                  if (remove(filename) == 0)
                    printf("Deleted successfully the file %s.\n", filename);
                  else
                    printf("Unable to delete the file %s.\n", filename);
                }
              }
            }
            fclose(f);
            free(filename);
            free(url);
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