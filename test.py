from pathlib import Path
from sys import argv, exit
from subprocess import call, PIPE
from tqdm import tqdm
from shutil import rmtree

if len(argv) != 3:
    print(f"Usage: {argv[0]} NVECTORS SEED")
    exit(1)

directory = Path(f"_{argv[2]}")
if directory.exists():
    rmtree(directory)
directory.mkdir(exist_ok = True)
vectors = Path(f"_{argv[2]}/vectors")
vectors.mkdir(exist_ok = True)
results = Path(f"_{argv[2]}/results")
results.mkdir(exist_ok = True)

with tqdm(total = 6, desc = "[GENERATING C++ BINARIES]") as pbar:
    call(["make"], cwd = "c++", stdout=PIPE, stderr=PIPE)
    
    pbar.update(1)
    pbar.set_description("[GENERATING VECTORS]")
    call(["./create_vectors", argv[1], argv[2], vectors.resolve()], cwd = "c++", stdout=PIPE, stderr=PIPE)

    pbar.update(1)
    pbar.set_description("[CREATING RESULT FILES]")
    call(["touch", "c++_results.csv", "python_results.csv"], cwd = results, stdout=PIPE, stderr=PIPE)

    pbar.update(1)
    pbar.set_description("[TESTING VECTORS WITH C++]")
    call(f"./test_mergesort {vectors.resolve()} > {results.resolve() / 'c++_results.csv'}", cwd = "c++", shell = True, stdout=PIPE, stderr=PIPE)
    
    pbar.update(1)
    pbar.set_description("[CLEANING C++ BINARIES]")
    call(["make", "clean"], cwd = "c++", stdout=PIPE, stderr=PIPE)

    pbar.update(1)
    pbar.set_description("[TESTING VECTORS WITH PYTHON]")
    call(f"python3 test_mergesort.py {vectors.resolve()} > {results.resolve() / 'python_results.csv'}", cwd = "python", shell = True, stdout=PIPE, stderr=PIPE)

    pbar.update(1)
    pbar.set_description("[COMPLETED SUCCESSFULLY]")
