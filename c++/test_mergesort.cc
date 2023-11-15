#include <filesystem>
#include <iostream>
#include <vector>
#include <fstream>
#include <chrono>
#include "mergesort.hh"

using namespace std;
namespace fs = std::filesystem;

void usage(char *name) {
    cout << "Usage: " << name << " DIR" << endl;
    exit(EXIT_SUCCESS);
}

int main(int argc, char **argv) {
    if (argc != 2) usage(argv[0]);
    
    fs::path dir(argv[1]);
    if (not fs::is_directory(dir)) {
        cerr << "error: directory does not exist" << endl;
        exit(EXIT_FAILURE);
    }

    cout << "nelements duration_ms" << endl;

    for (const auto &entry : fs::directory_iterator(dir)) {
        if (fs::is_regular_file(entry)) {
            ifstream file(entry.path());

            unsigned size;
            file >> size;
            vector<int> v(size);

            for (unsigned i = 0; i < size; ++i) file >> v[i];
        
            auto start = chrono::high_resolution_clock::now();
            mergesort(v);
            auto duration = chrono::duration_cast<chrono::milliseconds>(chrono::high_resolution_clock::now() - start);

            cout << size << " " << duration.count() << endl;
        }
    }
}