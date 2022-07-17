#include <windows.h>
#include <stdio.h>
#include <string.h>
#include <cwchar>
#include <winhttp.h>
#include "sha-256.h"

#pragma warning(disable:4996)
#define INTERNET_DEFAULT_HTTPS_PORT 443
#define INTERNET_DEFAULT_HTTP_PORT  80
#define FILE_NAME			"C:\\cygwin64\\home\\alex\\MyFile.txt"
#define MAX_CHAR 100000

char buffer[0x100000];
char response_buffer[MAX_CHAR];



int ReadChanges()
{
    const WCHAR base_folder[] = L"C:\\cygwin64\\home\\alex\\OS Design & Security\\";
    const WCHAR alias_base_folder[] = L"/home/alex/OS Design & Security/";
	DWORD bRet = 0;
	HANDLE h = CreateFileW(base_folder, FILE_LIST_DIRECTORY, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
		NULL, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, 0);
    sha256_context ctx;

	while (1)
	{
    // Monitor changes
		ReadDirectoryChangesW(h, buffer, 0x100000, TRUE,
			FILE_NOTIFY_CHANGE_FILE_NAME |
			FILE_NOTIFY_CHANGE_DIR_NAME |
			FILE_NOTIFY_CHANGE_ATTRIBUTES |
			FILE_NOTIFY_CHANGE_SIZE |
			FILE_NOTIFY_CHANGE_LAST_WRITE |
			// FILE_NOTIFY_CHANGE_LAST_ACCESS |
			FILE_NOTIFY_CHANGE_CREATION |
			FILE_NOTIFY_CHANGE_SECURITY,
			&bRet,
			NULL,
			NULL);

    // Print changes info
		FILE_NOTIFY_INFORMATION * p = (FILE_NOTIFY_INFORMATION *)buffer;
		p->FileName[p->FileNameLength/2] = L'\0';
		wprintf(L"file %ls has changed.\n", p->FileName);
    WCHAR* full_file_name;
    int len_full_name = wcslen(alias_base_folder) + p->FileNameLength/2 + 1;
    full_file_name = new WCHAR[len_full_name];
    wcpcpy(full_file_name, alias_base_folder);
    wcscat(full_file_name, p->FileName);

    char* chr_full_name;
    chr_full_name = new char[len_full_name];
    wcstombs(chr_full_name, full_file_name, len_full_name);

    // Open the file
    FILE * f = NULL;
    unsigned int i = 0;
    unsigned int j = 0;
    unsigned char buf[4096];
    uint8_t sha256sum[32];
    if( ! ( f = fopen( chr_full_name, "rb" ) ) )
        {
            perror( "fopen" );
            return( 1 );
        }
    
    // Compute the hash on the file content
    sha256_starts( &ctx );

    while( ( i = fread( buf, 1, sizeof( buf ), f ) ) > 0 )
    {
        sha256_update( &ctx, buf, i );
    }

    sha256_finish( &ctx, sha256sum );

    // Print the obtained hash
    for( j = 0; j < 32; j++ )
    {
        wprintf( L"%02x", sha256sum[j] );
    }

    wprintf( L"  %s\n", chr_full_name );

    // Make a request with the obtained hash
    DWORD dwSize = 0;
    DWORD dwDownloaded = 0;
    LPSTR pszOutBuffer;
    BOOL  bResults = FALSE;

    HANDLE hFile = CreateFile(FILE_NAME, GENERIC_READ|GENERIC_WRITE, FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_SHARE_DELETE, NULL, CREATE_ALWAYS,
      0, NULL);

    HINTERNET  hSession = NULL, 
              hConnect = NULL,
              hRequest = NULL;

    // Use WinHttpOpen to obtain a session handle.
    hSession = WinHttpOpen( L"WinHTTP Example/1.1",  
                            WINHTTP_ACCESS_TYPE_DEFAULT_PROXY,
                            WINHTTP_NO_PROXY_NAME, 
                            WINHTTP_NO_PROXY_BYPASS, 0 );

    // Specify an HTTP server.
    if( hSession )
      hConnect = WinHttpConnect( hSession, L"www.virustotal.com",
                INTERNET_DEFAULT_HTTPS_PORT, 0 );

    // Create an HTTP request handle.
    const WCHAR base_url[] = L"/vtapi/v2/file/report?apikey=7b401d17b4c85ca707befea18fe3cfe09885e8f10a505d611a6b1188d245745a&resource=";
    const unsigned int len_resource = 64;
    unsigned int len_url = wcslen(base_url) + len_resource + 1;
    WCHAR* url = new WCHAR[len_url];
    wcpcpy(url, base_url);
    for( j = 0; j < 32; j++ )
    {
      swprintf(url, len_url, L"%ls%02x", url, sha256sum[j]);
    }
    wprintf(L"%ls\n", url);
    if( hConnect )
      hRequest = WinHttpOpenRequest( hConnect, L"GET", url,
                                    NULL, WINHTTP_NO_REFERER, 
                                    WINHTTP_DEFAULT_ACCEPT_TYPES, 
                    WINHTTP_FLAG_SECURE );

    // Send a request.
    if( hRequest )
      bResults = WinHttpSendRequest( hRequest,
                                    WINHTTP_NO_ADDITIONAL_HEADERS, 0,
                                    WINHTTP_NO_REQUEST_DATA, 0, 
                                    0, 0 );


    // End the request.
    if( bResults )
      bResults = WinHttpReceiveResponse( hRequest, NULL );

    // Keep checking for data until there is nothing left.
    if( bResults )
    {
      do 
      {
        // Check for available data.
        dwSize = 0;
        if( !WinHttpQueryDataAvailable( hRequest, &dwSize ) )
          printf( "Error %u in WinHttpQueryDataAvailable.\n",
                  GetLastError( ) );

        // Allocate space for the buffer.
        pszOutBuffer = new char[dwSize+1];
        if( !pszOutBuffer )
        {
          printf( "Out of memory\n" );
          dwSize=0;
        }
        else
        {
          // Read the data.
          ZeroMemory( pszOutBuffer, dwSize+1 );

          if( !WinHttpReadData( hRequest, (LPVOID)pszOutBuffer, 
                                dwSize, &dwDownloaded ) )
            printf( "Error %u in WinHttpReadData.\n", GetLastError( ) );
          else
          {
            DWORD dwWritten = 0;
            WriteFile(hFile, pszOutBuffer, dwSize, &dwWritten, NULL);
                printf( "%s", pszOutBuffer );
          }

          // Free the memory allocated to the buffer.
          delete [] pszOutBuffer;
        }
      } while( dwSize > 0 );
    }


    // Report any errors.
    if( !bResults )
      printf( "Error %d has occurred.\n", GetLastError( ) );
    // Close any open handles.
    if( hRequest ) WinHttpCloseHandle( hRequest );
    if( hConnect ) WinHttpCloseHandle( hConnect );
    if( hSession ) WinHttpCloseHandle( hSession );
    CloseHandle(hFile);
    fclose(f);


    // Parse the response from the server to get the number of positive responses
    if( ! ( f = fopen( FILE_NAME, "rb" ) ) )
        {
            perror( "fopen" );
            return( 1 );
        }
    
    while (fgets(response_buffer, MAX_CHAR-1, f) != NULL) {
      int no_positives;
      char* positive_ptr = strstr(response_buffer, "positives");
      if(positive_ptr != NULL) {
        positive_ptr += strlen("positives\": ");
        positive_ptr = strtok(positive_ptr, ",");
        no_positives = atoi(positive_ptr);
        if (no_positives > 0) {
          if(remove(chr_full_name) == 0)
            wprintf(L"Deleted succesfully the file %s.\n", chr_full_name);
          else
            wprintf(L"Unable to delete the file %s.\n", chr_full_name);
        }
      }
    }
    
    fclose(f);

    // Do some cleaning
    delete[] full_file_name;
    delete[] chr_full_name;
	}
	CloseHandle(h);
	return 0;
}

int main()
{
	DWORD id = 0;

	ReadChanges();

	return 0;
}