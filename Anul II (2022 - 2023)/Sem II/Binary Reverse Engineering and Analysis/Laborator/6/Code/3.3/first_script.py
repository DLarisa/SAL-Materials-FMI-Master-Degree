# creates the gdb script that will run and provide the input
# command in linux: gdb -x script.gdb
f1 = open("script.gdb", "w")
f1.write("file ./task03\n")

for i in range(1, 100):
  # creates all the files with all the different inputs (%_nr_$p)
  f = open(str(i) + ".txt", "w")
  f.write('%' + str(i) + '$p')
  f.close()

  f1.write("run < " + str(i) + ".txt > output" + str(i) + ".txt\n")
f1.close()