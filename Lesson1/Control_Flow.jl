### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ 78cec08e-08b5-11f0-062d-65200c1ff50c
# The main reference for this argument will be [this](https://docs.julialang.org/en/v1/manual/control-flow/#man-compound-expressions) page from Julia Documentation.
md"""
# Control Flow
The flow of a program is which expressions are executed and in what order, the easiest example of a control flow expression is the if/else block, where which expression should be executed is based on the veridicity of a predicate.

In Julia the control flow expressions are the following:
* Compound Expressions: `begin` and `;`
* Conditional Evaluation: `if`-`elseif`-`else` and `?:` (ternary operator)
* Short-Circuit Evaluation: logical operators `&&` ("and") and `||` ("or")
* Repeated Evaluation (Loops): `while` and `for`
* Exception Handling: `try`-`catch`, `error` and `throw`
* Tasks: `yieldto`

The first 5 mechanisms are standard in high-level programming languages, that is not true for `Tasks`, therefore they will be added to the notebook for the sake of completeness, but it is not excepted from neo-progammers to be able to understand them.

It is useful to have a formal definition of what an expression and statemant are:
> An expression in programming is a combination of literals, variables, operators, and function calls that produce a value when evaluated.

> Statement are similar to expressions but do not produce a value when evaluated.
"""

# ╔═╡ 3466d2e0-0357-41e1-b2ca-17f7665b8d09
md"""
## Compound Expressions.
A compound expression is a single expression tha evaluates several subexpressions in order and having the value of the last subexpression. The main Julia constructs that accomplish this are `begin` block and `;` chains
"""

# ╔═╡ 4bcd22f2-c51e-4af9-867e-43c5e0fc5843
begin
	x = 1
	y = 2
	x + y
end

# ╔═╡ d7cf560e-e576-4594-9be2-f726586238e2
(a = 1; b = 2; a + b)

# ╔═╡ 6b1d7868-5563-499a-9a90-20250b6210bc
md"""
Similar to `begin` expression, there is the `let` block, the main difference is that `let` creates a new hard scope while `begin` does not create a new scope. Given the last fact, `let` allows to define local variables from already existing variables.
"""

# ╔═╡ bcfb1e5a-621c-41da-82e9-7ea2b968a812
z = 5

# ╔═╡ 305a9bf1-16dc-4239-a89f-d2679554d343
let z_local = z #I'm calling it z_local to make a distintion, but we could use shadowing
	x = z_local*2-x
	x-3
end

# ╔═╡ 43aa69fd-4c81-43fe-a390-3ebf208b2170
md"""
In the first line of the `let` block we are defining a new local variable to have the value of z. In the second line, the `x` used in the right side of the equal sign is the global variable `x` defined in the `begin` block before, while the x in the left side is a new local variable, we can check that the value of the global variable `x` is still 1. In the rest of the block the local variable `x` is going to shadow the global variable `x`
"""

# ╔═╡ e5454d2e-5b75-4224-ba08-6ddb8a051f45
x

# ╔═╡ f89c8a46-5f78-4b36-82f5-f1465e4e3b97
md"""
## Conditional Evaluation
Conditional evaluations allows to decide which portion of code should be evaluated based on the veridicity of a predicate. The most common example is the `if`-`elseif`-`else`:
```julia-repl
julia> function test(x, y)
           if x < y
               println("x is less than y")
           elseif x > y
               println("x is greater than y")
           else
               println("x is equal to y")
           end
       end
test (generic function with 1 method)

julia> test(1, 2)
x is less than y

julia> test(2, 1)
x is greater than y

julia> test(1, 1)
x is equal to y
```
"""

