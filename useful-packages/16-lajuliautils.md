# LAJuliaUtils

[`LAJuliaUtils`](https://github.com/sylvaticus/LAJuliaUtils.jl) is my personal repository for utility functions, mainly for dataframes.

As it is not a registered Julia package, use it with :`add https://github.com/sylvaticus/LAJuliaUtils.jl.git`

It implements the following functions:

* `addCols!(df, colsName, colsType)` - Adds to the DataFrame empty column\(s\) colsName of type\(s\) colsType
* `pivot(df::AbstractDataFrame, rowFields, colField, valuesField; <kwd args>)` - Pivot and optionally filter and sort in a single function
* `customSort!(df, sortops)` - Sort a DataFrame by multiple cols, each specifying sort direction and custom sort order
* `toDict(df, dimCols, valueCol)` - Convert a DataFrame in a dictionary, specifying the dimensions to be used as key and the one to be used as value.
* `findall(pattern,string,caseSensitive=true)` - Find all the occurrences of pattern in string

In particular the pivot\(\) function accepts the following arguments:

* `df::AbstractDataFrame`: the original dataframe, in stacked version \(dim1,dim2,dim3... value\)
* `rowFields`:             the field\(s\) to be used as row categories \(also known as IDs or keys\)
* `colField::Symbol`:      the field containing the values to be used as column headers
* `valuesField::Symbol`:   the column containing the values to reshape
* `ops=sum`:               the operation\(s\) to perform on the data, default on summing them
* `filter::Dict`:          an optional filter, in the form of a dictionary of column\_to\_filter =&gt; \[list of ammissible values\]
* `sort`:                  optional row field\(s\) to sort

_While an updated, expanded and revised version of this chapter is available in "Chapter 9 - Working with Data" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
