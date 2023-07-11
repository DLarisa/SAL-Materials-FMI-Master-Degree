#!/usr/bin/python

from pwn import * # sudo pip install pwntools


# start process interaction
# use "process" from pwntools
p = process('ltrace ./crackme', shell = True)


# send input
string1 = "zihldazjcn"
string2 = "vlrgmhasbw"
string3 = "jqvanafylz"
string4 = "hhqtjylumf"
string5 = "yemlopqosj"
string6 = "mdcdyamgec"
string7 = "nhnewfhetk"
string = string1 + string2 + string3 + string4 + string5 + string6 + string7
p.sendline(string)


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
