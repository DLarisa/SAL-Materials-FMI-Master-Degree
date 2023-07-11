#include <iostream>

int countSetBits(int number) {
    int count = 0;
    while (number != 0) {
        if (number & 1) {
            count++;
        }
        number >>= 1; // Right shift the number by 1 bit
    }
    return count;
}

int main() {
    int number = 2004515628;
    int setBits = countSetBits(number);
    std::cout << "Number of set bits: " << setBits << std::endl;

    return 0;
}