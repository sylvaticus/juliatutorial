# 17 - IndexedTables

IndexedTables are DataFrame-like data structure that, working with tuples dictionaries, are in my experience much faster to perform select operations.

**Unfortunatly, the package is in the process to move from the Named Tuple in NamedTupèles.jl package to the new one in core, and it doesn't yet works in Julia 0.7/1.0.**  
The following code runs in Julia 0.6.

## Create an IndexedTable

The constructor for IndexedTable takes two parts, a Column for the index \(dimensions\) part and one for the value part. Both can be named or not:

```text
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

tsingle = Table(
    Columns(
        String["price","price","price","price","waterContent","waterContent"],
        String["banana","banana","apple","apple","banana", "apple"],
        Union{String,DataArrays.NAtype}["FR","UK","FR","UK",NA,NA]
    ),
    Float64[2.8,2.7,1.1,0.8,0.2,0.7]
)
```

An alternative way to construct a `Column` is to use a serie of Arrays and the optional `names` paramenter:

```text
dimValues = [Array{String,1}(),Array{Int,1}()]
s = Columns(dimValues..., names=[:region,:year])
```

Note that using `Columns()` will always build a tuple, even for a single column. If you want a single column \(unnamed!\) use directly the `Array` in the constructor, like in the tsingle example.

## Edit values

Assign/change values: `t["price","banana","FR] = 2.7, 3.2`

