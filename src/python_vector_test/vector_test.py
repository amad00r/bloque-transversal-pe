from sys import stdin
from mergesort import mergesort
from time import perf_counter_ns

vector = list(map(int, stdin.read().split()))
size = vector.pop(0)
start = perf_counter_ns()
mergesort(vector)
end = perf_counter_ns()
print(int((end - start)/1_000_000))             # time measured in ms