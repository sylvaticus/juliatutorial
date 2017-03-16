# Dataframes

Julia has a library to handle tabular data, in a way similar to R or Pandas dataframes. The name is, no surprises, [DataFrames](https://github.com/JuliaStats/DataFrames.jl). The approach and the function names are similar, although the way of actually accessing the API may be a bit different.
For complex analysis, [DataFramesMeta](https://github.com/JuliaStats/DataFramesMeta.jl) adds some helper macros.

# Documentation:
* DataFrames: https://dataframesjl.readthedocs.io/en/latest/getting_started.html, http://juliastats.github.io/DataFrames.jl/, https://juliastats.github.io/DataFrames.jl/stable/man/reshaping_and_pivoting/, https://en.wikibooks.org/wiki/Introducing_Julia/DataFrames
* DataFramesMeta: https://github.com/JuliaStats/DataFramesMeta.jl
* Stats in Julia in general: http://juliastats.github.io/


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
* `showall(df)`
* `tail(df)`
* `describe(df)`
* `unique(df[:fieldName])`
* `count(df[:fieldName])`
* `size(df)` (r,c), `size(df)[1]` (r), `size(df)[2]` (c)


## Edit/modify data

* Delete columns by name: `delete!(df, [:col1, :col2])`
* Replace values based to a dictionary : `mydf[:col1] = map(akey->myDict[akey], mydf[:col1])` (the original data to replace can be in a different column or a totally different dataframe
* Add an "id" column (useful for unstacking): df[:id] = 1:size(df, 1)  # this makes it easier to unstack

### Filter
* Filter by value, based on a field being in a list of values: `df[indexin(df[:colour], ["blue","green"]) .> 0, :]`
* Alternative using list comprehension: `df[ [i in ["blue","green"] for i in df[:colour]], :]`
* Combined boolean selection: `df[(indexin(df[:colour], ["blue","green"]) .> 0) & (df[:shape] .== "triangle"), :]` (the dot is needed to vectorize the operation)
* Filter using `@where` (`DataFrameMeta` package): `@where(df, :x .> 2, :y .== "a")  # the two expressions are "and-ed"`
* Change a single value by filtering columns: `df[ (df[:product] .== "hardWSawnW") & (df[:year] .== 2010) , :consumption] = 200`

## Merge/Join datasets
* Concatenate different dataframes (with same structure): `df = vcat(my_df_list)`




## Manage NA values
* The NA value is simply `NA`
* `complete_cases!(df)` or `complete_cases(df)` select only rows without NA values (you can specify on which columns you want to apply this filter with `complete_cases!(df[[:col1,:col2]])`)
* Within an operation (e.g. a sum) you can use `dropna()` in order to skip NA values before the operation take place.

## Split-Apply-Combine strategy 

The DataFrames package supports the Split-Apply-Combine strategy through the `by` function, which takes in three arguments: (1) a DataFrame, (2) a column (or columns) to split the DataFrame on, and (3) a function or expression to apply to each subset of the DataFrame.

The function can return a value, a vector, or a DataFrame. For a value or vector, these are merged into a column along with the `cols` keys. For
a DataFrame, `cols` are combined along columns with the resulting DataFrame. Returning a DataFrame is the clearest because it allows column labeling.

Alternativly the `by` function can take the function as first argument, so to allow the usage of do blocks.
It uses inside the groupby() function, as in code it is defined as nothing else than:
```
by(d::AbstractDataFrame, cols, f::Function) = combine(map(f, groupby(d, cols)))
by(f::Function, d::AbstractDataFrame, cols) = by(d, cols, f)
```

### Aggregate/

Aggregate by several fields:
* `aggregate(df, [:field1, :field2], sum)`
Attenction that all categorical fields have to be included in the list of fields on which to aggregate, otherwise julia will try to comput a sum over them (that being string will rice an error) instead of just ignoring them.
The workaround is to remove the fields you don't want before doing the operation.
* Alternativly:
```
by(df, [:catfield1,:catfield2]) do df
    DataFrame(m = sum(df[:valueField]))
end
```

### Compute cumulative sum by categories

* Manual method (very slow):
```
df = DataFrame(region=["US","US","US","US","EU","EU","EU","EU"],
               year = [2010,2011,2012,2013,2010,2011,2012,2013],
               value=[3,3,2,2,2,2,1,1])
df[:cumValue] = copy(df[:value])
[r[:cumValue] = df[(df[:region] .== r[:region]) & (df[:year] .== (r[:year]-1)),:cumValue][1] + r[:value]  for r in eachrow(df) if r[:year] != minimum(df[:year])]    
```
* Using by and the split-apply-combine strategy (fast):
```
using DataFramesMeta, DataArrays, DataFrames
df = DataFrame(region  = ["US","US","US","US","EU","EU","EU","EU"],
               product = ["apple","apple","banana","banana","apple","apple","banana","banana"],
               year    = [2010,2011,2010,2011,2010,2011,2010,2011],
               value   = [3,3,2,2,2,2,1,1])
df[:cumValue] = copy(df[:value])
by(df, [:region,:product]) do dd
    dd[:cumValue] = cumsum(dd[:value])
       return
end
```
* Using @linq (from DataFramesMeta) and the split-apply-combine strategy (fast):
```
using DataFramesMeta, DataArrays, DataFrames
df = DataFrame(region  = ["US","US","US","US","EU","EU","EU","EU"],
               product = ["apple","apple","banana","banana","apple","apple","banana","banana"],
               year    = [2010,2011,2010,2011,2010,2011,2010,2011],
               value   = [3,3,2,2,2,2,1,1])
df = @linq df |>
groupby([:region,:product]) |>
  transform(cumValue = cumsum(:value))
```

* Using groupby (fast):
```
using DataFramesMeta, DataArrays, DataFrames
df = DataFrame(region  = ["US","US","US","US","EU","EU","EU","EU"],
               product = ["apple","apple","banana","banana","apple","apple","banana","banana"],
               year    = [2010,2011,2010,2011,2010,2011,2010,2011],
               value   = [3,3,2,2,2,2,1,1])
df[:cumValue] = 0.0
for subdf in groupby(df,[:region,:product])
    subdf[:cumValue] = cumsum(subdf[:value])
end
```




## Pivot

### Stack
Move columns to rows of a "variable" column, i.re. moving from wide to long format.
For `stack(df,[cols])` you have to specify the column(s) that have to be stacked, for `melt(df,[cols])` at the opposite you specify the other columns, that represent the id columns that are already in stacked form.
Finally `stack(df)` - without column names - automatically stack all float columns.
Note that the stacked columns are inserted as row of a "variable" column (with names of the variables not strings but symbols) and the corresponding values in a "column" value.

```
df = DataFrame(region = ["US","US","US","US","EU","EU","EU","EU"],
               product = ["apple","apple","banana","banana","apple","apple","banana","banana"],
               year = [2010,2011,2010,2011,2010,2011,2010,2011],
               produced = [3.3,3.2,2.3,2.1,2.7,2.8,1.5,1.3],
               consumed = [4.3,7.4,2.5,9.8,3.2,4.3,6.5,3.0])
long1 = stack(df,[:produced,:consumed])
long2 = melt(df,[:region,:product,:year])
long3 = stack(df)
long1 == long2 == long3 # true
```

### Unstack 
You can specify the dataframe, the column name which content will become the row index (id variable), the column name with content will become the name of the columns (column variable names) and the column name containing the values that will be placed in the new table (column values):

`widedf = unstack(longdf, :id, :variable, :value)`

Alternativly you can oit the :id parameter and all the existing column except the one defining column names and the one defining column values will be preserved as index (row) variables:

`widedf = unstack(longdf, :variable, :value)`

### Sorting
`sort!(df, cols = (:col1, :col2), rev = (false, false))` The 8optional) reverse order parameter (rev) must be a turple of the same size as the cols parameter

## Export your data
writetable("file.csv", df, separator = ';', header = false)

See also the section [Interfacing Julia with other languages](interfacing-julia-with-other-languages.md) to get an example on how to load data from an ods file.

