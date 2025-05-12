### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ c070eac1-aa66-4f28-9759-7573d6ef9016
begin
	using BenchmarkTools
	function fill_vec(v::Vector, with::AbstractVector)
		for el in with
			push!(v, el)
		end
	end
	N = 10_000_000
end;

# ╔═╡ 2e05c22e-2a7b-11f0-2c63-db8a791d8b9b
md"""
# Arrays in julia

An array in julia is characterized by 2 parameters, the type of the elements it contains, and the number of dimensions (Vector, Matrix etc.).
"""

# ╔═╡ 609c2628-d27a-4fe2-8375-d92195a94508
md"""
In julia vectors are intended as columns, for example:
This is a vector:
```julia-repl
julia> [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3
```
While this is a 1x3 matrix
```julia-repl
julia> [1 2 3]
1×3 Matrix{Int64}:
 1  2  3
```
We can write multidimensonal arrays using `;`, in particular a singular `;` concatenates over the first dimension, `;;` concatenates over the second dimension, `;;;` over the third, etc
```julia-repl
julia> [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4
julia> [1; 2;; 3; 4;;; 5; 6;; 7; 8]
2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  3
 2  4

[:, :, 2] =
 5  7
 6  8
```

"""

# ╔═╡ 4f05d00e-24c1-4dc6-ac15-090e71c96a2c
md"""
In this examples julia automatically inferred the type, but we can also suggest it ourselves by writing the type before the square brackets
```julia-repl
julia> Float64[1, 2, 3]
3-element Vector{Float64}:
 1.0
 2.0
 3.0
```
"""

# ╔═╡ 0e89cbc5-8831-40b6-9caa-d85e9c0ff62e
md"""
# Construct empty arrays
Sometimes we have more complicated arrays, let's do an example constructing the Levi-civita 3-Tensor:
"""

# ╔═╡ f172a946-92db-4b45-8fad-4d68b179eda9
md"We start by creating an empty tensor filled with zeros. If we pass a type as first argument this will be used as type of the elements of the array. If no type is supplied the default type used is `Float64`"

# ╔═╡ 4e08256b-324b-42db-a1ee-6599fe833c9c
begin
	ε = zeros(Int64, 3, 3, 3)
	ε[1, 2, 3] = 1
	ε[1, 3, 2] = -1
	ε[2, 1, 3] = -1
	ε[2, 3, 1] = 1
	ε[3, 1, 2] = 1
	ε[3, 2, 1] = -1
	ε
end

# ╔═╡ 5da49df2-a346-4014-8395-14b4babf1a8f
md"""
If we don't want to initialize with zeros, we can use the `UndefInitializer`
"""

# ╔═╡ 5ea3d55c-a4e1-4f9f-a724-a0b1a6b16e06
let
	A = Matrix{Float64}(undef, 2, 2)
	A[1, 1] = 1
	A[2, 1] = 2
	A[1, 2] = 3
	A[2, 2] = 4
	A + A
end

# ╔═╡ f283b618-42ae-47ff-9bfe-ab1b519d5d24
md"""
Another common way to construct an array is by using array comprehensions
"""

# ╔═╡ 272ad82b-1459-4803-8735-9ba19774913c
[i + j for i ∈ 1:3, j ∈ 1:3]

# ╔═╡ 35059b9e-152d-44e6-bf6f-a3556b68e6e5
md"""
# Array Slicing
when we want to refer to a subpart of an array, we can do so by slicing the array
"""

# ╔═╡ 8b0781b4-c13f-41f7-a247-db71c2670c5a
begin
	A = rand(5, 5)
	A
end

# ╔═╡ d526a246-272c-43b8-bc20-9ab60dfc72af
A[:, 1:2:5]

# ╔═╡ 75d3aa3a-b409-407b-883e-8e5141ac816f
md"""
Note that when slicing a new array is created, we can prevent that by using the macro `@view`, which creates a view into the array (a `SubArray`), and the index gets recomputed into the original array 
"""

# ╔═╡ aca94212-d5c3-4011-a8cc-8511d4d44f13
let
	B = A[:, 1:2:5]
	B[1, 2] = -100
	A
end

# ╔═╡ 12cb5cd7-8439-4894-91fe-456a8aa5f818
let
	B = @view A[:, 1:2:5]
	B[1, 2] = -100
	A
end

# ╔═╡ 172451fa-4f0e-485d-90d4-b1127d764f76
md"We can use the keyword `end` to refer to the last element on that dimension"

# ╔═╡ 0c2940d9-7f68-4351-b382-f1310c4368e0
md"# Changing size of a `Vector`"

# ╔═╡ 139b2ff8-71f8-4fdf-a580-f7c6666f00b0
md"""
Sometimes we don't know the final size of a vector so we may star with an empty one and increase its size, or we simply want to concatenate vectors togheter. Let's start from the first, we can add elements to the end a vector using `push!`.
"""

# ╔═╡ a6ed1aa0-38bb-4855-8e09-185d20b0f949
let 
	v = Matrix[]
	push!(v, rand(1:10,2, 2))
end

# ╔═╡ 0c9d325c-61d7-4d12-b7f9-0517a694c5da
md"""
We can also delete elements at the end using `pop!`, this returns the element returned
"""

# ╔═╡ 98b685a5-a59d-47f3-9868-cbea4f35ecd0
let
	v = rand(1:10, 3)
	@show v
	@show pop!(v)
	@show v
end;

