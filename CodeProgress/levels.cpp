#include <iostream>
#include <vector>
#include <cctype>  // For isalpha
#include <cstdint> // For uint16_t

// Function to find non-zero memory addresses and categorize by character type
void categorizeMemoryAddresses(const char *arr, size_t length, uint16_t baseAddress,
                               std::vector<uint16_t> &gAddresses, std::vector<uint16_t> &cAddresses,
                               std::vector<uint16_t> &dAddresses, std::vector<uint16_t> &pAddresses)
{
    for (size_t i = 0; i < length; ++i)
    {
        if (arr[i] != '0' && std::isalpha(arr[i]))
        { // Check for non-zero and valid character
            uint16_t memAddr = baseAddress + i;

            // Categorize based on the character
            switch (arr[i])
            {
            case 'g':
                gAddresses.push_back(memAddr);
                break;
            case 'c':
                cAddresses.push_back(memAddr);
                break;
            case 'd':
                dAddresses.push_back(memAddr);
                break;
            case 'p':
                pAddresses.push_back(memAddr);
                break;
            default:
                break;
            }
        }
    }
}

int main()
{
    const char array[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbb0g000000000g00C0g00dbbbbbbbbbbbbbbbbbbbbbbb";
    size_t length = sizeof(array) - 1; // Exclude null terminator
    uint16_t baseAddress = 0x1E00;     // Starting memory address

    // Arrays to store memory addresses for each character
    std::vector<uint16_t> gAddresses;
    std::vector<uint16_t> cAddresses;
    std::vector<uint16_t> dAddresses;
    std::vector<uint16_t> pAddresses;

    // Call function to categorize the memory addresses
    categorizeMemoryAddresses(array, length, baseAddress, gAddresses, cAddresses, dAddresses, pAddresses);

    // Print the resulting memory addresses for each character
    std::cout << "Addresses for 'g':\n";
    for (uint16_t addr : gAddresses)
    {
        std::cout << std::hex << "0x" << addr << std::endl;
    }

    std::cout << "\nAddresses for 'c':\n";
    for (uint16_t addr : cAddresses)
    {
        std::cout << std::hex << "0x" << addr << std::endl;
    }

    std::cout << "\nAddresses for 'd':\n";
    for (uint16_t addr : dAddresses)
    {
        std::cout << std::hex << "0x" << addr << std::endl;
    }

    std::cout << "\nAddresses for 'p':\n";
    for (uint16_t addr : pAddresses)
    {
        std::cout << std::hex << "0x" << addr << std::endl;
    }

    return 0;
}
