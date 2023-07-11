#include <iostream>
#include <cmath>

int count_nr_set_bits_integer(int num) {
    int count = 0;
    while (num != 0) {
        count += num & 1;
        num >>= 1;
    }
    return count;
}

bool check_if_valid(int XOR_PC_Guid, int XOR_user_input) {
    char v2 = static_cast<char>(XOR_PC_Guid);
    char v3 = static_cast<char>(XOR_user_input);

    if (count_nr_set_bits_integer(XOR_user_input) >= 16) {
        return std::abs(v2 - v3) & 3 != 0;
    } else {
        return true;
    }
}

int main() {
    int XOR_PC_Guid = 639708020; 
    int XOR_user_input = 2132878460;  

    bool isValid = check_if_valid(XOR_PC_Guid, XOR_user_input);
    std::cout << "Is Valid: " << std::boolalpha << !isValid << std::endl;

    return 0;
}