# Dataframes

Julia has a library to handle tabular data, in a way similar to R or Pandas dataframes. The name is, no surprises, [DataFrames](https://github.com/JuliaStats/DataFrames.jl). The approach and the function names are similar, although the way of actually accessing the API may be a bit different.

Here is a list of common operations with a dataframe:
* Install the library: `Pkg.add(DataFrames)`
* Load the library: `using DataArrays, DataFrames`
* Read a CSV file: myData = `readtable("mydatafile.csv", separator = ';')`
* Concatenate different dataframes (with same structure): `df = vcat(my_df_list)`
* Delete columns by name: `delete!(df, [:col1, :col2])`
* Replace values based to a dictionary : `mydf[:col1] = map(akey->myDict[akey], mydf[:col1])` (the original data to replace can be in a different column or a totally different dataframe
Get insights about your data:
* `head(df)`
* `tail(df)`
* `describe(df)`
* `unique(df[:fieldName])`
* `count(df[:fieldName])`
Aggregate by several fields:
* `aggregate(df, [:field1, :field2], sum)`
Attenction that all categorical fields have to be included in the list of fields on which to aggregate, otherwise julia will try to comput a sum over them (that being string will rice an error) instead of just ignoring them.
The workaround is to remove the fields you don't want before doing the operation.

Filter by value
* Based on a field being in a list of values: `df[indexin(df[:colour], ["blue","green"]) .> 0, :]`


See also the section [Interfacing Julia with other languages](interfacing-julia-with-other-languages.md) to get an example on how to load data from an ods file.

