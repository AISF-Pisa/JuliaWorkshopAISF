import numpy as np
import timeit
import sys

def rand_mul(size):
    a = np.random.rand(size, size)
    b = np.random.rand(size, size)
    return np.dot(a, b)

def bench_mul(start, stop, out=sys.stdout):
    for i in range(start, stop + 1):
        execution_times = timeit.repeat(lambda: rand_mul(i), repeat=10, number=8)
        min_execution_time = min(execution_times)
        print(f"{i}\t{min_execution_time}", file=out)

if __name__ == "__main__":
    with open("rand_mul.py.dat", "w") as file:
        bench_mul(1, 100, out=file)  # Example range for benchmarking