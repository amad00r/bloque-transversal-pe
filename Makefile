CC 	    = g++
CFLAGS  = -std=c++20 -Wall -Wextra -Werror
SRC_DIR = src
BIN_DIR = bin

all: $(BIN_DIR)/test_launcher $(BIN_DIR)/vectors_generator $(BIN_DIR)/vector_test

$(BIN_DIR)/test_launcher: $(SRC_DIR)/test_launcher.cc
	$(CC) $(CFLAGS) -o $(BIN_DIR)/test_launcher $(SRC_DIR)/test_launcher.cc

$(BIN_DIR)/vectors_generator: $(SRC_DIR)/vectors_generator.cc
	$(CC) $(CFLAGS) -o $(BIN_DIR)/vectors_generator $(SRC_DIR)/vectors_generator.cc

$(BIN_DIR)/vector_test: $(SRC_DIR)/cpp_vector_test/vector_test.cc
	$(CC) $(CFLAGS) -o $(BIN_DIR)/vector_test $(SRC_DIR)/cpp_vector_test/vector_test.cc

clean:
	rm $(BIN_DIR)/test_launcher $(BIN_DIR)/vectors_generator $(BIN_DIR)/vector_test