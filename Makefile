all: create_vectors test_mergesort

create_vectors: create_vectors.cc
	g++ -std=c++20 -Wall -Wextra -Werror -o create_vectors create_vectors.cc

test_mergesort: test_mergesort.cc
	g++ -std=c++20 -Wall -Wextra -Werror -o test_mergesort test_mergesort.cc

clean:
	rm create_vectors test_mergesort