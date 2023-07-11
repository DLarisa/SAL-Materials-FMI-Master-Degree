import os

# gets all the different outputs and places them in one file
f1 = open("output_final.txt", "w")

for i in range(1, 100):
  f = open("output" + str(i) + ".txt", "r")
  f1.write(str(i) + ": " + f.read() + "\n")
  f.close()
  
  # delete the input and output files
  input_name = str(i) + ".txt"
  os.remove(input_name)
  output_name = "output" + str(i) + ".txt"
  os.remove(output_name)

f1.close()