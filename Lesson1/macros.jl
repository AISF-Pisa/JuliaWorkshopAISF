### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ f9c1faf4-0d5a-11f0-29d4-172c4c5f48a2
md"""
# Macros
Macros in Julia can be used 2 main modes, either like functions, or used to modify the behaviour of the code (more correctly, it takes as input the AST and returns a new AST so they act at the pasing level). Macros take arguments, which are separated by whitespaces, and not by comma. The easiest example of macro is the `@show`, which works like `println` but gives more informations, like the variable name, making it a valuable resource for debugging.
"""

# ╔═╡ 4e88a555-19c9-43c6-a782-ab89a0ce2bee
begin 
	x = 3; y = 2;
	println(x, " ", y);
	@show x y;
end

# ╔═╡ e07aebe5-e6c2-4871-8b75-8a93a1798187
#Usually the most utilized are `@benchmark` for a full benchmark, `@btime` if we are interested in the time the process has used, `@ballocate` if we are interested in the amount of memory allocated, `@ballocations`
md"""
Other macros worth of mention are:
- `@inbounds`: this allows to skip the bounds check when accessing an element of an array, potentially speeding up the computation.
- `@inline` or `@noinline`: to inline a function means to, instead of calling the function, directly insert the function body in the code. Function declered with `@inline` get inlined when called, this is done by default for small functions, we can prevent a function to be inlined by using `@noinline` in the declaration.
- Benchmark macros: often we may want to benchmark our code, this can be done with the [`BenchmarkTools`](https://juliaci.github.io/BenchmarkTools.jl/stable/) package which has a series of macros that can be used for that pourpose, we will say more about it later.
- Logging macros: logging is a way to display informations about a running program, in Julia it is implemented using macros, we will say more about it later.
"""

# ╔═╡ Cell order:
# ╟─f9c1faf4-0d5a-11f0-29d4-172c4c5f48a2
# ╠═4e88a555-19c9-43c6-a782-ab89a0ce2bee
# ╟─e07aebe5-e6c2-4871-8b75-8a93a1798187