# ╔═╡ 73c2dc97-9e5d-4764-ab3e-f381a1e56d59
md"""
If we have 2 vectors, we may want to concatenate them, we have multiple ways to do that:
"""

# ╔═╡ 5ca30e08-20b4-4c9d-bd3c-18d8157366bd
md"""
`append!` increases the size of the first argument and then copies the elements of the second into the first
"""

# ╔═╡ 12cc021e-b99c-4cb6-9c25-d8b826e73b59
let 
	v1 = [1, 2, 3]
	v2 = [4, 5, 6]
	append!(v1, v2)
	@show v1
end;

# ╔═╡ d277946d-3093-49a2-9b7f-b593ca6b89a5
md"""
The functions `cat`, `hcat` and `vcat` instead does not modify in place the vector but they create a new one. These functions works with array of any dimension, not only vectors.
"""

# ╔═╡ 8aed5d9a-aea5-4297-8b5f-e85ffc7c1825
let
	v1 = [1, 2, 3]
	v2 = [4, 5, 6]
	@show cat(v1, v2; dims=1)
	@show cat(v1, v2; dims=2)
end;

# ╔═╡ 8654dee2-f987-4fe5-be92-c0b4d4a68dfb
md"""
`cat` with `dims=1` is equivalent to `vcat`, it increases the row size. Instead `dims=2` is equivalent to `hcat` and grows the number of columns.
"""

# ╔═╡ ce314e9c-ab48-4db0-acf8-0e2811ff2ed9
md"""
# hint the size of the vector
Resizing a vector is not a light weigth process, the reason is that it can involve a reallocation, when the array cannot grow in the ram cause it does not have enough space, it must be moved, therefore all the elements must be copied to the new location. In order to minimize the number of reallocations the size of the vector is often incremented exponentially.

julia allows to hint the size of a vector so that we can simplify this process.
"""

# ╔═╡ 113e3494-6af0-40d1-b127-c7a02c447d45
@benchmark $fill_vec(v, r) setup=(v=Float64[]; r=rand(N)) evals=1	

# ╔═╡ da6e2c33-687c-45c4-97ec-1acf74740e58
@benchmark $fill_vec(v, r) setup=(v=Float64[]; sizehint!(v, N); r=rand(N)) evals=1	

# ╔═╡ 01f458a3-e050-44ed-a12f-36b633e240db
md"""
!!! note
	If you don't know the size of a vector but you know that it is going to contain at maximum $N$ elements, use that as the value for the `sizehint!` otherwise you may not have an actual speedup. That is because the cost of coping $N$ elements is linear with the size $O(N)$, but if $N$ grows exponentially, the cost of performing multiple resizing is equivalent to the cost of the last resize. 
"""

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

julia_version = "1.11.5"
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
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

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
# ╟─2e05c22e-2a7b-11f0-2c63-db8a791d8b9b
# ╟─609c2628-d27a-4fe2-8375-d92195a94508
# ╟─4f05d00e-24c1-4dc6-ac15-090e71c96a2c
# ╟─0e89cbc5-8831-40b6-9caa-d85e9c0ff62e
# ╟─f172a946-92db-4b45-8fad-4d68b179eda9
# ╠═4e08256b-324b-42db-a1ee-6599fe833c9c
# ╟─5da49df2-a346-4014-8395-14b4babf1a8f
# ╠═5ea3d55c-a4e1-4f9f-a724-a0b1a6b16e06
# ╟─f283b618-42ae-47ff-9bfe-ab1b519d5d24
# ╠═272ad82b-1459-4803-8735-9ba19774913c
# ╟─35059b9e-152d-44e6-bf6f-a3556b68e6e5
# ╠═8b0781b4-c13f-41f7-a247-db71c2670c5a
# ╠═d526a246-272c-43b8-bc20-9ab60dfc72af
# ╟─75d3aa3a-b409-407b-883e-8e5141ac816f
# ╠═aca94212-d5c3-4011-a8cc-8511d4d44f13
# ╠═12cb5cd7-8439-4894-91fe-456a8aa5f818
# ╟─172451fa-4f0e-485d-90d4-b1127d764f76
# ╟─0c2940d9-7f68-4351-b382-f1310c4368e0
# ╟─139b2ff8-71f8-4fdf-a580-f7c6666f00b0
# ╠═a6ed1aa0-38bb-4855-8e09-185d20b0f949
# ╟─0c9d325c-61d7-4d12-b7f9-0517a694c5da
# ╠═98b685a5-a59d-47f3-9868-cbea4f35ecd0
# ╟─73c2dc97-9e5d-4764-ab3e-f381a1e56d59
# ╟─5ca30e08-20b4-4c9d-bd3c-18d8157366bd
# ╠═12cc021e-b99c-4cb6-9c25-d8b826e73b59
# ╟─d277946d-3093-49a2-9b7f-b593ca6b89a5
# ╠═8aed5d9a-aea5-4297-8b5f-e85ffc7c1825
# ╟─8654dee2-f987-4fe5-be92-c0b4d4a68dfb
# ╟─ce314e9c-ab48-4db0-acf8-0e2811ff2ed9
# ╠═c070eac1-aa66-4f28-9759-7573d6ef9016
# ╠═113e3494-6af0-40d1-b127-c7a02c447d45
# ╠═da6e2c33-687c-45c4-97ec-1acf74740e58
# ╟─01f458a3-e050-44ed-a12f-36b633e240db
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
