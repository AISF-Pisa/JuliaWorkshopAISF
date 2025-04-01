### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ cd7d1a77-533c-4898-863b-6f4030666886
using LoggingExtras

# ╔═╡ 67abc344-0920-44cc-87e0-a582c8976ff9
begin
	using Dates
	const date_format = "yyyy-mm-dd HH:MM:SS"

	timestamp_logger(logger) =
    	TransformerLogger(logger) do log
        	merge(log, (; message="[$(Dates.format(now(), date_format))] $(log.message)"))
    	end
	with_logger(current_logger() |> timestamp_logger) do
		@info "The time will be added to this message"
	end
end

# ╔═╡ 40fea74a-0f17-11f0-2c2c-d356a1a2b91d
md"""
# Logging
Logging is very important when writing code, logged messages are used to track the execution of the program, also allowing to more simply identify bugs and debug them.

Julia has two main libraries for logging, the base one `Logging` and an extended version `LoggingExtras`.

The main types of logging are:
- Error
- Warn
- Info
- Debug

We can decide which is the minimul level to log, the important thing is that the code below that thersold will not get executed, this allows to mark as debug some expensive checks that we want to perform only when we are performing a debug.
"""

# ╔═╡ 8df6d668-11a0-4ed3-82e6-eeaa833bdf1e
md"""
## Log a message
To log a message, we just need to use the macros `@error`, `@warn`, `@info` and `@debug`, followed by the message we wish to show
"""

# ╔═╡ e1be3bfb-0764-435d-872f-e073ca3c3ee8
begin
	@error "This is an error message"
	@warn "This is a warn message"
	@info "This is an info message"
	@debug "This is a debug message"
end

# ╔═╡ 950186f6-1cb1-480d-9898-1033a7fa86d2
md"""
we can also add variables to it that will be shown togheter with the message, this is very useful when debugging
"""

# ╔═╡ ca6dd602-d5d6-496d-9711-783925d39764
let
	A = [1, 2, 3]
	@info "This is an info message" A
	@info "you can also use keyword" var=A
end

# ╔═╡ 57e26ae6-3972-4d86-8f66-0932192139fc
md"""
## TeeLogger
There are many Loggers defined in `LoggingExtras` and we probably won't have time to go through all of them. Let's start with the `TeeLogger` or `demux`, this simply reroutes the log messages to different loggers. The interface of the constructor is:
```julia
TeeLogger(loggers::AbstractLogger...)
```
and the log message will be passed to all the loggers passed. A possible usage of it could be to print the debug messages in a different place respect to the info messages, in this way we would have a more clean space where we have only the imporant messages, and another place where we have detailed informations about the running code.
"""

# ╔═╡ 4b3aa5b4-0b71-46b4-aaa4-c038e7abb998
md"""
## ActiveFilteredLogger
This allows to only select some log messages to show based on a filter function
"""

# ╔═╡ 0dc51c5f-9a79-406a-ad52-5929283e9013
begin
	logger = ActiveFilteredLogger(log->startswith(log.message,"I'm an unicorn"), current_logger())
	with_logger(logger) do
		@info "I'm an unicorn with a rainbow mantle" 	# this will be showed
		@info "I'm a bear" 	# this will not
	end
end

# ╔═╡ e7a7867d-56e3-4524-b3c2-5fcf6dc7c6f8
md"""
!!! note
	Pluto doesn't allow to set the global logger since each cell is evaluated with a different logger, but the function `global_logger([logger])` returns the current global logger, and if a logger is passed as argument, the global logger is changed.
"""

# ╔═╡ 091b39ce-ca5f-41df-8bd7-a672db2363a7
md"""
### EarlyFilteredLogger
This is similar to the `ActiveFilteredLogger` but the filter function is called before the log message is generated so the filter cannot be based on it, but it can still access:
- `level` the level of the log
- `module` which module called the logger
- `id` this is a unique identifier of the message
"""

# ╔═╡ 537840b2-81d4-4c2a-ab2d-9b6825432f98
md"""
## MinLevelLogger
This is a special case of the early filtered logger that checks if the message level is above the level specified when created.
"""

