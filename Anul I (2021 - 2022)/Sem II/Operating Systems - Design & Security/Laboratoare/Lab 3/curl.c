#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <curl/curl.h>

size_t write_callback(char *ptr, size_t size, size_t nmemb, void *userdata)
{
	return fwrite(ptr, size, nmemb, (FILE *) userdata);
}
 
int main()
{
  CURL *curl;
  CURLcode res;
  FILE * f = NULL; 
  
  curl = curl_easy_init();
  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://www.bing.com/search?q=romania+ungaria");
 
	f = fopen("tmp.txt", "w+");
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, f);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
	
    /* Perform the request, res will get the return code */ 
    res = curl_easy_perform(curl);
	
    /* Check for errors */ 
    if(res != CURLE_OK)
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
 
    /* always cleanup */ 
    curl_easy_cleanup(curl);
  }
  
  return 0;
}
