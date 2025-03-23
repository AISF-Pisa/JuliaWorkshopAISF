### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ ee381241-14bc-48d6-b353-273a62ce8085
md"""
Let's define an abstract type for 2D points
"""

# ╔═╡ 0acd85a5-51ef-46b0-9c0f-1e9a04845ca3
abstract type AbstractPoint2D end

# ╔═╡ 49918721-30c7-4633-b360-b709b9b12291
md"""
Let's define 2 concrete types for 2D points with relative methods
"""

# ╔═╡ 16039601-8fa4-4be3-b42a-03f33670650a
struct CartesianPoint2D <: AbstractPoint2D
	x::Float64
	y::Float64
end

# ╔═╡ ae6e79a1-4957-40a0-87b3-3dab9aa35009
x(p::AbstractPoint2D) = p.x

# ╔═╡ a481344d-b926-464b-bd83-c9ddaf2a2e89
y(p::AbstractPoint2D) = p.y

# ╔═╡ 5760e6c3-70e3-4d5c-b3a2-9d37581f0035
struct PolarPoint2D <: AbstractPoint2D
	r::Float64
	θ::Float64
end

# ╔═╡ e77976ba-4ede-4e3a-880c-e12b95b9b14a
x(p::PolarPoint2D) = p.r * cos(p.θ)

# ╔═╡ 1bac9589-a5e8-48c8-a50c-2c7376a1f668
y(p::PolarPoint2D) = p.r * sin(p.θ)

# ╔═╡ 51c65c1a-58c0-4023-a39b-8ad9559935f0
r(p::AbstractPoint2D) = sqrt(x(p)^2 + y(p)^2)

# ╔═╡ 7b5bb960-260a-4bdd-9763-32e6ef9a9f16
θ(p::AbstractPoint2D) = atan2(y(p), x(p))

# ╔═╡ f9d5baa4-6c8b-4b72-aaf8-7345838dd7cb
r(p::PolarPoint2D) = p.r

# ╔═╡ a24e8d27-3b63-4c64-be7b-96e5c42481ca
θ(p::PolarPoint2D) = p.θ

# ╔═╡ 13a79f63-fbe9-4183-ad93-c45dffea6ad6
md"""
Let's define a function that computes the distance between two points
"""

# ╔═╡ c1f8ffc3-0f26-4381-aa89-44fe2609bc4c
function distance(p1::AbstractPoint2D, p2::AbstractPoint2D)
	# we can use the x and y functions to get the coordinates of the points
	dx = x(p1) - x(p2)
	dy = y(p1) - y(p2)
	return sqrt(dx^2 + dy^2)	
end

# ╔═╡ a416c416-b235-4325-8264-3b2381de06d3
md"""
Now we are going to use this function
"""

# ╔═╡ b82807fe-e64e-4a76-bac5-bd6c23442031
begin
	p1 = CartesianPoint2D(1.0, 0.0)
	p2 = PolarPoint2D(1.0, π/2)
	distance(p1, p2) ≈ sqrt(2)
end

# ╔═╡ Cell order:
# ╟─ee381241-14bc-48d6-b353-273a62ce8085
# ╠═0acd85a5-51ef-46b0-9c0f-1e9a04845ca3
# ╟─49918721-30c7-4633-b360-b709b9b12291
# ╠═16039601-8fa4-4be3-b42a-03f33670650a
# ╠═ae6e79a1-4957-40a0-87b3-3dab9aa35009
# ╠═a481344d-b926-464b-bd83-c9ddaf2a2e89
# ╠═51c65c1a-58c0-4023-a39b-8ad9559935f0
# ╠═7b5bb960-260a-4bdd-9763-32e6ef9a9f16
# ╠═5760e6c3-70e3-4d5c-b3a2-9d37581f0035
# ╠═e77976ba-4ede-4e3a-880c-e12b95b9b14a
# ╠═1bac9589-a5e8-48c8-a50c-2c7376a1f668
# ╠═f9d5baa4-6c8b-4b72-aaf8-7345838dd7cb
# ╠═a24e8d27-3b63-4c64-be7b-96e5c42481ca
# ╟─13a79f63-fbe9-4183-ad93-c45dffea6ad6
# ╠═c1f8ffc3-0f26-4381-aa89-44fe2609bc4c
# ╟─a416c416-b235-4325-8264-3b2381de06d3
# ╠═b82807fe-e64e-4a76-bac5-bd6c23442031