# ╔═╡ 81f9d9a8-c138-417d-b90b-89b56d54be16
begin
	error_only_logger = MinLevelLogger(current_logger(), Logging.Error);
	with_logger(error_only_logger) do
           @info "You won't see this"
           @warn "won't see this either"
           @error "You will only see this"
    end
end

# ╔═╡ 9117b3c6-80af-463d-8e4d-a35bef1023ac
md"""
## TransformerLogger
This allows to transform the log received, not just the log message. A nice example is to add the time to the log message
"""

# ╔═╡ c1a949d5-adb4-444c-be32-b8904a49d198
md"""
## FileLogger
This logs to a file, let's see a more complex exampl combining the previous types

```julia-repl
julia> using LoggingExtras;

julia> demux_logger = TeeLogger(
    MinLevelLogger(FileLogger("info.log"), Logging.Info),
    MinLevelLogger(FileLogger("warn.log"), Logging.Warn),
);


julia> with_logger(demux_logger) do
    	@warn("It is bad")
    	@info("normal stuff")
    	@error("THE WORSE THING")
    	@debug("it is chill")
	end

shell>  cat warn.log
┌ Warning: It is bad
└ @ Main REPL[34]:2
┌ Error: THE WORSE THING
└ @ Main REPL[34]:4

shell>  cat info.log
┌ Warning: It is bad
└ @ Main REPL[34]:2
┌ Info: normal stuff
└ @ Main REPL[34]:3
┌ Error: THE WORSE THING
└ @ Main REPL[34]:4
```
"""

# ╔═╡ b5e0e0cb-3adb-4f2f-a231-170ddc1ee6aa
md"""
This is the usual setup I use in my own code:
```julia
using LoggingExtras, Dates

const date_format = "yyyy-mm-dd HH:MM:SS"

timestamp_logger(logger) =
    TransformerLogger(logger) do log
        merge(log, (; message="[$(Dates.format(now(), date_format))] $(log.message)"))
    end

demux_logger(infoFileName::AbstractString, debugFileName::AbstractString) = TeeLogger(
    MinLevelLogger(FileLogger("$infoFileName.info.log"; append=true), Logging.Info),
    MinLevelLogger(FileLogger("$debugFileName.debug.log"; append=true), Logging.Debug),
);
demux_logger(str::AbstractString) = demux_logger(str, str)

demux_logger(joinpath(folder_name, baseFilename)) |> timestamp_logger |> global_logger
```
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
LoggingExtras = "e6f89c97-d47a-5376-807f-9c37f3926c36"

[compat]
LoggingExtras = "~1.1.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.4"
manifest_format = "2.0"
project_hash = "380e1b5754233b76a61d3f37fa568a1ab6698a1b"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"
"""

# ╔═╡ Cell order:
# ╟─40fea74a-0f17-11f0-2c2c-d356a1a2b91d
# ╟─8df6d668-11a0-4ed3-82e6-eeaa833bdf1e
# ╠═e1be3bfb-0764-435d-872f-e073ca3c3ee8
# ╟─950186f6-1cb1-480d-9898-1033a7fa86d2
# ╠═ca6dd602-d5d6-496d-9711-783925d39764
# ╠═cd7d1a77-533c-4898-863b-6f4030666886
# ╟─57e26ae6-3972-4d86-8f66-0932192139fc
# ╟─4b3aa5b4-0b71-46b4-aaa4-c038e7abb998
# ╠═0dc51c5f-9a79-406a-ad52-5929283e9013
# ╟─e7a7867d-56e3-4524-b3c2-5fcf6dc7c6f8
# ╟─091b39ce-ca5f-41df-8bd7-a672db2363a7
# ╟─537840b2-81d4-4c2a-ab2d-9b6825432f98
# ╠═81f9d9a8-c138-417d-b90b-89b56d54be16
# ╟─9117b3c6-80af-463d-8e4d-a35bef1023ac
# ╠═67abc344-0920-44cc-87e0-a582c8976ff9
# ╟─c1a949d5-adb4-444c-be32-b8904a49d198
# ╟─b5e0e0cb-3adb-4f2f-a231-170ddc1ee6aa
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
