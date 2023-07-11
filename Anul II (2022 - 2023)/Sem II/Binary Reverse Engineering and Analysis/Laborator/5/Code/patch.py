import os
import psutil
import shutil
import winreg

### First, change the regestry
# specify the registry key path and value to be modified
key_path = r"SOFTWARE\Microsoft\winmine"
key_name1 = "Name1"
key_name2 = "Name2"
key_name3 = "Name3"
new_name = "HackedByL"
key_time1 = "Time1"
key_time2 = "Time2"
key_time3 = "Time3"
new_time = 1

# open the registry key for modification
try:
    key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, key_path, 0, winreg.KEY_WRITE)
except WindowsError:
    print("Error opening key")

# set the new registry value
try:
    winreg.SetValueEx(key, key_name1, 0, winreg.REG_SZ, new_name)
    winreg.SetValueEx(key, key_name2, 0, winreg.REG_SZ, new_name)
    winreg.SetValueEx(key, key_name3, 0, winreg.REG_SZ, new_name)
    
    winreg.SetValueEx(key, key_time1, 0, winreg.REG_DWORD, new_time)
    winreg.SetValueEx(key, key_time2, 0, winreg.REG_DWORD, new_time)
    winreg.SetValueEx(key, key_time3, 0, winreg.REG_DWORD, new_time)
    print("Registry value updated successfully")
except WindowsError:
    print("Error updating registry value")

# close the registry key
winreg.CloseKey(key)




### Patch the game
# Original Game window
monitor_exe = 'winmine.exe'
# Get the path of the Python script
script_path = os.path.abspath(__file__)
# Get the directory containing the Python script
script_dir = os.path.dirname(script_path)
# Path to the original game
path_game = os.path.join(script_dir, monitor_exe)

# Path of the RE file
crack_exe = r'C:\Users\Larisa\Desktop\winmine_crack.exe'


# Check if the game is running
for proc in psutil.process_iter(['name']):
    if proc.info['name'] == monitor_exe:
        # Get the PID
        pid = proc.pid
        # Kill the target process
        os.system(f'taskkill /f /pid {pid}')
        # Replace the executable file
        shutil.copy(crack_exe, path_game)
        # Start the target process
        os.startfile(path_game)
        break
