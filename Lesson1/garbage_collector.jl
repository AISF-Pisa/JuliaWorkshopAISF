### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 44cc0d02-0edf-11f0-0aa9-733055525f58
md"""
# Garbage Collector
In some low level programming languages like C and Fortran, whenever we allocate memory is our responsability to free it when we don't need it anymore. This can easily lead to memory leaks since it is not rare to miss something. Modern programming languages usually use a garbage collector, which will handle the memory for us, but it requires a little understanding on how memory is handled.
"""

# ╔═╡ 58c0aad8-c570-499d-9d03-a8dbc5a3a3c8
md"""
Let's start by making an example. Let's create 2 random matrices of size $1024$( =$2^{10}$) and multiply them.
```julia
A = rand(1024, 1024)
B = rand(1024, 1024)
A = A * B
```
rand creates a matrix of ``2^{10}*2^{10}=2^{20}`` elements, each of type Float64 (equivalent to 8 bytes), this means that a block $B_1$ of size $2^{20}*2^3 B = 8 MiB$ is created in memory. 

So the first line creates a block $B_1$ and A refers to this block, in the second line another block $B_2$ is created and B refers to it, when we perform `A * B` a third block $B_3$ is created in memory, then we make A refer to it with the assignment $A = ...$. 

At the end of the execution we would have 3 blocks and A refers to $B_3$ while $B$ refers to $B_2$, this means that $B_1$ is not referred anymore, such block is said **Unreachable**. 

The garbage collector only frees the blocks of memory that are unreachable, but it doesn't do so as soon as they become unreachable since it would require a big overhead, instead the GC tries to infer the best moment to run and free the memory, we can suggest to it when to run by calling the function `GC.gc()`, but we can only do as much, we can't make it run when we want. Another useful setting for the GC is the option `heap-size-hint`, if we start julia as `julia --heap-size-hint=8G`, the GC will try to keep the used memory below that level.
"""

# ╔═╡ a2ee7f35-3c99-43f3-8c4d-e87456166690
md"""
This also means that we should try to don't keep references to blocks that we want the GC to collect, this can be achieved by a proper use of the scopes, but we also need to better understand how assignment and copies work.
"""

# ╔═╡ e725d810-dc02-419c-99ec-706d5a47e615
md"""
# Assignments
As we said, when we execute `rand(N, M)` a block of memory is created, than by doing `A = rand(N, M)` we make the variable `A` refer to that block, but the variable and the block are still to separate entities, we can change the block to which A refer as we have seen before, but we can also make more variables refer to the same block. In lagnuages like Python and Julia this is done by the assignment operator.

!!! note
	In other languages, the assigment can have different meanings, so always check!
"""

# ╔═╡ 10cdeca9-f1d2-4ef1-b50c-4f1118a64e22
let
	A = [1, 2, 3] 	# this creates a block in memory and A referso to it
	B = A 			# now B refers to the same block in memory
	B[1] = -100 	# we can check that by changing B also A changes
	A
end

# ╔═╡ d9453098-c926-4e1c-af83-22129740db4b
md"""
# Copy Data
In Julia there are 2 types of copies that can be performed, the first is a shallow copy, performed by the function `copy`, while the second is a deep copy performed by the function `deepcopy`. To better understand them consider the following example.
"""

# ╔═╡ 2aea29d9-0b9b-4e03-8453-59a44e2f6cfc
let
	mutable struct MyF
		data::Float64
	end
	A = MyF[MyF(1), MyF(2)]
	copy_A = copy(A)
	copy_A[1].data = -10 	# this operation affects A since we are modifing internal data
	@show A

	copy_A[1] = MyF(0)		# this does not affect A
	@show A

	deep_A = deepcopy(A)	# this creates a fully indipendent object
	deep_A[1].data = 100
	@show A
end