# ╔═╡ 24e8a309-3e0a-408d-be70-5b679c1dec0d
md"""
if blocks do not create a new scope, so variables defined inside them are still accessible outside, for example we can redefine the function test as follow
```julia-repl
julia> function test(x,y)
           if x < y
               relation = "less than"
           elseif x == y
               relation = "equal to"
           else
               relation = "greater than"
           end
           println("x is ", relation, " y.")
       end
test (generic function with 1 method)

julia> test(2, 1)
x is greater than y.
```
Remeber to always insert a definition to the variable in each path otherwise you could have errors of wrong behaviours. For example, if we hadn't added a default case (else) in the if, in case `x > y` the variable relation wouldn't be defined and that would create an error. Worst case is if that variable existed in an outer scope, in that case we wouldn't recieve an error and the program would continue to run, but it would have the wrong behaviour (remember: the absence of an error is worse than an error) 
"""

# ╔═╡ 2bc37e0e-b61b-417e-b189-59e6845727a5
md"""
Unlike other languages, if blocks are expressions and not statements (many statements in Julia become expressions), they assume the value of the last expression evaluated:
```julia-repl
julia> x = 3
3

julia> if x > 0
           "positive!"
       else
           "negative..."
       end
"positive!"
```
"""

# ╔═╡ 02e50952-2cb9-4807-b35c-56510690948d
md"""
Unlike other languages, Julia requires the condition to be of type `Bool`, it is not sufficient that the condition is convertible to it.
"""

# ╔═╡ ed94aa97-b071-4ea8-b468-9fdf0375085c
md"""
Julia also supports the ternary operator `?:` which is equivalent to an `if`-`else` block but it can be execute in one line. For example an easy way to get the maximum between 2 numbers is:
```julia-repl
julia> x = 3; y = 2;
julia> z = x > y ? x : y
3
```
"""

# ╔═╡ bd7fb049-8774-446b-8163-268025be8486
md"""
## Short-Circuit Evaluation
The `&&` and `||` operators in Julia are the logical "and" and `or` operators, they are called short-circuit cause the second element is not always evaluated. That is because `false && b` returns false whatever is the value of b, therefore in this case there is no need to evaluate b to know the veridicity of `a && b`. Similar reasoning works for `||`, in particular `true || b` yields always true.

We can say that `a && b` is equivalent to
```julia-repl
if a
	b
end
```
while `a || b` is equivalent to
```julia-repl
if a
else
	b
end
```
"""

# ╔═╡ c245f4d9-80af-41c4-b7cd-05192eec8cd8
md"""
an example of the usage of these operators is the following:
```julia-repl
julia> function fact(n::Int)
           n >= 0 || error("n must be non-negative")
           n == 0 && return 1
           n * fact(n-1)
       end
fact (generic function with 1 method)

julia> fact(5)
120

julia> fact(0)
1

julia> fact(-1)
ERROR: n must be non-negative
Stacktrace:
 [1] error at ./error.jl:33 [inlined]
 [2] fact(::Int64) at ./none:2
 [3] top-level scope
```
From this usage we see that it is not important for the last element to be boolean, but the first one still needs to be boolean. Also, they do not always evaluate to a type `Bool`, but just like `if` blocks, they evaluate to the last evaluated term
"""

# ╔═╡ ce7f57b1-9b2c-4138-ad37-46a22982db18
md"""
## Repeated Evaluation: Loops
Loops evaluate a portion of code each time the evaluation of a condition is `true`. There are 2 types of loops in Julia which are `for` and `while`. Note that both of them create a soft local scope.

```julia-repl
julia> i = 1;

julia> while i <= 3
           println(i)
           global i += 1
       end
1
2
3
```

```julia-repl
julia> for i = 1:3
           println(i)
       end
1
2
3
julia> for i in [1,4,0]
           println(i)
       end
1
4
0

julia> for s ∈ ["foo","bar","baz"]
           println(s)
       end
foo
bar
baz
```
"""

