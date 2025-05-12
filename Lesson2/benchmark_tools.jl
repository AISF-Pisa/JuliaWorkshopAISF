### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ cd37f8b2-ef67-4faf-9c82-6a49adc2e92e
using BenchmarkTools

# ╔═╡ 61f9ac14-0f10-11f0-3773-89939e07eb17
md"""
# Benchmark a function
To benchmark our program one of the best ways is to use the `BenchmarkTools` library of julia. It has 6 main macros that can be used:

- `@benchmark`: generic macro for benchmark
- `@btime`: this executes an expression, printing the time it took to execute and the memory allocated before returning the value of the expression.
- `@btimed`: this macro executes an expression and returns the value of the expression, the minimum elapsed time in seconds, the total bytes allocated, the number of allocations, and the garbage collection time in seconds during the benchmark.
- `@belapsed`: this returns the minimum elapsed time (in seconds) to execute a given expression.
- `@ballocated`: this returns the minimum number of bytes allocated when executing a given expression.
- `@ballocations`: this macro evaluates an expression, discarding the resulting value, and returns the total number of allocations made during its execution.

Each of them supports different optional variables, the most used are usually `samples` to decide on how many samples the benchmark should be performed, and `evals` which sets how many evaluations should be performed for each sample
"""

# ╔═╡ a16d4975-82bb-4ca7-967d-639715e4e208
begin
	N = 100
	A = rand(N, N)
	B = rand(N, N)
end;

# ╔═╡ 028e0e39-6030-42c5-b9eb-e1aba552d53d
@benchmark A * B

# ╔═╡ 644a5e28-1620-4720-ba8f-35f9cff91393
@btime A * B

# ╔═╡ f8b5e801-5d57-4c3a-aaa2-b360b1d9e951
@btimed A * B

# ╔═╡ 718e76ed-7cd4-4150-a254-9730cc51d255
@belapsed A * B

# ╔═╡ 37714f84-2d97-4f4c-9e82-e2f992f135d0
@ballocated A * B

# ╔═╡ 229aba13-52b6-402d-91b0-22d74011083b
@ballocations A * B

# ╔═╡ 5a546075-4c4d-413a-b182-9612488445ee
@benchmark A * B samples=100 evals=10

# ╔═╡ e126c809-51f2-437d-a02a-1ce3837da351
md"""
# Interpolate variables
If the expression you want to benchmark depends on external variables, you should use $ to "interpolate" them into the benchmark expression to avoid the problems of benchmarking with globals. Essentially, any interpolated variable `$x` or expression $(...) is "pre-computed" before benchmarking begins:
"""

# ╔═╡ 238e34e0-baf5-472f-8513-13028afa4f8c
C = rand(3,3);

# ╔═╡ 0bb623c7-9e17-4d79-bea7-ee8fa265f80f
@btime inv($C); 	# we interpolate the global variable C with $C. The variable C is found before the function inv is applied

# ╔═╡ 6d170aac-5357-4dc6-8c3b-0dc11e1cecbb
@btime inv($(rand(3,3)));  # interpolation: the rand(3,3) call occurs before benchmarking

# ╔═╡ fed0cd42-1ad7-47f6-80bc-dfd09a689878
@btime inv(rand(3,3));     # the rand(3,3) call is included in the benchmark time

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"

[compat]
BenchmarkTools = "~1.6.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.4"
manifest_format = "2.0"
project_hash = "2a7392fbc86bcb1608a6d4c3fafc922aa7051ef7"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.BenchmarkTools]]
deps = ["Compat", "JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "e38fbc49a620f5d0b660d7f543db1009fe0f8336"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.6.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Profile]]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"
"""

# ╔═╡ Cell order:
# ╟─61f9ac14-0f10-11f0-3773-89939e07eb17
# ╠═cd37f8b2-ef67-4faf-9c82-6a49adc2e92e
# ╠═a16d4975-82bb-4ca7-967d-639715e4e208
# ╠═028e0e39-6030-42c5-b9eb-e1aba552d53d
# ╠═644a5e28-1620-4720-ba8f-35f9cff91393
# ╠═f8b5e801-5d57-4c3a-aaa2-b360b1d9e951
# ╠═718e76ed-7cd4-4150-a254-9730cc51d255
# ╠═37714f84-2d97-4f4c-9e82-e2f992f135d0
# ╠═229aba13-52b6-402d-91b0-22d74011083b
# ╠═5a546075-4c4d-413a-b182-9612488445ee
# ╟─e126c809-51f2-437d-a02a-1ce3837da351
# ╠═238e34e0-baf5-472f-8513-13028afa4f8c
# ╠═0bb623c7-9e17-4d79-bea7-ee8fa265f80f
# ╠═6d170aac-5357-4dc6-8c3b-0dc11e1cecbb
# ╠═fed0cd42-1ad7-47f6-80bc-dfd09a689878
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