# ╔═╡ 0988152f-8eda-4f51-be59-f0337dc983b2
md"""
When we execute `A = MyF[MyF(1), MyF(2)]` in memory there are 3 blocks: A block for `MyF(1)`, a block for the array composed of 2 references, the first element refers to the position of the block `MyF(1)`, the second to the position `MyF(2)`

```
Array (contiguous block):
+-------------------+-------------------+
| Pointer to MyF(1) | Pointer to MyF(2) |
+-------------------+-------------------+

Heap (separate objects):
MyF(1): +-------------------+
        | Float64 (1.0)     |
        +-------------------+

MyF(2): +-------------------+
        | Float64 (2.0)     |
        +-------------------+
```
"""

# ╔═╡ ab8d3bbd-a719-4352-8ed8-6dac22b5bc70
md"""
when we perfom a shallow copy, only the block containing the references to `MyF(1)` and `MyF(2)` is copied, but not the `MyF` obbjects themself, this means that by modifing them as in `copy_A[1].data` we are affecting also A. Viceversa if we modifiy to which block in memory the array refers, we are not modifing A since the arrays are different.

To better understand this, let's try to do a graphical rappresentation
```
	A -> Block_A
	Block_A[1] -> Block_MyF1(1.0)
	Block_A[2] -> Block_MyF2(2.0)

	copy_A -> Block_copyA 				# it has a different block
	Block_copyA[1] -> Block_MyF1(1.0)	# but refers to the same objects
	Block_copyA[2] -> Block_MyF2(2.0)

	deepcopy_A -> Block_deepcopyA 			# it has a different block
	Block_deepcopyA[1] -> Block_MyF3(1.0)	# and refers to different objects
	Block_deepcopyA[2] -> Block_MyF4(2.0)
```
"""

# ╔═╡ c9023d04-014e-42bd-a828-f54605ad0d95
md"""
In julia this reflects also in the names of the functions. A function that does not end with a `!` will not change the data of A. A function that changes the structure of A (does not change the leaves) will end with a single `!`, a function that changes also the leaves will end with `!!`.
"""

# ╔═╡ 00216299-8a55-4248-a78f-96b91b2a456d
md"""
# Examples
here there are some examples to prevent unwanted refs to memory we want to be freed.

Suppose we want to perform a multiplication between 2 matrices A and B and assign the result to C. After that we don't need A and B anymore so we want delete that reference. A first way to do it is by make A and B refer to `nothing`, this does the job but doesn't look really good
"""

# ╔═╡ c0e4f4db-4b64-4463-a9a3-d7fc5cfa2639
let
	A = rand(3, 3)
	B = rand(3, 3)
	C = A * B
	A = B = nothing
end

# ╔═╡ 4d0903f2-7e7e-4fb0-a8d1-68236f69402e
md"""
A better way to achieve this is with a proper usage of the scopes. If the only variables that refer to a memory block are inside a scope, once that scope is closed those blocks become unreachable
"""

# ╔═╡ 00fc71e8-e5b2-484d-b594-fc84f5490ce5
let
	C = let
		A = rand(3, 3)
		B = rand(3, 3)
		A * B
	end
end

# ╔═╡ Cell order:
# ╟─44cc0d02-0edf-11f0-0aa9-733055525f58
# ╟─58c0aad8-c570-499d-9d03-a8dbc5a3a3c8
# ╟─a2ee7f35-3c99-43f3-8c4d-e87456166690
# ╟─e725d810-dc02-419c-99ec-706d5a47e615
# ╠═10cdeca9-f1d2-4ef1-b50c-4f1118a64e22
# ╟─d9453098-c926-4e1c-af83-22129740db4b
# ╠═2aea29d9-0b9b-4e03-8453-59a44e2f6cfc
# ╟─0988152f-8eda-4f51-be59-f0337dc983b2
# ╟─ab8d3bbd-a719-4352-8ed8-6dac22b5bc70
# ╟─c9023d04-014e-42bd-a828-f54605ad0d95
# ╟─00216299-8a55-4248-a78f-96b91b2a456d
# ╠═c0e4f4db-4b64-4463-a9a3-d7fc5cfa2639
# ╟─4d0903f2-7e7e-4fb0-a8d1-68236f69402e
# ╠═00fc71e8-e5b2-484d-b594-fc84f5490ce5
