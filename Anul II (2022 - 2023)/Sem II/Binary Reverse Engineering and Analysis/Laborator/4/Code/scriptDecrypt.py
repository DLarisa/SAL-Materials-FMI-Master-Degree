import idaapi

def decrypt(start, end):
    for i in range(start, end):
        idaapi.patch_byte(i, 0xFFFFFFFF - idaapi.get_byte(i))

decrypt(0x4011C7, 0x4012CB)