script_dir=$(dirname "$(realpath "$0")")
cd "$script_dir"

make all

bin/vectors_generator $1 $2

bin/test_launcher _$1_$2 bin/vector_test src/python_vector_test/vector_test.py