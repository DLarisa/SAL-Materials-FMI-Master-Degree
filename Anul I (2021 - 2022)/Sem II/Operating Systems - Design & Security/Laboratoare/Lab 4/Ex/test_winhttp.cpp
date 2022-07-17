#include <windows.h>
#include <winhttp.h>
#include <stdio.h>
#include <string>
#include <fstream>
#include <iostream>
#include <codecvt>
#define FILE_NAME			L"tmp.txt"
#define MAXCHAR 10000
using namespace std;
char buffer[0x100000];
char response_buffer[MAXCHAR];


// Compute hash of file using the exe
string compute_hash(string full_path)
{
  string command = "C:\\Users\\Larisa\\Desktop\\Ex\\Sha256.exe " + full_path + " > D:\\temp_output.txt";
  const char* aux = command.c_str();
  system(aux);

  ifstream output_file("D:\\temp_output.txt");
  string file_hash;
  getline(output_file, file_hash, ' ');
  output_file.close();
  remove("D:\\temp_output.txt");
  return file_hash;
}

// API to VirusTotal.com
void API(string hash)
{
    DWORD dwSize = 0;
    DWORD dwDownloaded = 0;
    LPSTR pszOutBuffer;
    BOOL  bResults = FALSE;

    HANDLE hFile = CreateFile(FILE_NAME, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL, CREATE_ALWAYS,
        0, NULL);

    HINTERNET  hSession = NULL,
        hConnect = NULL,
        hRequest = NULL;

    // Use WinHttpOpen to obtain a session handle.
    hSession = WinHttpOpen(L"WinHTTP Example/1.1",
        WINHTTP_ACCESS_TYPE_DEFAULT_PROXY,
        WINHTTP_NO_PROXY_NAME,
        WINHTTP_NO_PROXY_BYPASS, 0);

    // Specify an HTTP server.
    if (hSession)
        hConnect = WinHttpConnect(hSession, L"www.virustotal.com",
            INTERNET_DEFAULT_HTTPS_PORT, 0);

    // Create an HTTP request handle.
    if (hConnect)
    {
        string request_parameter = "/vtapi/v2/file/report?apikey=abffc16654d1b01774d2c36f400d762f5038391f3898caa4ba3c4c61bf8ed136&resource=" + hash;
        wstring_convert<codecvt<wchar_t, char, mbstate_t>> converter;
        wstring w_request_parameter = converter.from_bytes(request_parameter);

        hRequest = WinHttpOpenRequest(hConnect, L"GET", w_request_parameter.c_str(),
        NULL, WINHTTP_NO_REFERER,
            WINHTTP_DEFAULT_ACCEPT_TYPES,
            WINHTTP_FLAG_SECURE);
    }

    // Send a request.
    if (hRequest)
        bResults = WinHttpSendRequest(hRequest,
            WINHTTP_NO_ADDITIONAL_HEADERS, 0,
            WINHTTP_NO_REQUEST_DATA, 0,
            0, 0);


    // End the request.
    if (bResults)
        bResults = WinHttpReceiveResponse(hRequest, NULL);

    // Keep checking for data until there is nothing left.
    if (bResults)
    {
        do
        {
            // Check for available data.
            dwSize = 0;
            if (!WinHttpQueryDataAvailable(hRequest, &dwSize))
                printf("Error %u in WinHttpQueryDataAvailable.\n",
                    GetLastError());

            // Allocate space for the buffer.
            pszOutBuffer = new char[dwSize + 1];
            if (!pszOutBuffer)
            {
                printf("Out of memory\n");
                dwSize = 0;
            }
            else
            {
                // Read the data.
                ZeroMemory(pszOutBuffer, dwSize + 1);

                if (!WinHttpReadData(hRequest, (LPVOID)pszOutBuffer,
                    dwSize, &dwDownloaded))
                    printf("Error %u in WinHttpReadData.\n", GetLastError());
                else
                {
                    DWORD dwWritten = 0;
                    WriteFile(hFile, pszOutBuffer, dwSize, &dwWritten, NULL);
                    //printf("%s", pszOutBuffer);
                }

                // Free the memory allocated to the buffer.
                delete[] pszOutBuffer;
            }
        } while (dwSize > 0);
    }

    // Report any errors.
    if (!bResults)
        printf("Error %d has occurred.\n", GetLastError());

    // Close any open handles.
    if (hRequest) WinHttpCloseHandle(hRequest);
    if (hConnect) WinHttpCloseHandle(hConnect);
    if (hSession) WinHttpCloseHandle(hSession);

    CloseHandle(hFile);
}



int main()
{
  DWORD bRet = 0;
  string working_directory = "C:\\Users\\Larisa\\Desktop\\lab3";
  

  // Handle to monitor the folder
  HANDLE h = CreateFileW(L"C:\\Users\\Larisa\\Desktop\\lab3", FILE_LIST_DIRECTORY, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
		NULL, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, 0);
  // Watch for changes in the folder
  while (1)
  {
    ReadDirectoryChangesW(h, buffer, 0x100000, TRUE,
			FILE_NOTIFY_CHANGE_FILE_NAME |
			FILE_NOTIFY_CHANGE_DIR_NAME |
			FILE_NOTIFY_CHANGE_ATTRIBUTES |
			FILE_NOTIFY_CHANGE_SIZE |
			FILE_NOTIFY_CHANGE_LAST_WRITE |
			FILE_NOTIFY_CHANGE_LAST_ACCESS |
			FILE_NOTIFY_CHANGE_CREATION |
			FILE_NOTIFY_CHANGE_SECURITY,
			&bRet,
			NULL,
			NULL);
    // Change Produced
	FILE_NOTIFY_INFORMATION *p = (FILE_NOTIFY_INFORMATION *)buffer;
	//wprintf(L"file %s has changed.\n", p->FileName);


	// Get the name of the file
	// Put the name of the changed file in temp_file.txt
	FILE* temp_file;
	temp_file = fopen("D:\\temp_file.txt", "w");
	fwprintf(temp_file, L"%s\n", p->FileName);
	fclose(temp_file);

	// Use temp_file to get back the name of the changed file
	ifstream aux_file;
	aux_file.open("D:\\temp_file.txt");
	string file_name;
	getline(aux_file, file_name);
	aux_file.close();
	remove("D:\\temp_file.txt");
	file_name = file_name.substr(0, p->FileNameLength / sizeof(WCHAR));
	// Full Path Name
	string full_path = working_directory + "\\" + file_name;


    ifstream f(full_path.c_str());
    // Check the file was not deleted -> delete is monitored
    if(f)
    {
      f.close();
	  // Compute hash of file
	  string hash = compute_hash(full_path);


	  // Get the response from the API
	  API(hash);
	  

      // Check if it is virus
      FILE* file = NULL;
      if (!(file = fopen("C:\\Users\\Larisa\\Desktop\\Ex\\Debug\\tmp.txt", "r")))
      {
          perror("fopen");
          return(1);
      }
      while (fgets(response_buffer, MAXCHAR - 1, file) != NULL) {
          int no_positives;
          char* positive_ptr = strstr(response_buffer, "positives");
          if (positive_ptr != NULL) {
              positive_ptr = positive_ptr + strlen("positives\": ");
              positive_ptr = strtok(positive_ptr, ",");
              no_positives = atoi(positive_ptr);
              if (no_positives > 0) {
                  cout << "Deleting file " << full_path.c_str() << endl;
                  remove(full_path.c_str()); // remove the file
              }
          }
      }

    }
  }
  CloseHandle(h);  
  return 0;	
}