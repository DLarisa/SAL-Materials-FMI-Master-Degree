#include <iostream>

int64_t xor_characters(uint8_t* license) {
    int64_t result = 0;
    size_t license_length = 0;
    
    while (license[license_length]) {
        ++license_length;
    }
    
    int aux = 0;
    if (license_length) {
        do {
            result = *reinterpret_cast<uint32_t*>(license) ^ static_cast<uint32_t>(result);
            license += 4;
            aux += 4;
        } while (aux < license_length);
    }
    return result;
}

int main() {
    uint8_t license[] = "6119326f-ac1e-4bb2-af55-0e0714d6dbf6";
    int64_t xorResult = xor_characters(license);
    std::cout << "XOR result: " << xorResult << std::endl;
    return 0;
}