# ╔═╡ db39b23b-08e8-4af2-97c9-42b7e08843ec
md"""
To important control flow instructions in a loop are `break` and `continue`. The first one causes the exit from a loop, while the second one jumps directly to the next iteration of the loop, without finishing evaluating the current iteration.

```julia-repl
julia> i = 1;

julia> while true
           println(i)
		   i >= 3 && break
           global i += 1
       end
1
2
3

julia> for j = 1:1000
           println(j)
 		   j >= 3 && break
		end
1
2
3
julia> for i = 1:10
		   i % 3 || continue
           println(i)
       end
3
6
9
```
"""

# ╔═╡ 0a24c131-c50d-48e3-803d-d77f8dc12034
md"""
Julia also offers an easy way to write nested loops:
```julia-repl
julia> for i = 1:3, j = i:3
           println((i, j))
       end
(1, 1)
(1, 2)
(1, 3)
(2, 2)
(2, 3)
(3, 3)
```
Mind that a break statement would cause the exit from all the nested loops.
"""

# ╔═╡ b8779469-c1a8-4f0d-8927-3fbf17aa4d0a
md"""
It is not rare the need to iterate over more than one collection, this can be achieved by using the function `zip`:
```julia-repl
julia> for (j, k) in zip([1 2 3], [4 5 6 7])
           println((j,k))
       end
(1, 4)
(2, 5)
(3, 6)
```
the loop exits when one of the collections is exhausted
"""

# ╔═╡ be77ed98-95bd-479c-88d7-5a35679e5281
md"""
Another common function is `enumerate` which yields both the index of the collection and the value
```julia-repl
julia> for (i, val) in enumerate(["a", "b", "c"])
           println((i, val))
       end
(1, "a")
(2, "b")
(3, "c")
```
"""

# ╔═╡ f39a1f46-e7d6-4875-8835-e303cedf92da
md"""
## Exception Handling
Errors are one of the most important thing in a programming language, probably there is no worse thing than seeing your program crush or return wrong results, without an explanation.

In Python, errors are raised so that the user can see them, in Julia they are thrown at you, unless you don't catch them.

Errors always come with a backtrace (also called stacktrace), which is the list of the called functions from the main to where the error has taken place, helping the user in debugging the code.

A list of the built-in exceptions in Julia can be found [here](https://docs.julialang.org/en/v1/manual/control-flow/#Built-in-Exceptions)
"""

# ╔═╡ f04fe25d-accc-4903-9864-e694c18eebdf
md"""
To trhow an error, you can use the `throw` function:
```julia-repl
julia> f(x) = x>=0 ? exp(-x) : throw(DomainError(x, "argument must be non-negative"))
f (generic function with 1 method)

julia> f(1)
0.36787944117144233

julia> f(-1)
ERROR: DomainError with -1:
argument must be non-negative
Stacktrace:
 [1] f(::Int64) at ./none:1
```
Also the `error` function can be used, but it is not adviced since it is too general.
"""

# ╔═╡ d23d1cdf-9cf4-4181-b1ef-2b969db5bdd0
md"""
### The `try/catch` statement
If we fear that a code of block my return an error, we can `try` it, and in case it does, we can change something.

```julia-repl
julia> sqrt_second(x) = try
           sqrt(x[2])
       catch y
           if isa(y, DomainError)
               sqrt(complex(x[2], 0))
           elseif isa(y, BoundsError)
               sqrt(x)
		   else
			   retrhow(e)
           end
       end
sqrt_second (generic function with 1 method)

julia> sqrt_second([1 4])	# this executes smoothly
2.0

julia> sqrt_second([1 -4])	# this raises DomainError
0.0 + 2.0im

julia> sqrt_second(9)		# this raises BoundsError
3.0

julia> sqrt_second(-9)		# this raises a BoundsError first, and a DomainError when recalled
ERROR: DomainError with -9.0:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]
```
!!! note
	When catching expressions, remember to retrhow the ones you did not handled. The difference wrt trhow is that retrhow appends to the exiisting stacktrace
"""

