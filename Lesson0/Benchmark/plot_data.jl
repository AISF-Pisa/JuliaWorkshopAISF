using DelimitedFiles
using Plots

const language_ext = NamedTuple{(:language, :ext), Tuple{String, String}}

languages = language_ext[]
push!(languages, language_ext(("Julia", "jl")))
push!(languages, language_ext(("Python", "py")))
push!(languages, language_ext(("Fortran", "f90")))

plot(xlabel="Matrix size", ylabel="Time (ms)", title="Matrix multiplication benchmark", dpi=300)
for (lang, ext) in languages
	data = readdlm("rand_mul.$ext.dat")
	plot!(data[:, 1], data[:, 2]*1000, label = lang)
end
gui()
png("rand_mul.png")