#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <iomanip>

void countHexCodes(const std::string &input)
{
    std::istringstream iss(input);
    std::string current, prev;
    int count = 0;

    // Variables to store color values and count values as strings
    std::string colorValues = "HEX ";
    std::string countValues = "HEX ";

    // Read the first hex code
    if (iss >> prev)
    {
        count = 1;
    }

    // Process the rest of the hex codes
    while (iss >> current)
    {
        if (current == prev)
        {
            count++;
        }
        else
        {
            // Append the previous color and its count to the respective strings
            colorValues += prev + " ";
            std::stringstream countStream;
            countStream << std::hex << std::uppercase << std::setw(2) << std::setfill('0') << count;
            countValues += countStream.str() + " ";

            prev = current;
            count = 1;
        }
    }

    // Append the last color and its count
    colorValues += prev + " ";
    std::stringstream countStream;
    countStream << std::hex << std::uppercase << std::setw(2) << std::setfill('0') << count;
    countValues += countStream.str() + " ";

    // Print the color values and count values
    std::cout << "colorValues:\n"
              << colorValues << std::endl;
    std::cout << "countValues:\n"
              << countValues << std::endl;
}

int main()
{
    std::string hexInput = "20 20 7A 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 20 20 7A 0D 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 7A 0D 20 20 20 20 76 76 76 76 76 76 76 76 76 76 76 76 76 0D 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 7A 0D 0D 20 20 20 50 52 45 53 53 20 41 20 54 4F 20 50 4C 41 59 00";

    countHexCodes(hexInput);
    return 0;
}
