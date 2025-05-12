### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ d8a32abe-074c-11f0-17e3-cbe24d728287
md"""
# Julia Types
we could use Julia like Python and completely forget about types, but this would not allow us to use julia fully.

Let's start by understanding what types are: when we create a variable, we are creating a "reference" to a location in the memory, but that is just a bunch of bits, types tell us how those bits should be interpreted.
"""

# ╔═╡ f6206380-453d-4003-976c-b57b96cefe11
md"""
## Basic numerical types
These are the most easy types to understand since they are strictly related to our mathematical knowledge of numerical sets. In particular the basic ones are:
+ `UInt` 	-> Natural numbers
+ `Int` 	-> Integer numbers
+ `Rational`-> Rational numbers
+ `Real` -> Real numbers
+ `Complex` -> Complex numbers

We can query the type of a variable by using the function `typeof`, usually we will found these values followed by a number that represents how many bits are used to represent that value.

Rational and Complex types are **parametrized** types, which means that they depend on a parameter which is the type of the variables used, for example a `Rational{Int}` means that it is the fraction between two numbers of type `Int`, while `Rational{UInt}` means that numerator and denominator are of type `UInt`.
"""

# ╔═╡ 746d43fc-a2c1-4eb9-858f-fb18584d0fa3
typeof(0x3)

# ╔═╡ faacc304-55d5-4ea8-92b4-fe5b658fc5f3
typeof(3)

