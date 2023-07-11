#!/usr/bin/python


from pwn import *
import itertools


# passwords
string1 = "zihldazjcn"
string2 = "vlrgmhasbw"
string3 = "jqvanafylz"
string4 = "hhqtjylumf"
string5 = "yemlopqosj"
string6 = "mdcdyamgec"
string7 = "nhnewfhetk"
string = [string1, string2, string3, string4, string5, string6, string7]
# list of permutations
list_perm = list(itertools.permutations(string))

i = 0
# traverse the permutations
for list in list_perm:
	i += 1
	password = ''
	password += list[0] + list[1] + list[2] + list[3] + list[4] + list[5] + list[6]
	print('\n\n\n' + str(i) + '. ' + password + ': ')


	# check the password
	p = process('./crackme', shell = True)
	p.sendline(password)

	while True:
		try:
			line = p.readline()
			print ("Read line: [%s]" % line)
		except:
			#could not read line => program exited
			break

	p.kill()