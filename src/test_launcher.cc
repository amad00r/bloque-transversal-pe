#include <iostream>
#include <filesystem>
#include <fstream>
#include <random>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>

using namespace std;
namespace fs = std::filesystem;

void usage(const char *name) {
    cout << "Usage: " << name << " SEED VECTORS_DIR CPP_TEST_PATH PYTHON_TEST_PATH" << endl;
    exit(EXIT_FAILURE);
}

int try_syscall(int ret_code) {
    if (ret_code < 0) {
        perror("error");
        exit(EXIT_FAILURE);
    }
    return ret_code;
}

void check_dir_existence(const fs::path &dir) {
    if (not fs::is_directory(dir)) {
        cerr << "error: directory `" << dir.string() << "` is not valid" << endl;
        exit(EXIT_FAILURE);
    }
}

void check_file_existence(const char *file) {
    if (not fs::is_regular_file(file)) {
        cerr << "error: file `" << file << "` is not valid" << endl;
        exit(EXIT_FAILURE);
    }
}

unsigned read_u32(int fd) {
    unsigned n = 0;
    char c;
    while (try_syscall(read(fd, &c, sizeof(c)))) {
        if (c < '0' or c > '9') return n;
        n *= 10;
        n += c - '0';
    }
    return n;
}

int main(int argc, char **argv) {
    if (argc != 5) usage(argv[0]);

    unsigned seed = strtol(argv[1], NULL, 10);
    if (errno == ERANGE) {
        perror("error");
        exit(EXIT_FAILURE);
    }
    fs::path dir(argv[2]);
    check_dir_existence(dir);
    fs::path vectors_dir(dir / "vectors");
    check_dir_existence(vectors_dir);
    check_file_existence(argv[3]);
    check_file_existence(argv[4]);

    mt19937 rng(seed);
    uniform_int_distribution<unsigned> cpp_python_order(0, 1);

    ofstream results_file(dir.string() + "/results.csv");
    if (not results_file.is_open()) {
        cerr << "error: could not open the file" << endl;
        return EXIT_FAILURE;
    }
    results_file << "vector_id,vector_size,cpp_sorting_time_ms,python_sorting_time_ms" << endl;
    cout << "vector_id,vector_size,cpp_sorting_time_ms,python_sorting_time_ms" << endl;

    for (const auto &entry : fs::directory_iterator(vectors_dir)) {
        unsigned size;
        ifstream(entry.path()) >> size;

        unsigned cpp_ms, python_ms;
        int language_order = cpp_python_order(rng);             // 0 means cpp, 1 means python

        for (int i = 0; i < 2; ++i) {
            int pipefd[2];
            try_syscall(pipe(pipefd));

            int pid = try_syscall(fork());
            if (pid == 0) {
                try_syscall(close(pipefd[0]));
                try_syscall(dup2(pipefd[1], 1));
                try_syscall(close(pipefd[1]));
                int fd = try_syscall(open(entry.path().string().c_str(), O_RDONLY));
                try_syscall(dup2(fd, 0));
                try_syscall(close(fd));
                results_file.close();
                if (language_order) try_syscall(execlp("python3", "python3", argv[4], nullptr));
                else try_syscall(execlp(argv[3], argv[3], nullptr));
            }

            try_syscall(close(pipefd[1]));
            int status;
            try_syscall(waitpid(pid, &status, 0));
            if (not WIFEXITED(status) or WEXITSTATUS(status) != 0) {
                cerr << "error: error running test" << endl;
                return EXIT_FAILURE;
            }

            if (language_order) python_ms = read_u32(pipefd[0]);
            else cpp_ms = read_u32(pipefd[0]);

            try_syscall(close(pipefd[0]));

            language_order = not language_order;
        }

        results_file << entry.path().stem().string() << "," << size << "," << cpp_ms << "," << python_ms << endl;
        cout << entry.path().stem().string() << "," << size << "," << cpp_ms << "," << python_ms << endl;
    }

    results_file.close();
}