# ╔═╡ a2e86dbc-44be-41f0-95dc-cc21441c3da4
md"""
### `else` and `finally` clauses
The `else` clause is used when you want to run something only if the `try` statement succeeds.

The `finally` clause instead is executed indipendently from if the try statement returned an error or not. This is very usefull to clean some data in case an error occured, for example to close safely a file, such that it won't be corrupted
```julia-repl
f = open("file")
try
    # operate on file f
finally
    close(f)
end
```
"""

# ╔═╡ 9f687357-2f00-4ec1-8338-66c5b65aca89
md"""
## Tasks
Tasks are a control flow feature that allows computations to be suspended and resumed in a flexible manner.

For example, you may want to start an operation, which could be the download of a file, and meanwhile do something else and resume it once it has ended.

A task can be created with the `Task` constructor which accepts a 0-argument function function to run. It can also be created using the macro `@task`:
```julia-repl
julia> t = @task begin; sleep(5); println("done"); end
Task (runnable) @0x00007f13a40c0eb0
```
This only creates a task but it hasn't started yet. To do so we have to append it to the queue
```julia-repl
julia> schedule(t);
```
Now the task is set to run, but we can do other things in the meanwhile. Often tasks are added to the queue in the moment that they are created, this can be done with the macro `@async` which is equivalent to `schedule(@task)`.

If you need to wait for the task to be completed, you can use the function `wait`. This is necessary when performing this actions in a script instead that from REPL
"""

# ╔═╡ 721109c6-5b68-47b7-bfaa-09a6dbf94ba9
begin
	t = @async (sleep(5), println("done"))
	sleep(0.1)	# give it time to start
	println("is task started? $(istaskstarted(t) ? "yes" : "no")")
	println("in the mean time")
	for i in 1:10
		println(i)
	end
	wait(t)
end

# ╔═╡ Cell order:
# ╟─78cec08e-08b5-11f0-062d-65200c1ff50c
# ╟─3466d2e0-0357-41e1-b2ca-17f7665b8d09
# ╠═4bcd22f2-c51e-4af9-867e-43c5e0fc5843
# ╠═d7cf560e-e576-4594-9be2-f726586238e2
# ╟─6b1d7868-5563-499a-9a90-20250b6210bc
# ╠═bcfb1e5a-621c-41da-82e9-7ea2b968a812
# ╠═305a9bf1-16dc-4239-a89f-d2679554d343
# ╟─43aa69fd-4c81-43fe-a390-3ebf208b2170
# ╠═e5454d2e-5b75-4224-ba08-6ddb8a051f45
# ╟─f89c8a46-5f78-4b36-82f5-f1465e4e3b97
# ╟─24e8a309-3e0a-408d-be70-5b679c1dec0d
# ╟─2bc37e0e-b61b-417e-b189-59e6845727a5
# ╟─02e50952-2cb9-4807-b35c-56510690948d
# ╟─ed94aa97-b071-4ea8-b468-9fdf0375085c
# ╟─bd7fb049-8774-446b-8163-268025be8486
# ╟─c245f4d9-80af-41c4-b7cd-05192eec8cd8
# ╟─ce7f57b1-9b2c-4138-ad37-46a22982db18
# ╟─db39b23b-08e8-4af2-97c9-42b7e08843ec
# ╟─0a24c131-c50d-48e3-803d-d77f8dc12034
# ╟─b8779469-c1a8-4f0d-8927-3fbf17aa4d0a
# ╟─be77ed98-95bd-479c-88d7-5a35679e5281
# ╟─f39a1f46-e7d6-4875-8835-e303cedf92da
# ╟─f04fe25d-accc-4903-9864-e694c18eebdf
# ╟─d23d1cdf-9cf4-4181-b1ef-2b969db5bdd0
# ╟─a2e86dbc-44be-41f0-95dc-cc21441c3da4
# ╟─9f687357-2f00-4ec1-8338-66c5b65aca89
# ╠═721109c6-5b68-47b7-bfaa-09a6dbf94ba9
