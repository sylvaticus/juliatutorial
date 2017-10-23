# [IndexedTables](https://github.com/JuliaComputing/IndexedTables.jl)

IndexedTables are DataFrame-like data structure that, working with touples dictionaries, are in my experience much faster to perform select operations.

## Create an IndexedTable

The constructor for IndexedTable takes two parts, a Column for the index (dimensions) part and one for the value part. Both can be named or not:

```
 tnamed = Table(
    Columns(
        param  = String["price","price","price","price","waterContent","waterContent"],
        item   = String["banana","banana","apple","apple","banana", "apple"],
        region = Union{String,DataArrays.NAtype}["FR","UK","FR","UK",NA,NA]
    ),
    Columns(
       value2000 = Float64[2.8,2.7,1.1,0.8,0.2,0.7],
       value2010 = Float64[3.2,2.9,1.2,0.8,0.2,0.8],
    )
)

tnormal = Table(
    Columns(
        String["price","price","price","price","waterContent","waterContent"],
        String["banana","banana","apple","apple","banana", "apple"],
        Union{String,DataArrays.NAtype}["FR","UK","FR","UK",NA,NA]
    ),
    Columns(
       Float64[2.8,2.7,1.1,0.8,0.2,0.7],
       Float64[3.2,2.9,1.2,0.8,0.2,0.8]
    )
) 
```

An alternative way to construct a `Column` is to use a serie of Arrays and the optional `names` paramenter:
```
dimValues = [Array{String,1}(),Array{Int,1}()]
s = Columns(dimValues..., names=[:region,:year])
```

## Edit values

Assign/change values: `t["price","banana","FR] = 2.7, 3.2`