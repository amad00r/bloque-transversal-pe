from pathlib import Path
from sys import argv, exit
from mergesort import mergesort
from time import perf_counter_ns

if len(argv) != 2:
    print(f"Usage: {argv[0]} DIR")
    exit(1)

directory = Path(argv[1])
if not directory.is_dir():
    print("error: directory does not exist")
    exit(1)

print("nelements duration_ms")
for file_path in directory.iterdir():
    if file_path.is_file():
        with open(file_path, 'r') as file:
            vector = list(map(int, file.read().split()))
            size = vector.pop(0)
            start = perf_counter_ns()
            mergesort(vector)
            duration = int((perf_counter_ns() - start)/1_000_000)
            print(f"{size} {duration}")