# IndexedTables

[`IndexedTables`](https://github.com/JuliaComputing/IndexedTables.jl) are DataFrame-like data structure that, working with tuples dictionaries, are in my experience much faster to perform select operations.

There are two types of IndexedTables, `table` and `ndsparse`. The main difference from a user-point of view is that the former is looked up by position, while the later can be looked up by stored values (and hence is, at least for me, more useful):


```Julia
# Let's create some fake data..
param     = String["price","price","price","price","waterContent","waterContent"]
item      = String["banana","banana","apple","apple","banana", "apple"]
region    = Union{String,Missing}["FR","UK","FR","UK",missing,missing]
value2000 = Float64[2.8,2.7,1.1,0.8,0.2,0.7]
value2010 = Float64[3.2,2.9,1.2,0.8,0.2,0.8]

# table constructor..
myTable = table(
  (param=param,item=item,region=region2,value00=value2000,value10=value2010)
  ;
  pkey = [:param, :item, :region]
 )

# ndsparse construct.. note two separated NamedTuples for keys and values..
mySparseTable = ndsparse(
 (param=param,item=item,region=region),
 (value00=value2000,value10=value2010)
)

# Query data..
myTable[3]
mySparseTable["price",:,:] # ":" let select all values for the specific dimension

# Edit individual items (only for ndsparse):
mySparseTable["price","banana","FR"] = (value00=2.7, value10=3.2)
```


_While an updated, expanded and revised version of this chapter is available in "Chapter 9 - Working with Data" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
