# DataFrames

## Dataframes

Julia has a library to handle tabular data, in a way similar to R or Pandas dataframes. The name is, no surprises, [DataFrames](https://github.com/JuliaStats/DataFrames.jl). The approach and the function names are similar, although the way of actually accessing the API may be a bit different.  
For complex analysis, [DataFramesMeta](https://github.com/JuliaStats/DataFramesMeta.jl) adds some helper macros.

## Documentation:

* DataFrames: [http://juliadata.github.io/DataFrames.jl/stable/](http://juliadata.github.io/DataFrames.jl/stable/), [https://en.wikibooks.org/wiki/Introducing\_Julia/DataFrames](https://en.wikibooks.org/wiki/Introducing_Julia/DataFrames)
* DataFramesMeta: [https://github.com/JuliaStats/DataFramesMeta.jl](https://github.com/JuliaStats/DataFramesMeta.jl)
* Stats in Julia in general: [http://juliastats.github.io/](http://juliastats.github.io/)

### Install and import the library

* Install the library: `Pkg.add(DataFrames)`
* Load the library: `using DataFrames`

### Create a df or load data:

* From a table defined in code:

```text
using CSV
supplytable = CSV.read(IOBuffer("""
prod      Epinal Bordeaux Grenoble
Fuelwood  400    700      800
Sawnwood  800    1600     1800
Pannels   200    300      300
"""), delim=" ", ignorerepeated=true, copycols=true)
```

* Read a CSV file: `myData = CSV.read(file; delim=';', missingstring="NA", delim=";", decimal=',', copycols=true)` \(use `CSV.read(file; delim='\t')` for tab delimited files\)

If a column has in the first top rows used by type-autorecognition only missing values, but then has non-missing values in subsequent rows, an error may appear. The trick is to manually specify the column value with the `type` parameter \(Vector or Dictionary, e.g. `types=Dict("freeDim" => Union{Missing,Int64})`\)

If you need to edit the values of your imported dataframe, do not forget the `copycols=true` option.

* From a stream, use the package `HTTP`:

  ```text
  using DataFrames, HTTP, CSV
  resp = HTTP.request("GET", "https://data.cityofnewyork.us/api/views/kku6-nxdu/rows.csv?accessType=DOWNLOAD")
  df = CSV.read(IOBuffer(String(resp.body)))
  ```

* From a OpenDocument Spreadsheet file \(OpenOffice, LibreOffice, MS Excel and others\): Use the [`OdsIO` package](https://github.com/sylvaticus/OdsIO.jl) together with the `retType="DataFrame"` argument: `df = ods_read("spreadsheet.ods";sheetName="Sheet2",retType="DataFrame",range=((tl_row,tl_col),(br_row,br_col)))`
* Crate a df from scratch:

  ```text
  df = DataFrame(
  colour = ["green","blue","white","green","green"],
  shape  = ["circle", "triangle", "square","square","circle"],
  border = ["dotted", "line", "line", "line", "dotted"],
  area   = [1.1, 2.3, 3.1, missing, 5.2])
  ```

* Create an empty df: `df = DataFrame(A = Int64[], B = Float64[])`
* Convert from a Matrix of data and a vector of column names:  `df = DataFrame([[mat[:,i]...] for i in 1:size(mat,2)], Symbol.(headerstrs))`
* Convert from a Matrix with headers in the first row:  `df = DataFrame([[mat[2:end,i]...] for i in 1:size(mat,2)], Symbol.(mat[1,:]))`

### Get insights about your data:

* `first(df, 6)`
* `show(df, allrows=true, allcols=true)`
* `last(df, 6)`
* `describe(df)`
* `unique(df.fieldName)` or `[unique(c) for c in eachcol(df)]`
* `names(df)` returns array of column names
* `[eltype(col) for col = eachcol(df)]` returns an array of column types
* `size(df)` \(r,c\), `size(df)[1]` \(r\), `size(df)[2]` \(c\)
* `ENV["LINES"] = 60` change the default number of lines before the content is truncated \(default 30\). Also COLUMNS. May not work with terminal.
* `for c in eachcol(df)` iterates over each column
* `for r in eachrow(df)` iterates over each row

Column names are Julia symbols. To programmatically compose a column name you need hence to use the Symbol\(String\) constructor, e.g.:  
`Symbol("value_",0)`



#### Filter \(aka "selection" or "query"\)

There are two ways to refer to some column(s) in a DataFrame, by referencing the stored values in the new object, or by copying them into the new object.

Referencing is obtained using the exclamation mark for the row position (to emphasize that referenced data could be changed in the new object) or using the dot syntax: `myObjWithReferencedData = df[!,[cNames]]` or `myObjWithReferencedData.cName`.

Copying use instead the old two point syntax: `myobjWithCopyedData = df[:,[cName(s)]]`.


* Filter by value, based on a field being in a list of values using boolean selection trough list comprehension: `df[ [i in ["blue","green"] for i in df.colour], :]`
* Combined boolean selection: `df[([i in ["blue","green"] for i in df.colour] .> 0) .& (df.shape .== "triangle"), :]` \(the dot is needed to vectorize the operation. Note the usage of the bitwise and the single ampersand\).
* Filter using `@where` \(`DataFrameMeta` package\): `@where(df, :x .> 2, :y .== "a")  # the two expressions are "and-ed"`. If the column name is stored in a variable, you need to wrap it using the `cols()` function, e.g. `col = Symbol("x");  @where(df, cols(col) .> 2)`
* Change a single value by filtering columns: `df[ (df.product .== "hardWSawnW") .& (df.year .== 2010) , :consumption] = 200`
* Filter based on initial pattern: `filteredDf = df[startswith.(df.field,pattern),:]`
* A benchmark note: using `@with()` or boolean selection is ~ the same, while "querying" an equivalent Dict with categorical variables as tuple keys is around ~20% faster than querying the dataframe.
* A further \(and perhaps more elegant, although longer\) way to query a DataFrame is to use the [`Query`](https://github.com/queryverse/Query.jl) package. The first example above let you select a subsets of both rows and columns, the second one highlight instead how you can mix multiple selection criteria:

```text
dfOut = @from i in df begin
           @where i.col1 > 1
           @select {aNewColName=i.col1, i.col3}
           @collect DataFrame
        end
 dfOut = @from i in df begin
            @where i.value != 1 && i.cat1 in ["green","pink"]
            @select i
            @collect DataFrame
        end
```
### Edit data

* Replace values based to a dictionary : `mydf.col1 = map(akey->myDict[akey], mydf.col1)` \(the original data to replace can be in a different column or a totally different DataFrame
* Concatenate \(string\) values for several columns to create the value a new column: `df.c = df.a .* " " .* df.b`
* To compute the value of a column based of other columns you need to use  elementwise operations using the dot,  e.g. `df.a = df.b .* df.c` \(note that the equal sign doesn't have the dot.. but if you have to make a comparison, the `==` operator wants also the dot, i.e. `.==`\)
* Append a row: `push!(df, [1 2 3])`
* Delete a given row: use `deleterows!(df,rowIdx)` or just copy a df without the rows that are not needed, e.g. `df2 = df[[1:(i-1);(i+1):end],:]`
* Empty a dataframe: `df = similar(df,0)`

### Edit structure

* Delete columns by name: `select!(df, Not([:col1, :col2]))`
* Rename columns: `names!(df, [:c1,:c2,:c3])` \(all\) `rename!(df, Dict(:c1 => :newCol))` \(a selection\)
* Change column order: `df = df[:,[:b, :a]]`
* Add an "id" column \(useful for unstacking\): `df.id = 1:size(df, 1)`  \# this makes it easier to unstack
* Add a Float64 column \(all filled with missing by default\): `df.a = Array{Union{Missing,Float64},1}(missing,size(df,1))`
* Add a column based on values of other columns: `df.c =  df.a .+ df.b` \(as alternative use map: `df.c = map((x,y) -> x + y, df.a, df.b)`\)
* Insert a column at a position i:  `insert!(df, i, [colContent], :colName)`
* Convert columns:
  * from Int to Float: `df.A = convert(Array{Float64,1},df.A)`
  * from Float to Int: `df.A = convert(Array{Int64,1},df.A)`
  * from Int \(or Float\) to String: `df.A = map(string, df.A)`
  * from String to Float: `string_to_float(str) = try parse(Float64, str) catch; return(missing) end; df.A = map(string_to_float, df.A)`
  * from Any to T \(including String, if the individual elements are already strings\): `df.A = convert(Array{T,1},df.A)`
* You can "pool" specific columns in order to efficiently store repeated categorical variables with `categorical!(df, [:A, :B])`. Attention that while the memory decrease, filtering with categorical values is not quicker \(indeed it is a bit slower\). You can go back to normal arrays wih `collect(df.A)`.

#### Merge/Join/Copy datasets

* Concatenate different dataframes \(with same structure\): `df = vcat(df1,df2,df3)` or `df = vcat([df1,df2,df3]...)` \(note the three dots at the end, i.e. the splat operator\).
* Join dataframes horizontally: `fullDf = join(df1, df2, on = :commonCol)`. The on parameter can also be an array of common columns. There are many possible types of join , the most common ones are:
  ** `:inner` (default, only rows with keys on both sides are returned),
  ** `:left` (additionally, rows on the left df with keys not present on the df on the right are also returned),
  ** `:right` (opposite of :left ),
  ** `:outer` (rows with elements missing in any of the two df are also returned);
* Copy the structure of a DataFrame \(to an empty one\): `df2 = similar(df1, 0)`


### Manage Missing values

Starting from Julia 1, `Missings` type is defined in core \(with some additional functionality still provided by the additional package `Missings.jl`\). At the same time,  a `DataFrame` changes from being a collection of `DataArrays` to a collection of standard `Arrays`, eventually of type `Union{T,Missing}` if missing data is present.

* The missing value is simply `missing`
* Remove missing values with: `a = collect(skipmissing(df.col1))` \(returns an `Array`\) or `b = dropmissing(df[[:col1,:col2]])` \(returns a `DataFrame` even for a single column\)
* `dropmissing!(df)`\(in both its version with or without question mark\) and `completecases(df)` select only rows without missing values. The first returns the skimmed `DataFrame`, while the second return a boolean array, and you can also specify on which columns you want to limit the application of this filter `completecases(df[[:col1,:col2]])`. You can then get the df with`df2 = df[completecases(df[[:col1,:col2]]),:]`\)
* Within an operation \(e.g. a sum\) you can use `dropmissing()` in order to skip `missing` values before the operation take place.
* Remove missing values on all string and numeric columns: `[df[ismissing.(df[!,i]), i] .= 0 for i in names(df) if Base.nonmissingtype(eltype(df[!,i])) <: Number]` and `[df[ismissing.(df[!,i]), i] .= "" for i in names(df) if Base.nonmissingtype(eltype(df[!,i])) <: String]`
* To make comparison \(e.g. for boolean selection or within the `@where` macro in `DataFramesMeta`\) where missing values could be present you can use `isequal.(a,b)` to NOT propagate the missing \(i.e. `isequal("green",missing)` is true\) or the confrontation operator \(`==`\)to preserve missingness \(i.e. `"green" == missing` is neither `true` nor `false` but `missing`\)
* Count the `missing` values: `nMissings = length(findall(x -> ismissing(x), df.col))`

### Split-Apply-Combine strategy

The DataFrames package supports the Split-Apply-Combine strategy through the `by` function, which takes in three arguments: \(1\) a DataFrame, \(2\) a column \(or columns\) to split the DataFrame on, and \(3\) a function or expression to apply to each subset of the DataFrame.

The function can return a value, a vector, or a DataFrame. For a value or vector, these are merged into a column along with the `cols` keys. For  
a DataFrame, `cols` are combined along columns with the resulting DataFrame. Returning a DataFrame is the clearest because it allows column labelling.

`by` function can take the function as first argument, so to allow the usage of do blocks.  
Inside, it uses the groupby\(\) function, as in the code it is defined as nothing else than:

```text
by(d::AbstractDataFrame, cols, f::Function) = combine(map(f, groupby(d, cols)))
by(f::Function, d::AbstractDataFrame, cols) = by(d, cols, f)
```

#### Aggregate

Aggregate by several fields:

* `aggregate(df, [:field1, :field2], sum)`

  Attention that all categorical fields have to be included in the list of fields over which to aggregate, otherwise Julia will try to compute a sum also over them \(but them being string, it will raice an error\) instead of just ignoring them.

  The workaround is to remove the fields you don't want before doing the operation.

* Alternatively \(and without the problem of the previous point\):

  ```text
  by(df, [:catfield1,:catfield2]) do df
    DataFrame(m = sum(df.valueField))
  end
  ```

#### Compute cumulative sum by categories

* Manual method \(very slow\):

  ```text
  df = DataFrame(region=["US","US","US","US","EU","EU","EU","EU"],
               year = [2010,2011,2012,2013,2010,2011,2012,2013],
               value=[3,3,2,2,2,2,1,1])
  df.cumValue = copy(df.value)
  [r.cumValue = df[(df.region .== r.region) .& (df.year .== (r.year-1)),:cumValue][1] + r.value  for r in eachrow(df) if r.year != minimum(df.year)]
  ```

* Using by and the split-apply-combine strategy \(fast\):

  ```text
  using DataFramesMeta, DataFrames
  df = DataFrame(region  = ["US","US","US","US","EU","EU","EU","EU"],
               product = ["apple","apple","banana","banana","apple","apple","banana","banana"],
               year    = [2010,2011,2010,2011,2010,2011,2010,2011],
               value   = [3,3,2,2,2,2,1,1])
  df.cumValue = copy(df.value)
  by(df, [:region,:product]) do dd
    dd.cumValue .= cumsum(dd.value)
       return
  end
  ```

* Using @linq \(from DataFramesMeta\) and the split-apply-combine strategy \(fast\):

  ```text
  using DataFramesMeta, DataFrames
  df = DataFrame(region  = ["US","US","US","US","EU","EU","EU","EU"],
               product = ["apple","apple","banana","banana","apple","apple","banana","banana"],
               year    = [2010,2011,2010,2011,2010,2011,2010,2011],
               value   = [3,3,2,2,2,2,1,1])
  df = @linq df |>
  groupby([:region,:product]) |>
  transform(cumValue = cumsum(:value))
  ```

* Using groupby \(fast\):

  ```text
  using DataFramesMeta, DataFrames
  df = DataFrame(region  = ["US","US","US","US","EU","EU","EU","EU"],
               product = ["apple","apple","banana","banana","apple","apple","banana","banana"],
               year    = [2010,2011,2010,2011,2010,2011,2010,2011],
               value   = [3,3,2,2,2,2,1,1])
  df.cumValue .= 0.0
  for subdf in groupby(df,[:region,:product])
    subdf.cumValue .= cumsum(subdf.value)
  end
  ```

### Pivot

#### Stack

Move columns to rows of a "variable" column, i.re. moving from wide to long format.  
For `stack(df,[cols])` you have to specify the column\(s\) that have to be stacked, for `melt(df,[cols])` at the opposite you specify the other columns, that represent the id columns that are already in stacked form.  
Finally `stack(df)` - without column names - automatically stack all float columns.  
Note that the stacked columns are inserted as data in a "variable" column \(with names of the variables not strings but symbols\) and the corresponding values in a "column" value.

```text
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

#### Unstack

You can specify the dataframe, the column name which content will become the row index \(id variable\), the column name with content will become the name of the columns \(column variable names\) and the column name containing the values that will be placed in the new table \(column values\):

`widedf = unstack(longdf, [:ids], :variable, :value)`

Alternatively you can omit the `:id` parameter and all the existing column except the one defining column names and the one defining column values will be preserved as index \(row\) variables:

`widedf = unstack(longdf, :variable, :value)`

#### Sorting

`sort!(df, cols = (:col1, :col2), rev = (false, false))` The \(optional\) reverse order parameter \(rev\) must be a tuple of the same size as the cols parameter

#### Use LAJuliaUtils.jl

You can use \(my own utility module\) [`LAJuliaUtils.jl`](https://github.com/sylvaticus/LAJuliaUtils.jl)  in order to Pivot and optionally filter and sort in a single function in a spreadsheet-like Pivot Tables fashion. See the [relevant section](17-indexedtables.md).

### Export your data

#### Export to CSV

`CSV.write("file.csv", df, delim = ';', header = true)` \(from package `CSV`\)

#### Export to ods \(OpenDocument Spreadsheet file - OpenOffice, LibreOffice, MS Excel and others\)

Use the [`OdsIO` package](https://github.com/sylvaticus/OdsIO.jl):

`ods_write("spreadsheet.ods",Dict(("MyDestSheet",3,2)=>myDf)))`

#### Export to Dict

This export to a dictionary where the keys are the unique elements of a df column and the values are the splitted dataframes:

```text
vars = Dict{String,DataFrame}()
[vars[x] = @where(df, :varName .== x) for x in unique(df.varName)]
[select!(vars[k], Not([:varName])) for k in keys(vars)]
```

#### Export to hdf5 format

To use hdf5 with the [`HDF5` package](https://github.com/JuliaIO/HDF5.jl), some systems may require system-wide hdf5 binaries, e.g. in Ubuntu linux `sudo apt-get install hdf5-tools.`

`h5write("out.h5", "mygroup/myDf", convert(Array, df[:,[list_of_cols]))`

The HDF5 package doesn't yet support directly dataframes, so you need first to export them as Matrix \(a further limitation is that it doesn't accept a matrix of Any type, so you may want to export a DataFrame in two pieces, the string and the numeric columns separatly\). You can read back the data with `data = h5read("out.h5", "mygroup/myDf")`.

_While an updated, expanded and revised version of this chapter is available in "Chapter 9 - Working with Data" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