# ╔═╡ e73de1bc-ec8e-4275-944a-27381d8628d9
typeof(3//2)

# ╔═╡ 4915f8f4-d025-45c2-9bf3-7bff58789b44
typeof(0x3//0x2)

# ╔═╡ df600195-8db5-43f4-bdec-1645e658d557
typeof(3.0)

# ╔═╡ dc3cfa1b-e5b2-4f3a-ae69-ad23da5ebf1a
typeof(3.0 + 1.0*im)

# ╔═╡ 5068c38c-fcc7-42cc-b807-d408a818d605
typeof(3 + 1*im)

# ╔═╡ 2101df32-c930-4540-90aa-089ee38eec33
md"""
## Other important types
There are many other built-in types, for now let's focus on the most basic ones.
* `Bool`: an element of type `Bool` can be in one of 2 states, which are `true` and `false`, this type is used to determine if a predicate is `true` or `false`
* `Nothing`: an element of type `Nothing` has the value `nothing`, it is just used to indicate that the variable doesn't refer to any location in memory. There other types that hold a similar meaning (`UndefInitializer` and `Missing`), but we will talk about them later in `Arrays` section.
* `String`: a string a collection of characters, the most basic example is the following:
```julia-repl
julia> 🔤 = "Hello world";

julia> typeof(🔤)
String
```
* `Type`: all types are instances of `Type`, i.e.
```julia-repl
julia> Int isa Type
true
```
This example uses the function `isa` which returns `true` if the left argument is of the type given on the right.
* `Tuple`: an instance of the type `Tuple` is an **immutable** collection of elements of different types. Immutable means that its elements cannot be modified.
"""

# ╔═╡ c8051bfe-784b-4b14-81e3-e5549c9584bc
tuple = (1, 2.0, "a")

# ╔═╡ db0bdef3-25bf-4591-8e06-7e064e896cd7
typeof(tuple)

# ╔═╡ e9d48488-e329-4a19-ad13-8eea804e8f86
tuple[2]

# ╔═╡ 91206f75-147d-4648-b7b9-d32de08bfbb6
# attempting to modify an element gives an error
# x[2] = 1.0

# ╔═╡ e3e010f3-b199-43a2-8a63-1fe106b921b7
md"""
* `Union`: an instance of an union type can have the type of each of the types given by the union, this will be clearer when we do the `::` operator
* `Function`: this is the type of all functions
* `Symbol`: instances of this type are variables and functions names, more in general it is the type of object used to represent identifiers in parsed julia code (ASTs, Abstract Syntax Tree(s)). Symbols are **Interned**, it means that all the symbols with the same name refer to the same object in memory, so symbol comparison is equivalent to a pointer comparison.
"""

# ╔═╡ c8041f76-5729-413d-8b7c-79e1bb290bca
md"""
## Structs
Even though julia has an OOP (Object Oriented Programming) behaviour, it is not an OOP like C++, Java or Python, infact it doesn't use classes, but it uses structs instead. A struct is a container of fields (or attributes), and its difference wrt classes is that classes also have methods, i.e. functions linked to its instances.

Structs in Julia can be of 2 types, immutable or mutables, based on if the fields of an instance of the struct can change value after creation or not.

We now define an immutable struct called `Point2D` that has 2 fields, the `x` component and the `y` component, both of them of type `Float64`
"""

# ╔═╡ ea3070c8-2583-4fb5-ab7e-c6701b755add
struct Point2D
	x::Float64
	y::Float64
end

# ╔═╡ e353854a-9518-4018-85f6-3c1ad7052b43
md"""
now let's create an instance of this struct.
"""

# ╔═╡ 71524e2a-0b9b-455d-8d6e-47b9755999b0
point = Point2D(1.0, 3.0)

# ╔═╡ cae54138-96ef-41c7-8d83-8977de2c72a7
md"""
we can extract the fields from the variable point as follows
"""

# ╔═╡ 5a242f4a-98d1-4115-ab74-ed1b7b9f7761
point.x

# ╔═╡ fb061722-98c4-4cfb-bb8e-d39cbd9c372d
point.y

# ╔═╡ 86efb509-978a-4f5a-bd34-be4b9e947c84
md"""
Even though we can, julia suggest to define functions to retrieve the field values. Why? To make our life easier, suppose that when day you wake up and decide to change the fields of the struct `Point2D` and save the information in polar form rather than in cartesian form, you would have to change your code each time you have used the syntax `.x` and `.y`, by using functions you will only have to change how your function works, without breaking your code. So let's define those functions.
"""

# ╔═╡ 18804309-554f-4f59-891c-5e2833ed3cbc
x(p::Point2D) = p.x

# ╔═╡ c0ecaa4c-8d19-4ede-b843-e43999ce52dd
y(p::Point2D) = p.y

# ╔═╡ 5a8d13db-4260-4252-b25b-5ff06186d34b
x(point)

# ╔═╡ 84e8b70b-af18-4911-ad7f-8b146c7cfc41
y(point)

# ╔═╡ 4330de84-b973-4a59-bd3d-2fd173cb51e1
md"""
we can check that by trying to modify the value of a field, we would get an error:
```julia-repl
julia> point.x = -1.0
ERROR: setfield!: immutable struct of type Point2D cannot be changed
Stacktrace:
 [1] setproperty!(x::Point2D, f::Symbol, v::Float64)
   @ Base ./Base.jl:53
 [2] top-level scope
   @ REPL[53]:1
```
This means that we cannot modify its value, but rather, we would have to create a new instance with the new values.
"""

# ╔═╡ 340c81d7-50e9-415c-8f5b-8e44707b7a6e
point₁ = Point2D(-1.0, 3.0)

# ╔═╡ 602347ef-624c-44e7-95e6-555644babe31
md"""
If the fields do not occupy a lot of memory, it is not costly to create a new instance, but imagine to have a large array, it would be unthinkable to create a new array each time you change an element, for this reason you can define a `mutable struct`, the only difference in the declaration is that you will have to writie `immutable struct`, and you can change the properties of the instances of these structs
"""

# ╔═╡ 4ee9e6e2-2ae9-406c-99e3-ecf1eadce1b7
begin
	mutable struct ImmPoint2D
		x::Float64
		y::Float64
	end
	set_x!(p::ImmPoint2D, val::Float64) = p.x = val
	set_y!(p::ImmPoint2D, val::Float64) = p.y = val
	point₂ = ImmPoint2D(1.0, 3.0)
	set_x!(point₂, -1.0)
	point₂
end

# ╔═╡ a2da3fb7-282b-4baa-b028-1a8ea648a1f1
md"""
## Subtyping
Subtyping is one of the most important features of julia. Before defining what it is, we have to specify that in julia there are 2 possible kinds of types which are `abstract` and `concrete`, the difference is that abstract types cannot be instantiated, they are only nodes in a type hierarchy.

A type (either concrete or abstract) `T₁` is a subtype of an abstract type `T₂` if all instances of `T₁` are also of type `T₂`. But let's try to be clearer with an example. We said that int and floats are both numerical types, but while the meaning of this affirmation is intuitive, it is translated in the fact that `Int#` and `Float#` are both subtypes of the abstract type `Number`
```julia-repl
julia> 3.0 isa Number
true

julia> 3 isa Number
true
```
The reason behind the importance in subtyping is strongly related to how functions works in julia.

Julia has the type `Any`, to which all types are subtypes
"""

# ╔═╡ c0a53baf-fef0-4307-b6a4-141963009b93
md"""
# Functions in Julia
Let's start to use a more specific language. A function is an instance of the `Function` type. Each function has a `methods table`, which is a table that takes as entries a tuple of types and returns the object that actually operate on those types. This behaviour is called **Multiple Dispatch** and it is one of the most important features of julia.

To make things clearer let's make an example, let's define 2 methods of the function `foo`
"""

# ╔═╡ b905f0c6-be78-4866-9789-443047b5d332
function foo(::Int)
	return "foo has been called with an Int type"
end

# ╔═╡ f1460d62-e799-4ca7-aa69-54ee3464273a
function foo(::Float64)
	return "foo has been called with a Float64 type"
end

# ╔═╡ 593275a0-fe43-4478-a576-96ef78e4d497
md"""
In the first definition, since the function `foo` doesn't exist, it is created and the entry `Tuple{Int}` is addedd to the methods table, in the second case the function already exists so only the entry `Tuple{Float64}` is added to the table. Note that since we are not using the passed value we are not assigning a symbol to it.

Let's now try to call those functions.
"""

# ╔═╡ 8a08d520-3f8e-4a2f-98f2-bb926955c704
md"""
we can see that based on the type of the passed argument, either one method of the other is selected. More generally, when we call a function `f`, with arguments of types `(T1, T2, ...)`, the tuple type `Tuple{T1, T2, ...}`  is created and confronted with the method table of `f`, the chosen method is the most specific one, it means that if there is both a method implemented for the specific type, or for a subtype, the method acting on a specific type is chosen, let's define another method for the function `foo` to make this last point clearer.
"""

# ╔═╡ 225cd899-dbd0-4dda-b16a-b419fc6ecfc9
function foo(x::Number)
	return "foo has been called with numerical type $(typeof(x))"
end

# ╔═╡ d6e48821-9bc6-4f9a-9738-c32ebf344a87
foo(3)

# ╔═╡ 21650a0f-717c-4e81-a452-9678c55a7fdf
foo(3.0)

# ╔═╡ c0ed9435-b138-452f-a1c4-6ac0138becb4
foo(1 + 3*im)

# ╔═╡ d8a78ab0-fae5-4942-981f-5002817d6db2
foo(3//2)

# ╔═╡ e5a07ed0-c647-4c30-bd9d-3067803dfc5a
foo(2)

# ╔═╡ 63ec84b2-3136-4885-bdd7-4b47a716d3b0
md"""
we can see that no method has been implemented for Complex and Rational type, so the first 2 calls fall back on the same method that takes the abstract type Number, while for the third call the method chosen in the one that takes an Int as input, since this is more specific. To see the method table of a function, we can use the function `methods`.

To understand in more detail how the call process works, you can refer to the [documentation](https://docs.julialang.org/en/v1/devdocs/functions/#Function-calls).

We now have all the tools to reimplement the `Point2D` struct in a more complex and complete way, you can see this implementation [here](Point2D.html)
"""

# ╔═╡ 6574580e-46a7-4a1d-badf-54ed3bcba446
md"""
## Vararg and kwargs
Since we are already talking about functions, let's conclude with functions that can accept a variable number of arguments, keywords and optional arguments. Probably the best way to explain it is directly with an example.
"""

# ╔═╡ 51a53175-d31f-42b8-a5ee-d8ad1be72d20
function sum_pow(x1::Number...; N::Int = length(x1), pow::Int = 1)
	s = 0
	for i in 1:N
		s += x1[i]^pow
	end
	return s
end

# ╔═╡ d7760557-bd5c-464a-91ba-354ef632fbad
sum_pow(1, 2, 3, 4)

# ╔═╡ 9e673533-7cbc-4354-b058-84d393558f94
sum_pow(1, 2, 3, 4, 5; pow = 2)

# ╔═╡ 7d5d3cfc-e9e1-4ea8-a393-53908e506994
md"""
The function `sum_pow` takes a variable number of arguments of type `Number`, and has 2 optional keywords, the keywords can only be passed by writing explicitly the name of the argument. Keywords come after a semicolon, and (in this case) they are optional, if no value is passed the default one (the value present on the right of the equal sign in the function declaration) is used.
"""

# ╔═╡ Cell order:
# ╟─d8a32abe-074c-11f0-17e3-cbe24d728287
# ╟─f6206380-453d-4003-976c-b57b96cefe11
# ╠═746d43fc-a2c1-4eb9-858f-fb18584d0fa3
# ╠═faacc304-55d5-4ea8-92b4-fe5b658fc5f3
# ╠═e73de1bc-ec8e-4275-944a-27381d8628d9
# ╠═4915f8f4-d025-45c2-9bf3-7bff58789b44
# ╠═df600195-8db5-43f4-bdec-1645e658d557
# ╠═dc3cfa1b-e5b2-4f3a-ae69-ad23da5ebf1a
# ╠═5068c38c-fcc7-42cc-b807-d408a818d605
# ╟─2101df32-c930-4540-90aa-089ee38eec33
# ╠═c8051bfe-784b-4b14-81e3-e5549c9584bc
# ╠═db0bdef3-25bf-4591-8e06-7e064e896cd7
# ╠═e9d48488-e329-4a19-ad13-8eea804e8f86
# ╠═91206f75-147d-4648-b7b9-d32de08bfbb6
# ╟─e3e010f3-b199-43a2-8a63-1fe106b921b7
# ╟─c8041f76-5729-413d-8b7c-79e1bb290bca
# ╠═ea3070c8-2583-4fb5-ab7e-c6701b755add
# ╟─e353854a-9518-4018-85f6-3c1ad7052b43
# ╠═71524e2a-0b9b-455d-8d6e-47b9755999b0
# ╟─cae54138-96ef-41c7-8d83-8977de2c72a7
# ╠═5a242f4a-98d1-4115-ab74-ed1b7b9f7761
# ╠═fb061722-98c4-4cfb-bb8e-d39cbd9c372d
# ╟─86efb509-978a-4f5a-bd34-be4b9e947c84
# ╠═18804309-554f-4f59-891c-5e2833ed3cbc
# ╠═c0ecaa4c-8d19-4ede-b843-e43999ce52dd
# ╠═5a8d13db-4260-4252-b25b-5ff06186d34b
# ╠═84e8b70b-af18-4911-ad7f-8b146c7cfc41
# ╟─4330de84-b973-4a59-bd3d-2fd173cb51e1
# ╠═340c81d7-50e9-415c-8f5b-8e44707b7a6e
# ╟─602347ef-624c-44e7-95e6-555644babe31
# ╠═4ee9e6e2-2ae9-406c-99e3-ecf1eadce1b7
# ╟─a2da3fb7-282b-4baa-b028-1a8ea648a1f1
# ╟─c0a53baf-fef0-4307-b6a4-141963009b93
# ╠═b905f0c6-be78-4866-9789-443047b5d332
# ╠═f1460d62-e799-4ca7-aa69-54ee3464273a
# ╟─593275a0-fe43-4478-a576-96ef78e4d497
# ╠═d6e48821-9bc6-4f9a-9738-c32ebf344a87
# ╠═21650a0f-717c-4e81-a452-9678c55a7fdf
# ╟─8a08d520-3f8e-4a2f-98f2-bb926955c704
# ╠═225cd899-dbd0-4dda-b16a-b419fc6ecfc9
# ╠═c0ed9435-b138-452f-a1c4-6ac0138becb4
# ╠═d8a78ab0-fae5-4942-981f-5002817d6db2
# ╠═e5a07ed0-c647-4c30-bd9d-3067803dfc5a
# ╟─63ec84b2-3136-4885-bdd7-4b47a716d3b0
# ╟─6574580e-46a7-4a1d-badf-54ed3bcba446
# ╠═51a53175-d31f-42b8-a5ee-d8ad1be72d20
# ╠═d7760557-bd5c-464a-91ba-354ef632fbad
# ╠═9e673533-7cbc-4354-b058-84d393558f94
# ╟─7d5d3cfc-e9e1-4ea8-a393-53908e506994
