#include <iostream>
#include <random>
#include <sstream>
#include <iomanip>
#include <cstdint>
#include <stdio.h>
#include <string.h>

std::string generateGUID() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<unsigned char> dis(0, 255);

    std::ostringstream GUID;
    for (int i = 0; i < 16; ++i) {
        unsigned char byte = dis(gen);
        GUID << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(byte);
    }
    return GUID.str();
}

int main() {
    std::string guid;
    guid = generateGUID();
    std::cout << "Generated GUID: " << guid << std::endl;

    return 0;
}