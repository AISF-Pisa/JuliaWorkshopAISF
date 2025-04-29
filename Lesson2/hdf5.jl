### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ 18577da3-5c9b-4a6a-b07b-e91c6dcf3389
using HDF5

# ╔═╡ 2921f084-0fa3-11f0-1bf6-e3a978cb7fc5
md"""
# HDF5
HDF5 (Hierarchical Data Format version 5) files are a way to store and organize large amounts of data. Think of them as a "super-powered" file format for scientific and technical data.

Here’s an easy breakdown:

- Hierarchical Structure: HDF5 files are like a file system inside a single file. They can contain "groups" (like folders) and "datasets" (like files with data).
- Efficient Storage: They are designed to handle large datasets efficiently, both in terms of storage space and speed of access.
- Supports Metadata: You can attach extra information (attributes) to datasets or groups, like labels or descriptions.
- Cross-Platform: HDF5 files work on different operating systems and programming languages, making them great for sharing data.

In short, HDF5 files are perfect for storing complex, large-scale data in an organized and portable way.
"""

# ╔═╡ b06b5ab2-6548-4e57-849e-60593ca9aa8b
md"""
Let's create our file. The function to open files is `h5open`, and based on the argument we pass as `mode` we can:
- "r" read only
- "r+" read and write
- "cw" read and write, create a file if it doesn't exist, don't overwrite existing data.
- "w" read and write, create a file if it doesn't exist, overwrite existing data.

Like `open` , also `h5open` support the syntax
```julia
h5open("foo.h5","w") do h5
    h5["foo"]=[1,2,3]
end
```
which should be preferred in most cases since it will handle the closure of the file in case an error happens.
"""

# ╔═╡ 4a923ddf-432e-46ff-8fb1-c4a0f3fa0f07
begin
	filename = tempname()*".h5"	
	file = h5open(filename, "w")
end

# ╔═╡ a9f7dcbe-33da-4c42-864f-837203b07240
md"""
suppose we are performing some time evolution and we want to save the state of the system for each step (this is commonly done when you compute few steps and the computation of each step requires hours to be performed). What we would do is create a group for each step 
"""

# ╔═╡ 0582b1a4-e19c-44aa-9af7-a60352f75269
evol_group = create_group(file, "t=0")

# ╔═╡ 8e8b4184-5dcd-46e4-83e7-27186ce5f255
md"""
we may want to add attributes to it, like if the computation is ended or not
"""

# ╔═╡ 599de714-d91f-47fe-9607-0d7b10c4687a
attrs(evol_group)["completed"] = false

# ╔═╡ 5d864b6d-45fd-4847-a86e-7de2a05915ba
md"""
if the state of the system is a vector, we would save it in a `Dataset` as follows
"""

# ╔═╡ f62905b0-b92b-4454-b516-c6d7b239e66e
evol_group["state"] = rand(100)

# ╔═╡ 92f7adec-fd8c-49c5-9ce8-450853e5f034
md"""
we can now set the attribute completed to true
"""

# ╔═╡ 95aca2e5-e004-4ea0-b2f6-b8bf09d2d176
attrs(evol_group)["completed"] = true

# ╔═╡ a137b5e2-5ea9-4c9c-8f88-3894e7590b8c
md"""
and finally close the file
"""

# ╔═╡ 8c137ad9-53e7-4ab8-9433-09ccc44f3566
close(file)

# ╔═╡ afd98204-c6dd-4bdb-83f6-c4b5d188697a
md"""
Now we are going to read the data from it
"""

# ╔═╡ 9d482dae-80b5-4a17-a140-368da4c55866
read_file = h5open(filename, "r")

# ╔═╡ afec233a-3385-4422-962e-6d062ea272e7
md"""
we can now see all the structure we saved before. What is important to know is that data are not saved in memory until we don't read them, this means that we don't have to worry about filling the RAM
"""

# ╔═╡ e39d2e64-b673-4086-ad1d-27406edbaa04
t0_group = read_file["t=0"]

# ╔═╡ 530e2bb5-688c-4185-9bd1-074a1a1e4e9a
attrs(t0_group)["completed"]

# ╔═╡ f2876ac5-4887-4885-b9f6-be397356a3f7
md"""
we first access the dataset
"""

# ╔═╡ e78e528c-d818-4ce5-b7f1-c375301815fb
state = t0_group["state"]

# ╔═╡ b8a6fc5e-0cbb-46ca-be35-4846666219ac
md"""
and then we read from it
"""

# ╔═╡ 69f55b67-36e5-40f9-ad89-748c8fbe4677
state[]

# ╔═╡ f3780650-9b14-442c-81f1-f6fd0c9f32e2
md"""
of course the 2 steps can be performed togheter as `t0_group["state"][]`
"""

# ╔═╡ 7a573e2e-5c3a-49fe-aae7-014e5804d5b7
close(read_file)

