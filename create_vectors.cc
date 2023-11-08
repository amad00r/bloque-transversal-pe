#include <iostream>
#include <fstream>
#include <random>
#include <cerrno>
#include <filesystem>

using namespace std;
namespace fs = std::filesystem;

#define VECTOR_MIN_SIZE 2
#define VECTOR_MAX_SIZE 1 << 20

void usage(char *name) {
    cout << "Usage: " << name << " NVECTORS SEED" << endl;
    exit(EXIT_SUCCESS);
}

void check_erange() {
    if (errno == ERANGE) {
        perror("error");
        exit(EXIT_FAILURE);
    }
}

int main(int argc, char **argv) {
    if (argc != 3) usage(argv[0]);

    unsigned nvectors = strtol(argv[1], NULL, 10);
    check_erange();
    unsigned seed = strtol(argv[2], NULL, 10);
    check_erange();

    mt19937 rng(seed);
    uniform_int_distribution<unsigned> size_distribution(VECTOR_MIN_SIZE, VECTOR_MAX_SIZE);

    string dir = "./_" + to_string(seed);
    fs::create_directory(dir);
    for (unsigned i = 0; i < nvectors; ++i) {
		ofstream file(dir + "/_" + to_string(i) + ".vector");
        if (not file.is_open()) {
            cerr << "error: could not open the file" << endl;
            exit(EXIT_FAILURE);
        }
        
		unsigned size = size_distribution(rng);
		file << size << " ";
		for (unsigned j = 0; j < size; ++j)
			file << int(rng()) << " ";

        file.close();
	}
}
