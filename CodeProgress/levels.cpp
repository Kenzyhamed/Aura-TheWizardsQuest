#include <iostream>
#include <vector>
#include <map>
#include <cstdint> // For uint16_t
#include <iomanip> // For std::hex and std::setfill
#include <cctype>  // For std::tolower

// Define a type alias for storing address and repeat count pairs
using AddressRepeatPair = std::vector<std::pair<uint16_t, size_t>>;

// Function to process addresses and output in .byte format with a unique label
void processAndPrintAddresses(const char *array, size_t length, uint16_t baseAddress, int number)
{
    // Predefine all categories
    std::map<std::string, AddressRepeatPair> categorizedAddresses = {
        {"START_ADDRESS_NORMAL_PLATFORM", {}},
        {"GEM_ADDRESS", {}},
        {"SPAWN_ADDRESS", {}},
        {"START_ADDRESS_DANGER_PLATFORM", {}},
        {"FIRST_PORTAL", {}},
        {"SECOND_PORTAL", {}},
    };

    // Categorize the memory addresses
    for (size_t i = 0; i < length;)
    {
        if (array[i] != '0' && std::isalpha(array[i]))
        {                                              // Check for non-zero valid characters
            char currentChar = std::tolower(array[i]); // Convert character to lowercase
            size_t repeatCount = 1;

            // Count repeats for the same character
            while (i + repeatCount < length && std::tolower(array[i + repeatCount]) == currentChar)
            {
                ++repeatCount;
            }

            uint16_t memAddr = baseAddress + i; // Calculate base memory address

            // Map character to the appropriate category
            switch (currentChar)
            {
            case 'n':
                categorizedAddresses["START_ADDRESS_NORMAL_PLATFORM"].emplace_back(memAddr, repeatCount);
                break;
            case 'g':
                categorizedAddresses["GEM_ADDRESS"].emplace_back(memAddr, repeatCount);
                break;
            case 'c':
                categorizedAddresses["SPAWN_ADDRESS"].emplace_back(memAddr, repeatCount);
                break;
            case 'f':
                categorizedAddresses["START_ADDRESS_DANGER_PLATFORM"].emplace_back(memAddr, repeatCount);
                break;
            case 'e':
                categorizedAddresses["FIRST_PORTAL"].emplace_back(memAddr, repeatCount);
                break;
            case 'p':
                categorizedAddresses["SECOND_PORTAL"].emplace_back(memAddr, repeatCount);
                break;
            default:
                break; // Ignore unrecognized characters
            }

            i += repeatCount; // Move the index forward by the repeat count
        }
        else
        {
            ++i; // Skip invalid or zero characters
        }
    }

    // Lambda function to print byte data
    auto printByteFormat = [&](const AddressRepeatPair &addresses, const std::string &labelWithNumber)
    {
        if (addresses.empty())
        {
            std::cout << labelWithNumber << ":\n    .byte $ff\n";
            return;
        }

        std::cout << labelWithNumber << ":\n    .byte ";

        bool first = true;
        for (const auto &[baseAddr, repeatCount] : addresses)
        {
            uint8_t lowByte = baseAddr & 0xFF;         // Extract low byte
            uint8_t highByte = (baseAddr >> 8) & 0xFF; // Extract high byte

            if (!first)
            {
                std::cout << ", ";
            }
            first = false;

            std::cout << "$" << std::hex << std::uppercase << std::setfill('0')
                      << std::setw(2) << (int)lowByte << ", $"
                      << std::setw(2) << (int)highByte;

            if (labelWithNumber.find("START_ADDRESS_NORMAL_PLATFORM") != std::string::npos || labelWithNumber.find("START_ADDRESS_DANGER_PLATFORM") != std::string::npos)
            {
                std::cout << ", $"
                          << std::dec << repeatCount;
            }
        }
        std::cout << ", $ff\n";
    };

    // Print results for all categories
    printf("\n;--------------------------------------- LEVEL %d ---------------------------\n", number);
    for (const auto &[label, addresses] : categorizedAddresses)
    {
        printByteFormat(addresses, label + "_LVL_" + std::to_string(number));
    }
}

