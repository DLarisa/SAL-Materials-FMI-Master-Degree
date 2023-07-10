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
  
  const char* base_url = "https://www.virustotal.com/vtapi/v2/file/report?apikey=";
  const char* api_key = "7b401d17b4c85ca707befea18fe3cfe09885e8f10a505d611a6b1188d245745a";
  const char* resourse_string = "&resource=";
  const char* hash = "275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f";
  const int hash_length = 32;
  char* url;

  url = "https://www.virustotal.com/vtapi/v2/file/report?apikey=7b401d17b4c85ca707befea18fe3cfe09885e8f10a505d611a6b1188d245745a&resource=41428aeeb8428a8686dbc107fd4893ebf778dd21d454f37a22410836d4e814b9";
  // strcat(url, base_url);
  // strcat(url, api_key);
  // strcat(url, resourse_string);
  // strcat(url, hash);
  
  curl = curl_easy_init();
  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, url);
 
    f = fopen("tmp2.txt", "w+");
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, f);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
    /* Perform the request, res will get the return code */ 
    res = curl_easy_perform(curl);
    /* Check for errors */ 
    if(res != CURLE_OK)
      fprintf(stderr, "curl_easy_perform() failed: %s\n",
              curl_easy_strerror(res));
 
    /* always cleanup */ 
    curl_easy_cleanup(curl);
  }
  return 0;
}
