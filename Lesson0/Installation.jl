### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ e97182aa-00ee-11f0-23f8-15d4527ad4d6
md"""
# Install Julia
Julia has its own installer called `juliaup`, all you have to do is follow the instructions [here](https://julialang.org/downloads/).
"""

# ╔═╡ f4e57cc3-29ca-466d-90d0-2fc45784a30d
md"""
# Run Julia
Like Python, Julia can be used both in an interactive way and to execute a script. We will start from Julia `REPL` (Read Execute Print Loop).
"""

# ╔═╡ edfcf4b5-6f60-4268-a282-ed3b49f453a4
md"""
## Julia REPL
Julia REPL is way more reach respect to Python REPL, in particular some of the key features are:
1. Direct access to the `shell`, you can execute any shell command from within Julia REPL, all you have to do is type `;` and you will enter the `shell` mode.
2. Direct access to its package manager `Pkg`, we will say more about it later.
3. Direct access to the documentations by typing `?`.
4. Tab completion, which means that it recognizes the word while you are writing it and it suggests how to complete it.
5. Special characters support, like greek letters ψ, subscripts ψₒ, but also emoticons 😸(if you are wondering whether it is possible to use a cat as a variable, yes it is. I love to use 🤦 in error messages).
"""

# ╔═╡ 0899691e-bf22-4c45-b312-162d7385dddd
md"""
### Shell mode
Let's start Julia by typing `julia` from our command shell, we will then have the following screen:
```julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.11.4 (2025-03-10)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>
```
In order to access the shell we will have to type `;`, the active line will transform to:
```julia
shell>
```
we can now try to use some basics commands like `whoami` which prints the name of the current logged in user:
``` julia
shell> whoami
vince
```
To exit the shell mode (and all other modes) we just have to press the `delete` button on our kewboard.
"""

# ╔═╡ acaeab64-aa3b-4981-80c7-17de1d36caa3
md"""
### Documentation
If in `Julia REPL` we type `?`, we will enter the help mode:
```julia
help?>
```
Here we can insert symbols (keywords, names of functions and variables, types etc.) and, if they have a documentation linked to them, it will be shown to us.  For example:
```julia
help?> if
search: if diff in im

  if/elseif/else

  if/elseif/else performs conditional evaluation, which allows portions of code to be evaluated or not evaluated depending on the value of a boolean expression. Here is the anatomy of the
  if/elseif/else conditional syntax:

  if x < y
      println("x is less than y")
  elseif x > y
      println("x is greater than y")
  else
      println("x is equal to y")
  end

  If the condition expression x < y is true, then the corresponding block is evaluated; otherwise the condition expression x > y is evaluated, and if it is true, the corresponding block is
  evaluated; if neither expression is true, the else block is evaluated. The elseif and else blocks are optional, and as many elseif blocks as desired can be used.

  In contrast to some other languages conditions must be of type Bool. It does not suffice for conditions to be convertible to Bool.

  julia> if 1 end
  ERROR: TypeError: non-boolean (Int64) used in boolean context
```
"""

# ╔═╡ a98cacce-72fa-4945-8674-dbc535391e27
md"""
## Package manager Pkg
Julia simplifies package management with an elegant approach, everytime you install a new package, it gets installed in the julia folder, and a link to it is created in the active environment, this means that you will always have only a single copy of each package (with the same version of course) allowing you to create as many environments as you want without occupying additional memory.
"""

# ╔═╡ aecd375e-1818-42a0-b722-358112239fc7
md"""
### Environments
Let's try to understand what environments are and why are they important. When we write some code, usually this will require some packages to work, but what happens if you update the package to a newer version where a function you are using has changed name or has been deprecated? Your code will not be able to run anymore. That's why environments are important, they save the informations of what packages the project needs in order to run, and the versions on which the project has been tested. 

In julia, enviroments are characterized by 2 files:
* `Project.toml`, which saves informations of packages and versions required;
* `Manifest.toml` which has the informations of where julia will have to search for those pacakges on your computer.
"""

# ╔═╡ 74117c48-1b62-4150-a699-bbf542d5ef89
md"""
### Our first environment
Let's start by creating our first enviroment, it is pretty easy, just start Julia REPL and type `]` to enter `pkg` mode. From there execute the following command:
```julia
	pkg> activate .
```
this will activate the project in the folder "." (current folder) if it exists, otherwise a new one will be created. You can check the full documentation of the `activate` command by executing
```julia
	pkg> ?activate
```

We can now install our first package, it will be `Pluto` (full documentation [here](https://plutojl.org/)), it allows the creation of notebooks like the one you are currenty reading. To install it we will have to simply execute the command
```julia
	pkg> add Pluto
```
we can now see a `Project.toml` and a `Manifest.toml` being created in the current folder
"""

# ╔═╡ Cell order:
# ╟─e97182aa-00ee-11f0-23f8-15d4527ad4d6
# ╟─f4e57cc3-29ca-466d-90d0-2fc45784a30d
# ╟─edfcf4b5-6f60-4268-a282-ed3b49f453a4
# ╟─0899691e-bf22-4c45-b312-162d7385dddd
# ╟─acaeab64-aa3b-4981-80c7-17de1d36caa3
# ╟─a98cacce-72fa-4945-8674-dbc535391e27
# ╟─aecd375e-1818-42a0-b722-358112239fc7
# ╟─74117c48-1b62-4150-a699-bbf542d5ef89
