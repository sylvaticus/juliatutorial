# Dataframes

Julia has a library to handle tabular data, in a way similar to R or Pandas dataframes. The name is, no surprises, [DataFrames](https://github.com/JuliaStats/DataFrames.jl). The approach and the function names are similar, altought the way of actually access the API may be a bit different.

Install the library: `Pkg.add(DataFrames)`  
Load the library: `using DataArrays, DataFrames`  
Read a CSV file: myData = `readtable\("mydatafile.csv", separator = ';'\)`  
Concatenate different dataframes \(with same structure\): `df = vcat(my_df_list)`  
Delete columns by name: `delete!(df, [:col1, :col2])`  

Replace values based to a dictionary : `mydf[:col1] = map(akey->myDict[akey], mydf[:col1])`

\(the original data to replace can be in a different column or a totally different dataframe\)

See also the section "Interfacing with other languages" to get an example on how to load data from an ods file.