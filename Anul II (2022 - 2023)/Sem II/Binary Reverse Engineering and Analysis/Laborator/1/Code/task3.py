#!/usr/bin/python


from pwn import * # sudo pip install pwntools


# we notice that we have 5 function calls ('memset', 'fgets', 'strlen', 'puts', 'exit')
# so, when that number will change, we found the right length for the string
functions = ['memset', 'fgets', 'strlen', 'puts', 'exit']

# i = remember the length of the sent input
i = 0

while len(functions) == 5:
	# we change the value of i
	i = i + 1

	# start process interaction
	p = process('ltrace ./crackme', shell = True)

	# send input
	p.sendline('i' * i)

	# wait for the program to finish
	p.wait_for_close()


	# recheck the number of functions
	functions = []

	# keep reading output until program terminates
	while True:
		try:
			#use "readline" from pwntools
			line = p.readline()

			# if the line does not start with + / -
			if (line[0] != 43 and line[0] != 45):
				line = line.decode('utf-8')
				end_chr = line.find('(')
				if(end_chr != -1):
					line = line[:end_chr]
					functions.append(line)
		except:
			#could not read line => program exited
			break

print("Length: " + str(i))
print(functions)