# ╔═╡ c6900f4d-95e7-40d2-b6fa-9c065ca15efa
md"""
## Some notes
When we write a dataset, this may not be written on the file asap, but it can wait in a buffer in the ram, we can force the writing by calling the function `flush` on the group we are writing.

While attributes can be overwritten, the same is not true for datasets, in that case we would have to delete the existing dataset and create a new one, but it can happen that we could note use the same memory location used previously, and this would lead to using more memory than required, so sometimes a repack should be perforemd, which means to copy all the data in a new file, hdf5 will automatically pack them.

It is also possible to read and write datasets in chunks, unfortunatly we won't have the time to see this in detail
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HDF5 = "f67ccb44-e63f-5c2f-98bd-6dc0ccc4ba2f"

[compat]
HDF5 = "~0.17.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.4"
manifest_format = "2.0"
project_hash = "25c2d4f7b72a8bafbc8d5eeff95782943d2d7ff7"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

    [deps.Compat.weakdeps]
    Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.HDF5]]
deps = ["Compat", "HDF5_jll", "Libdl", "MPIPreferences", "Mmap", "Preferences", "Printf", "Random", "Requires", "UUIDs"]
git-tree-sha1 = "e856eef26cf5bf2b0f95f8f4fc37553c72c8641c"
uuid = "f67ccb44-e63f-5c2f-98bd-6dc0ccc4ba2f"
version = "0.17.2"

    [deps.HDF5.extensions]
    MPIExt = "MPI"

    [deps.HDF5.weakdeps]
    MPI = "da04e1cc-30fd-572f-bb4f-1f8673147195"

[[deps.HDF5_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LazyArtifacts", "LibCURL_jll", "Libdl", "MPICH_jll", "MPIPreferences", "MPItrampoline_jll", "MicrosoftMPI_jll", "OpenMPI_jll", "OpenSSL_jll", "TOML", "Zlib_jll", "libaec_jll"]
git-tree-sha1 = "e94f84da9af7ce9c6be049e9067e511e17ff89ec"
uuid = "0234f1f7-429e-5d53-9886-15a909be8d59"
version = "1.14.6+0"

[[deps.Hwloc_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f93a9ce66cd89c9ba7a4695a47fd93b4c6bc59fa"
uuid = "e33a78d0-f292-5ffc-b300-72abe9b543c8"
version = "2.12.0+0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"
version = "1.11.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MPICH_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Hwloc_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "TOML"]
git-tree-sha1 = "3aa3210044138a1749dbd350a9ba8680869eb503"
uuid = "7cb0a576-ebde-5e09-9194-50597f1243b4"
version = "4.3.0+1"

[[deps.MPIPreferences]]
deps = ["Libdl", "Preferences"]
git-tree-sha1 = "c105fe467859e7f6e9a852cb15cb4301126fac07"
uuid = "3da0fdf6-3ccc-4f1b-acd9-58baa6c99267"
version = "0.1.11"

[[deps.MPItrampoline_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "TOML"]
git-tree-sha1 = "ff91ca13c7c472cef700f301c8d752bc2aaff1a8"
uuid = "f1f71cc9-e9ae-5b93-9b94-4fe0e1ad3748"
version = "5.5.3+0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.MicrosoftMPI_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bc95bf4149bf535c09602e3acdf950d9b4376227"
uuid = "9237b28f-5490-5468-be7b-bb81f5f5e6cf"
version = "10.1.4+3"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenMPI_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Hwloc_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "TOML", "Zlib_jll"]
git-tree-sha1 = "047b66eb62f3cae59ed260ebb9075a32a04350f1"
uuid = "fe0851c0-eecd-5654-98d4-656369965a5c"
version = "5.0.7+2"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a9697f1d06cc3eb3fb3ad49cc67f2cfabaac31ea"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.16+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libaec_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f5733a5a9047722470b95a81e1b172383971105c"
uuid = "477f73a3-ac25-53e9-8cc3-50b2fa2566f0"
version = "1.1.3+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─2921f084-0fa3-11f0-1bf6-e3a978cb7fc5
# ╠═18577da3-5c9b-4a6a-b07b-e91c6dcf3389
# ╟─b06b5ab2-6548-4e57-849e-60593ca9aa8b
# ╠═4a923ddf-432e-46ff-8fb1-c4a0f3fa0f07
# ╟─a9f7dcbe-33da-4c42-864f-837203b07240
# ╠═0582b1a4-e19c-44aa-9af7-a60352f75269
# ╟─8e8b4184-5dcd-46e4-83e7-27186ce5f255
# ╠═599de714-d91f-47fe-9607-0d7b10c4687a
# ╟─5d864b6d-45fd-4847-a86e-7de2a05915ba
# ╠═f62905b0-b92b-4454-b516-c6d7b239e66e
# ╟─92f7adec-fd8c-49c5-9ce8-450853e5f034
# ╠═95aca2e5-e004-4ea0-b2f6-b8bf09d2d176
# ╟─a137b5e2-5ea9-4c9c-8f88-3894e7590b8c
# ╠═8c137ad9-53e7-4ab8-9433-09ccc44f3566
# ╟─afd98204-c6dd-4bdb-83f6-c4b5d188697a
# ╠═9d482dae-80b5-4a17-a140-368da4c55866
# ╟─afec233a-3385-4422-962e-6d062ea272e7
# ╠═e39d2e64-b673-4086-ad1d-27406edbaa04
# ╠═530e2bb5-688c-4185-9bd1-074a1a1e4e9a
# ╟─f2876ac5-4887-4885-b9f6-be397356a3f7
# ╠═e78e528c-d818-4ce5-b7f1-c375301815fb
# ╟─b8a6fc5e-0cbb-46ca-be35-4846666219ac
# ╠═69f55b67-36e5-40f9-ad89-748c8fbe4677
# ╟─f3780650-9b14-442c-81f1-f6fd0c9f32e2
# ╠═7a573e2e-5c3a-49fe-aae7-014e5804d5b7
# ╟─c6900f4d-95e7-40d2-b6fa-9c065ca15efa
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
