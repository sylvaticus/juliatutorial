# Dataframes

Julia has a library to handle tabular data, in a way similar to R or Pandas dataframes. The name is, no surprises, [DataFrames](https://github.com/JuliaStats/DataFrames.jl). The approach and the function names are similar, although the way of actually accessing the API may be a bit different.

## Install and import the library
* Install the library: `Pkg.add(DataFrames)`
* Load the library: `using DataArrays, DataFrames`

## Create a df or load data:
* From a table (csw: comma separated values,  wsv: white-space separated values):

```
supplytable = wsv"""
prod     Epinal Bordeaux Grenoble
Fuelwood 400    700      800
Sawnwood 800    1600     1800
Pannels  200    300      300
"""
```

* Read a CSV file: myData = `readtable("mydatafile.csv", separator = ';')`
* Crate a df from scratch:
```
df = DataFrame(
colour = ["green","blue","white","green","green"],
shape  = ["circle", "triangle", "square","square","circle"],
border = ["dotted", "line", "line", "line", "dotted"],
area   = [1.1, 2.3, 3.1, 4.2, 5.2])
```

## Get insights about your data:
* `head(df)`
* `tail(df)`
* `describe(df)`
* `unique(df[:fieldName])`
* `count(df[:fieldName])`

## Edit/modify data
* Concatenate different dataframes (with same structure): `df = vcat(my_df_list)`
* Delete columns by name: `delete!(df, [:col1, :col2])`
* Replace values based to a dictionary : `mydf[:col1] = map(akey->myDict[akey], mydf[:col1])` (the original data to replace can be in a different column or a totally different dataframe
* Filter by value, based on a field being in a list of values: `df[indexin(df[:colour], ["blue","green"]) .> 0, :]`
* Alternative using list comprehension: `df[ [i in ["blue","green"] for i in df[:colour]], :]`
* Combined boolean selection: `df[(indexin(df[:colour], ["blue","green"]) .> 0) & (df[:shape] .== "triangle"), :]` (the dot is needed to vectorize the operation)

## Aggregate/pivot
Aggregate by several fields:
* `aggregate(df, [:field1, :field2], sum)`
Attenction that all categorical fields have to be included in the list of fields on which to aggregate, otherwise julia will try to comput a sum over them (that being string will rice an error) instead of just ignoring them.
The workaround is to remove the fields you don't want before doing the operation.


## Export your data
writetable("file.csv", df, separator = ';', header = false)

See also the section [Interfacing Julia with other languages](interfacing-julia-with-other-languages.md) to get an example on how to load data from an ods file.

