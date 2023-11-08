#include <filesystem>
#include <iostream>
#include <vector>
#include <fstream>
#include "mergesort.hh"

using namespace std;
namespace fs = std::filesystem;

void usage(char *name) {
    cout << "Usage: " << name << " DIRNAME" << endl;
    exit(EXIT_SUCCESS);
}

int main(int argc, char **argv) {
    if (argc != 2) usage(argv[0]);
    
    fs::path dir(argv[1]);
    if (not fs::is_directory(dir)) {
        cerr << "error: directory does not exist" << endl;
        exit(EXIT_FAILURE);
    }

    for (const auto &entry : fs::directory_iterator(dir)) {
        if (fs::is_regular_file(entry)) {
            ifstream file(entry.path());
            if (not file.is_open()) {
                cerr << "error: could not open the file" << endl;
                exit(EXIT_FAILURE);
            }

            unsigned size;
            file >> size;
            vector<int> v(size);

            for (unsigned i = 0; i < size; ++i) file >> v[i];
        
            // TODO: ordenar y contar tiempo
        
        }
    }
}