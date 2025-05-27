#include "json/single_include/nlohmann/json.hpp"

#include <iostream>
#include <fstream>
#include <fcntl.h>
#include <unistd.h>

using json = nlohmann::json;

//Function mapping byte inner bits position (MSB position is 0, LSB position is 7) to reversed order
constexpr unsigned rev8(unsigned x)
{
    /*
     0 -->  7
     1 -->  6
     2 -->  5
     3 -->  4
     4 -->  3
     5 -->  2
     6 -->  1
     7 -->  0
     8 --> 15
     9 --> 14
    10 --> 13
    11 --> 12
    ...    
    */

    //Equivalent instructions (two last instructions have exactly the same assembly code)
    //return 7 - (x % 8) + (x / 8) * 8;
    //return 7 - (x & 0x7U) + (x / 8) * 8;
    //return (7 + (x/8)*8) - (x & 0x7U);
    //return (x & ~0x7U) | ~(x & 0x7U);
    return (x | 0x7U) - (x & 0x7U);
}

int main(int argc, char ** argv)
{
    if(argc != 5)
    {
        std::cout << "Usage: reorder_index <order> <index_name> <input> <output>\n\norder\t\tBinary serialized order\nindex_name\tName of corresponding index\ninput\t\tInput JSON file\noutput\t\tOutput JSON file\n\n<input> and <output> can be the same (corresponding file descriptors are not opened simultaneously).\n" << std::endl;
        return 1;
    }

    std::string order_path = argv[1];
    std::string index_name = argv[2];
    std::string in_path = argv[3];
    std::string out_path = argv[4];

    //Open file descriptor on input json file
    std::ifstream fdin(in_path, std::ios::in);

    //Deserialize JSON file
    json indexjson = json::parse(fdin);
    fdin.close();
    
    //Check if JSON file has "index" as 0-depth key
    if(!indexjson.contains("index"))
        throw std::runtime_error("Index was not recognized.");

    //Check if JSON file -> ["index"] has <index_name> as key
    if(!indexjson["index"].contains(index_name))
        throw std::runtime_error("Index '" + index_name + "' doesn't exist within JSON file.");

    if(!indexjson["index"][index_name].contains("nb_samples"))
        throw std::runtime_error("Index '" + index_name + "' has no field 'nb_samples'.");

    //Get current number of samples
    const unsigned SAMPLES = indexjson["index"][index_name]["nb_samples"].get<unsigned>();
    const unsigned COLUMNS = (SAMPLES+7)/8*8;

    //Open file descriptor on binary serialized order file
    int fdorder = open(order_path.c_str(), O_RDONLY);
    
    if(fdorder < 0)
        throw std::runtime_error("Couldn't open '" + order_path + "'.");

    unsigned * order = new unsigned[COLUMNS];
    
    //Fetch order in memory
    read(fdorder, reinterpret_cast<char*>(order), sizeof(unsigned)*COLUMNS);
    close(fdorder);

    //Read samples from index.json and put them in a vector
    std::vector<std::string> samples = indexjson["index"][index_name]["samples"].get<std::vector<std::string>>();

    //Replace each element by the one that should be placed according to the permutation
    for(unsigned i = 0; i < SAMPLES; ++i)
        indexjson["index"][index_name]["samples"][i] = samples[rev8(order[rev8(i)])];

    //Free order from memory
    delete[] order;

    //Apply modifications to JSON file
    std::ofstream fdout(out_path, std::ofstream::out);
    fdout << std::setw(4) << indexjson << std::endl;
    fdout.close();
}