int main()
{
    // Example arrays
    // const char array2[] = "bbbbbbbbbbbbbbbbbbbbbbb00c00000000000000000bb00n00000000000000000bb00000000000000000000bb00000000000000000000bb0g000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbbg000000000000000g00dbbbbbbbbbbbbbbbbbbbbbbb";
    // const char array3[] = "bbbbbbbbbbbbbbbbbbbbbbb000000000c0000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000nnnnn00000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbb0g000000g0000000g00dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array1[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbb0g000000000g00C0g00dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array2[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000g00c000000000000bb000nnnnn000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbb0g00000000000000g00dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array3[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb000c00g0000000000000bb000nnnn0000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000000g000000000bb0000000nnnn000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb000g0000000000000000bb000nnnn0000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbb0000000000000000000dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array4[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb0000000000c00g000000bb0000000000nnnn000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb000000000g0000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb000000nnnn0000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbb000000000000000g000dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array5[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0cg00000000000000000bb0nn00000000000000000bb000fff00000000000000bb000000nnn00000000000bb000000000fff00000000bb000000000000nnn00000bb000000000000000fff0dbb0000000000000000g0gdbbbbbbbbbbbbbbbbbbbbbbb";
    const char array6[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000c0g000000000bb00000000nnnn00000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000fff0000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb000000nnn00000000000bb0000000000fff0000000bb0000000000g000000000bb00000000nnn000000000bb00000000000000000000bb0000000000000000000dbb0000000000000000g00dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array7[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000g000c00000000000bb000nnnnnnnn000000000bb00000000000000000000bb0000000000ffff000000bb00000000000000g00000bb00nnnnnnnnnnnnn00000bb00000000000000000000bb00000000000000000000bb00g00000000000000000bb0nnnn000000000000000bb00000000000000000000bbfff00000000000000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbb0000000000000000000dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array8[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb000000e00g0000000000bb0000nnnnnn0000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbb0g000c000p00g000000dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array9[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000g000c00000000000bb000nnnnnnnn000000000bb00000000000000000000bb0000000000ff00000000bb0000000g000000000000bb00nnnnnnn00000000000bb00000000000000000000bb00000000000000000000bb00g00000000000000000bb0nnnn000000000000000bb00000000000000000000bbfff00000000000000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbb0000000000000000000dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array10[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb000000000000e00g0000bb0000000nnnnnnnnn0000bb00000000000000000000bb000ffff0000000000000bb00000000000000000000bb00000000000000000000bb000000g0c0p000000000bb00000nnnnnn000000000bb00000000000000000000bb00000000000000000000bb0000000000ffff000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbb000000g000000000000dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array11[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb00000000000000000000bb00000000000000000000bb0e000000000000000000bb0nn00000000000000000bb000n0000000000000000bb0000n000000000000000bb00000ng0000000000000bb000000n0000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0g000000000000000000bbnn000000000000000000bb00000000000000000000bb0000000000000000000dbb0000000c00p000g0000dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array12[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb000c0p0g000000000000bb000nnnnnn00000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000e0g0000000000bb000nnnnnnn0000000000bb00000000000000000000bb000000000ffff0000000bb00000000000000000000bb0000000000000000000dbb00000000000g0000000dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array13[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb000g0e00000000000000bb000nnnn0000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000000g000000000bb0000000nnnn000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb000fffn0000000000000bb00000000000000000000bb00000000000000000000bb00000000000fff000000bb00000000000000000000bb00000000000000000000bb0000000000000000000dbb000g0000c00000p0000dbbbbbbbbbbbbbbbbbbbbbbb";
    const char array14[] = "bbbbbbbbbbbbbbbbbbbbbbb00000000000000000000bb0c000000000000000000bbnnnnn000000000000000bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000n000000000000000bb00000nnnnnnn00000000bb00000000000000000000bb00000000000000000000bb00000000000000p0g000bb000000000000nnnnn000bb00000000000000000000bb00000000000000000000bb0000000000000000ff00bb00000000000000000000bb00000000000000000000bb00000000000000000000bb0000000e00g000000000bb00000nnnnnn00000000dbb000000000000g000000dbbbbbbbbbbbbbbbbbbbbbbb";

    size_t length1 = sizeof(array1) - 1; // Exclude null terminator
    size_t length2 = sizeof(array1) - 1; // Exclude null terminator
    uint16_t baseAddress = 0x1E00;       // Starting memory address

    std::map<std::string, std::vector<std::string>> tables;

    // Call the method for each array with unique numbers
    // processAndPrintAddresses(array2, length2, baseAddress, 2, tables);
    // processAndPrintAddresses(array3, length2, baseAddress, 3, tables);

    // processAndPrintAddresses(array1, length1, baseAddress, 1);
    // processAndPrintAddresses(array2, length2, baseAddress, 2);
    // processAndPrintAddresses(array3, length2, baseAddress, 3);
    // processAndPrintAddresses(array4, length2, baseAddress, 4);
    // processAndPrintAddresses(array5, length2, baseAddress, 5);
    // processAndPrintAddresses(array6, length2, baseAddress, 6);
    // processAndPrintAddresses(array7, length2, baseAddress, 7);
    // processAndPrintAddresses(array8, length2, baseAddress, 8);
    processAndPrintAddresses(array9, length2, baseAddress, 9);

    // processAndPrintAddresses(array10, length2, baseAddress, 10);
    // processAndPrintAddresses(array11, length2, baseAddress, 11);
    // processAndPrintAddresses(array12, length2, baseAddress, 12);
    // processAndPrintAddresses(array13, length2, baseAddress, 13);
    // processAndPrintAddresses(array14, length2, baseAddress, 14, tables);
    //
    // Print summary tables
    //  std::cout << "\n;--------------------------------------- DATA TABLES ---------------------------\n";
    // printSummaryTables(tables);

    return 0;
}
