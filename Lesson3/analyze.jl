function get_res(; path::String=".")
    dir = readdir(path)
    files = filter(x -> (isfile(x) && endswith(x, ".csv")), dir)
    return files
end

files = get_res()
using CSV
using Statistics

all_data = Float64[]

# Loop through each file and append its data to `all_data`
for file in files
    data = CSV.File(file, header=false)["Column1"]
    append!(all_data, data)
end

# Perform calculations on the combined data
@show 4 * mean(all_data) 4 * std(all_data) / sqrt(length(all_data))