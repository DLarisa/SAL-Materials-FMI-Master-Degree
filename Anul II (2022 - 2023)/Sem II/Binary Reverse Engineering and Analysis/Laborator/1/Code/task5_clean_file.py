file = open('output.txt', 'r')
lines = file.readlines()
for line in lines:
	if(len(line) > 2 and 
	"Starting local process" not in line and
	"Congrats. If that is the correct input you will now get a flag" not in line and
	"If all you see is garbage, try a different one" not in line and
	"stopped with exit code 1" not in line and
	"Stopped process" not in line and
	"zihldazjcn" not in line):
		# we count the number of '\' since it is an illegal character and it should be only at the end of the flag
		illegal_chr = 0
		for char in line:
			if(ord(char) == 92):
				illegal_chr += 1
		if(illegal_chr < 3):
			print(line[:-1])