using BenchmarkTools

function rand_mul(size::Int)
    a = rand(size, size)
    b = rand(size, size)
    return a * b
end

function bench_mul(start::Int, stop::Int; samples::Int=10_000, evals::Int=1, out::IOStream=stdout)
    for i in start:stop
        println(out, i, "\t", @belapsed rand_mul($i) samples = samples evals = evals)
    end
end

file = open("rand_mul.jl.dat", "w")
bench_mul(1, 100; samples=10, evals=8, out=file)
close(file)