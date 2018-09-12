# LAJuliaUtils

\`\`[`LAJuliaUtils`](https://github.com/sylvaticus/LAJuliaUtils.jl) is my personal repository for utility functions, mainly for dataframes.

As it is not a registered Julia package, use it with :`add https://github.com/sylvaticus/LAJuliaUtils.jl.git`

It implements the following functions:

* `addCols!(df, colsName, colsType)` - Adds to the DataFrame empty column\(s\) colsName of type\(s\) colsType
* `pivot(df::AbstractDataFrame, rowFields, colField, valuesField; <kwd args>)` - Pivot and optionally filter and sort in a single function
* `customSort!(df, sortops)` - Sort a DataFrame by multiple cols, each specifying sort direction and custom sort order
* `toDict(df, dimCols, valueCol)` - Convert a DataFrame in a dictionary, specifying the dimensions to be used as key and the one to be used as value.
* `toDataFrame(t)` - Convert an IndexedTable NDSparse table to a DataFrame, maintaining column types and \(eventual\) column names.
* `defEmptyIT(dimNames, dimTypes; <kwd args>)` - Define empty IndexedTable\(s\) with the specific dimension\(s\) and type\(s\).
* `defVars(vars, df, dimensions;<kwd args>)` - Create the required IndexedTables from a common DataFrame while specifing the dimensional columns.
* `fillMissings!(vars, value, dimensions)` - For each values in the specified dimensions, fill the values of IndexedTable\(s\) without a corresponding key.

In particular the pivot\(\) function accepts the following arguments: 

* `df::AbstractDataFrame`: the original dataframe, in stacked version \(dim1,dim2,dim3... value\)
* `rowFields`:             the field\(s\) to be used as row categories \(also known as IDs or keys\)
* `colField::Symbol`:      the field containing the values to be used as column headers
* `valuesField::Symbol`:   the column containing the values to reshape
* `ops=sum`:               the operation\(s\) to perform on the data, default on summing them
* `filter::Dict`:          an optional filter, in the form of a dictionary of column\_to\_filter =&gt; \[list of ammissible values\]
* `sort`:                  optional row field\(s\) to sort

Note: I didn't yet released `LAJuliaUtils` for Julia 1.0, as some minor functionalities \(not actually needed for the `pivot()` function\) require [`IndexedTables`](https://github.com/JuliaComputing/IndexedTables.jl) ported to Julia 1.0. But if you need it, [open an issue](https://github.com/sylvaticus/LAJuliaUtils.jl/issues) and I'll release a Julia 1.0 version with the code that doesn't depend to `IndexedTables`.

