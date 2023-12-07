#include <iostream>
#include <fstream>
#include <random>
#include <cerrno>
#include <filesystem>

using namespace std;
namespace fs = std::filesystem;

#define CHECK_ERANGE    if (errno == ERANGE) {     \
                            perror("error");       \
                            exit(EXIT_FAILURE);    \
                        }                          \

#define VECTOR_MIN_SIZE 2
#define VECTOR_MAX_SIZE 1 << 20

void usage(const char *name) {
    cout << "Usage: " << name << " SEED NVECTORS" << endl;
    exit(EXIT_FAILURE);
}

void try_create_dir(const fs::path &dir) {
    if (not fs::create_directory(dir)) {
        cerr << "error: cannot create directory `" << dir.string() << "`" << endl;
        exit(EXIT_FAILURE);
    }
}

int main(int argc, char **argv) {
    if (argc != 3) usage(argv[0]);

    unsigned seed = strtol(argv[1], NULL, 10);
    CHECK_ERANGE;
    unsigned nvectors = strtol(argv[2], NULL, 10);
    CHECK_ERANGE;
    fs::path dir("_" + string(argv[1]) + "_" + string(argv[2]));
    if (fs::is_directory(dir)) {
        cerr << "error: directory `" << dir.string() << "` already exists" << endl;
        return EXIT_FAILURE;
    }
    try_create_dir(dir);
    fs::path vectors_dir(dir / "vectors");
    try_create_dir(vectors_dir);

    mt19937 rng(seed);
    uniform_int_distribution<unsigned> size_distribution(VECTOR_MIN_SIZE, VECTOR_MAX_SIZE);

    for (unsigned i = 0; i < nvectors; ++i) {
		ofstream file(vectors_dir.string() + "/_" + to_string(i) + ".vector");
        if (not file.is_open()) {
            cerr << "error: could not open the file" << endl;
            return EXIT_FAILURE;
        }
        
		unsigned size = size_distribution(rng);
		file << size;
		for (unsigned j = 0; j < size; ++j)
			file << " " << int(rng());

        file.close();
	}
}
