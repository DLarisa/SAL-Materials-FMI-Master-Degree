#!/usr/bin/python

from pwn import * # sudo pip install pwntools

# start process interaction
# use "process" from pwntools
p = process('./crackme')


# send input
# use "send"/"sendline" from pwntools (e.g. 'test')
p.sendline("test")


# keep reading output until program terminates
while True:
	try:
		#use "readline" from pwntools
		line = p.readline()
		print ("Read line: [%s]" % line)

		#TODO 
	except:
		#could not read line => program exited
		break
		