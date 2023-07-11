import math  ### for mathematical functions
import codecs   ### for encode/decode
import ctypes   ### the random() function provided by Python has a different implementation; won't generate the same C results

# Load the C standard library to use the rand() function
libc = ctypes.CDLL('libc.so.6')



### Function to find the original seed
def find_seed(filename):
    # Converts the hex string filename to bytes, reverses the byte order, converts it back to hex
    hex_bytes = codecs.decode(filename, 'hex')
    hex_bytes_reversed = b""
    for i in range(len(hex_bytes)-1, -1, -1):
      hex_bytes_reversed += bytes([hex_bytes[i]])
    original_name = codecs.encode(hex_bytes_reversed, 'hex')

    # seed^4 ---> seed
    seed_4 = int(original_name, 16)
    seed = math.floor(math.sqrt(math.sqrt(seed_4)))
    print("Seed: ")
    print(seed)
    print("\n")

    # Seed for the pseudo-random generator (from this we can generate random numbers)
    libc.srand(seed)



### Process the file (encrypted) in order to get the contents and its name
def process_file(filename):
    # Open, read and close the encrypted file (binary form)
    file1 = open(filename, 'rb')
    file_read = file1.read()
    file1.close()

    # Split based on the constant "fmi_re_course"
    index = file_read.index(b"fmi_re_course")
    print("Index of const: ")
    print(index)
    print("\n")
    contents = file_read[:index]
    original_filename = file_read[index + 13:]
    return (contents, original_filename)



### Decryption process
def decrypt(contents, filename):
    # Decrypt the contents of the file
    decrypted_contents = []
    for byte in contents:
        decrypted_byte = (byte - libc.rand()) % 0x100
        decrypted_contents.append(decrypted_byte)
    # Reverse procedure on the contents
    decrypted_reversed = []
    for i in range(len(decrypted_contents) - 1, -1, -1):
        decrypted_reversed.append(decrypted_contents[i])

    # Decrypt the original filename (no need to reverse it)
    decrypted_filename = ""
    for byte in filename:
        decrypted_byte = (byte - libc.rand()) % 0x100
        decrypted_filename += chr(decrypted_byte)
    print("Name of the original file: ")
    print(decrypted_filename)

    # Create a new file with the name and the contents
    new_file = open(decrypted_filename, "wb")
    for byte in decrypted_reversed:
        new_file.write(bytes([byte]))
    new_file.close()



# Get filename from command-line argument and call decrypt function
find_seed("c19cf21d23c2a054462451047b202711")
contents, filename = process_file("c19cf21d23c2a054462451047b202711")
decrypt(contents, filename)