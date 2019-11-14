# 2 - Data types

## Scalar types

In Julia, variable names can include a subset of Unicode symbols, allowing a variable to be represented, for example, by a Greek letter.  
In most Julia development environments \(including the console\), to type the Greek letter you can use a LaTeX-like syntax, typing `\` and then the LaTeX name for the symbol, e.g. `\alpha` for `α`. Using LaTeX syntax, you can also add subscripts, superscripts and decorators.

The main types of scalar are `Int64`, `Float64`, `Char` \(e.g. `x = 'a'`\), `String`[¹](data-types.md#myfootnote1) \(e.g. `x="abc"`\) and `Bool`.

## Strings

Julia supports most typical string operations, for example: `split(s)` _\(default on whitespaces\)_, `join([s1,s2], "")`, `replace(s, "toSearch" => "toReplace")` and `strip(s)` _\(remove leading and trailing whitespaces\)_ Attention to use the single quote for chars and double quotes for strings. c

### Concatenation

There are several ways to concatenate strings:

* Concatenation operator: `*`;
* Function `string(str1,str2,str3)`;
* Combine string variables in a bigger one using the dollar symbol: `a = "$str1 is a string and $(myobject.int1) is an integer"` \("interpolation"\)

Note: the first method doesn't automatically cast integer and floats to strings.

## Arrays \(lists\)

Arrays are N-dimensional mutable containers. In this section, we deal with 1-dimensional arrays, in the next one we consider 2 or more dimensional arrays.

There are several ways to create an array:

* Empty \(zero-elements\) arrays: `a = []`.  Alternative ways:
  * `a = T[]`, e.g. `a = Int64[]`;
  * using explictitly the contructor `a = Array{T,1}()`;
  * using the `Vector` alias: `c = Vector{T}()`;
* 5-elements zeros array: `a=zeros(5)` \(or a=`zeros(Int64,5)`\) \(same with `ones()`\)
* Column vector \(_Vector_ container, alias for 1-dimensions array\) : `a = [1;2;3]` or `a=[1,2,3]`
* Row vector \(_Matrix_ container, alias for 2-dimensions array, see next section "Multidimensional and nested arrays"\): `a = [1 2 3]`

Arrays can be heterogeneous \(but in this case the array will be of `Any` type and in general much slower\): `x = [10, "foo", false]`.

If you need to store a limited set of types in the array, you can use the `Union` keyword to still have an efficient implementation, e.g. `a = Union{Int64,String,Bool}[10, "Foo", false]`.

`a = Int64[]` is just a shorthand for `a = Array{Int64,1}()` \(e.g. `a = Any[1,1.5,2.5]` is equivalent to `a = Array{Any,1}([1,1.5,2.5])`\). Attention that `a = Array{Int64,1}` \(without the round brackets\) doesn't create an Array at all, but just assign the "DataType" `Array{Int64,1}` to `a`. You can also declare an array of size _n_ \(with garbage content\) with `a=Array{T,1}(undef,n)`.

Square brackets are used to access the elements of an array \(e.g. `a[1]`\). The slice syntax `[from:step:to]` is generally supported and in several contexts will return a \(fast\) iterator rather than a list \(you can use the keyword `end`, but not `begin`\). To then transform the iterator in a list use `collect(myiterator)`. You can initialise an array with a mix of values and ranges with either `y=[2015; 2025:2030; 2100]` \(note the semicolon!\) or `y=vcat(2015, 2025:2030, 2100)`.

The following methods are useful while working with arrays:

* Push an element to the end of a: `push!(a,b)` \(as a single element even if it is an Array. Equivalent to python `append`\)
* To append all the elements of b to a: `append!(a,b)` \(if b is a scalar obviously push! and append! are the same. Attention that a string is treated as a list!. Equivalent to Python `extend` or `+=`\)
* Concatenation of arrays \(new array\): `a = [1,2,3]; b = [4,5]; c = vcat(1,a,b)`
* Remove an element from the end: `pop!(a)`
* Removing an element at the beginning \(left\): `popfirst!(a)`
* Remove an element at an arbitrary position:  `deleteat!(a, pos)`
* Add an element \(b\) at the beginning \(left\):  `pushfirst!(a,b)` \(no, `appendfirst!` doesn't exists!\)
* Sorting: `sort!(a)` or `sort(a)` \(depending on whether we want to modify or not the original array\)
* Reversing an arry: `a[end:-1:1]`
* Checking for existence: `in(1, a)`
* Getting the length: `length(a)`
* Get the maximum value: `maximum(a)` or  `max(a...)` \(`max` returns the maximum value between the given arguments\)
* Get the minimum value: `minimum(a)` or  `min(a...)` \(`min` returns the maximum value between the given arguments\)
* Empty an array: `empty!(a)` \(only column vector, not row vector\)
* Transform row vectors in column vectors: `b = vec(a)`
* Random-shuffling the elements: `shuffle(a)` \(or `shuffle!(a)`. From Julia 1.0 this require `using Random` before\)
* Checking if an array is empty: `isempty(a)`
* Find the index of a value in an array: `findall(x -> x == value, myarray)`. This is a bit tricky.  The first argument is an anonymous function that returns a boolean value for each value of `myarray`, and then `find()` returns the index position\(s\).
* Delete a given item from a list: `deleteat!(myarray, findall(x -> x == myunwanteditem, myarray))`

### Multidimensional and nested arrays

In Julia, an array can have 1 dimension \(a column, also known as `Vector`\), 2 dimensions \(that is, a `Matrix`\) or more. Then each element of the Vector or Matrix can be a scalar, a vector or an other Matrix.  
The main difference between a `Matrix` and an _array of array_ is that in the former the number of elements on each column \(row\) must be the same and rules of linear algebra applies.

There are two ways to create a Matrix:

* `a = [[1,2,3] [4,5,6]]`  \[\[elements of the first column\] \[elements of the second column\] ...\] \(note that this is valid only if wrote in a single line. Use `hcat(col1, col2)` to write matrix by each column\)
* `a = [1 4; 2 5; 3 6]`    \[elements of the first row; elements of the second row; ...\] \(here you can also use `vcat(row1, row2)` to concatenate several rows\)

Attention to this difference:

* `a = [[1,2,3],[4,5,6]]` creates a 1-dimensional array with 2-elements \(each of those is again a vector\);
* `a = [[1,2,3] [4,5,6]]` creates a 2-dimensional array \(a matrix with 2 columns\) with three elements \(scalars\).

Empty matrices can be constructed as:

`m = Array{Float64}(undef, 0, 0)`

for an _\(0,0\)-size_ 2-D Matrix of type `Float64` and more in general:

`m = Array{T}(undef, a, b, ...,z)`

for an _\(a,b,...,z\)-size_ multidimensional Matrix \(whose content, of type `T,`is garbage\)

A 2x3 matrix can be constructed in one of the following ways:

* `a = [[1,2] [3,4] [5,6]]`
* `a = zeros(2,3)` or `a = ones(2,3)` \(the zeros and ones are strored as `Float64`\)
* `a = fill("abc",2,3)` \(content is "abc"\)

Nested arrays can be accessed with double square brackets, e.g. `a[2][3]`.  
Elements of bidimensional arrays can be accessed instead with the `a[row,col]` syntax, where again the slice syntax can be used, for example, given `a` is a 3x3 Matrix, `a[1:2,:]` would return a 2x3 Matrix with all the column elements of the first and second row.

Boolean selection is implemented using a boolean array/matrix for the selection:

```text
a = [[1,2,3] [4,5,6]]
mask = [[true,true,false] [false,true,false]]
```

`a[mask]` returns an 1-D array with 1, 2 and 5. Note that boolean selection results always in a flatted array, even if delete a whole row or a whole column of the original data. It is up to the programmer to then reshape the data accordingly.

Note: for row vectors, both `a[2]` or `a[1,2]` returns the second element.

n-D arrays support several methods:

* `size(a)` returns a tuple with the sizes of the _n_ dimensions
* `ndims(a)` returns the number of dimensions of the array \(e.g. 2 for a Matrix\)
* Arrays can be changed dimension with either `reshape(a, nElementsDim1, nElementsDim2)` or `dropdims(a, dims=(dimToDrop1,dimToDrop2))` \(where the dim\(s\) to drop must all have a single element for all the other dimensions, e.r. be of `size`1\)  the transpose `'` operator. These operations perform a shadow copy, returning just a different "view" of the underlying data \(so modifying the original matrix modifies also the reshaped/transposed matrix\). You can use `collect(reshape/dropdims/transpose)` to force a deepcopy.

`AbstractVector{T}` is just an alias to `AbstractArray{T,1}`, as `AbstractMatrix{T}` is just an alias to `AbstractArray{T,2}`.

Multidimensional Arrays can arise for example from using list comprehension: `a = [3x + 2y + z for x in 1:2, y in 2:3, z in 1:2]`

For further operations on arrays and matrices have a look at the [QuantEcon tutorial](http://lectures.quantecon.org/jl/julia_arrays.html#operations-on-arrays).

## Tuples

Use tuples to have a list of immutable elements: `a = (1,2,3)` or even without parenthesis `a = 1,2,3`

Tuples can be easily unpacked to multiple variable: `var1, var2 = (x,y)` \(this is useful, for example, to collect the values of functions returning multiple values\)

Useful tricks:

* Convert a tuple in a vector: `a=(1,2,3); v = [a...]` or `v = [i[1] for i in a]` or `v=collect(a)`
* Convert an array in tuple: `a = (v...,)`

## NamedTuples

NamedTuples are collections of items whose position in the collection \(index\) can be identified not only by the position but also by  name.

* Define a NamedTuple: `aNamedTuple = (a=1, b=2)`
* Access them with the dot notation: `aNamedTuple.a` .
* Get a tuple of the keys: `keys(aNamedTuple)`
* Get a tuple of the values: `values(aNamedTuple)`
* Get an Array of the values: `collect(aNamedTuple)`
* Get a iterable of the pairs \(k,v\): `pairs(aNamedTuple)`. Useful for looping: `for (k,v) in pairs(aNamedTuple) [...] end`

As "normal" tuples, NamedTuples can hold any values, but cannot be modified \(i.e. are "immutable"\).

Before Julia 1.0  Named Tuples were implemented in a separate package \([NamedTuple.jl](https://github.com/JuliaData/NamedTuples.jl)\). The idea is that, like for the Missing type, the separate package provides additional functionality to the core `NamedTuple` type, but there is still a bit of confusion over it and, at time of writing, the additional package still provide its own implementation \(and many other external packages require it\), resulting in crossed incompatibilies.

## Dictionaries

Dictionaries store mappings from keys to values, and they have an apparently random sorting.

You can create an empty \(zero-elements\) dictionary with `mydict = Dict()`, or initialize a dictionary with values: `mydict = Dict('a'=>1, 'b'=>2, 'c'=>3)`

There are some useful methods to work with dictionaries:

* Add pairs to the dictionary: `mydict[akey] = avalue`
* Add pairs using maps \(i.e. from vector of keys and vector of values to dictionary\): `map((i,j) -> mydict[i]=j, [1,2,3], [10,20,30])`
* Look up values: `mydict['a']` \(it raises an error if looked-up value doesn't exist\)
* Look up value with a default value for non-existing key: `get(mydict,'a',0)`
* Get all keys: `keys(mydict)` \(the result is an iterator, not an Array. Use `collect()` to transform it.\)
* Get all values: `values(mydict)` \(result is again an iterator\)
* Check if a key exists: `haskey(mydict, 'a')`
* Check if a given key/value pair exists \(that is, if the key exists and has that specific value\): `in(('a' => 1), mydict)`

You can iterate through both the key and the values of a dictionary at the same time:

```text
for (k,v) in mydict
   println("$k is $v")
end
```

While named tuples and dictionaries can look similar, there are some important difference between them:

* NamedTuples are immutable while Dictionaries are mutable
* Dictionaries are type unstable if different type of values are stored, while NamedTuples remain type-stable:
  * `d = Dict(:k1=>"v1", :k2=>2)  # Dict{Symbol,Any}` 
  * `nt = (k1="v1", k2=2,) # NamedTuple{(:k1, :k2),Tuple{String,Int64}}`
* The syntax is a bit less verbose and readable with NamedTuples: `nt.k1` vs `d[:k1]` 

Overall, NamedTuple are generally more efficient and should be thought more as anonymous `struct` \(see the "Custom structure" section\) than Dictionaries.

## Sets

Use sets to represent collections of unordered, unique values.

Some methods:

* Empty \(zero-elements\) set: `a = Set()`
* Initialize a set with values: `a = Set([1,2,2,3,4])`
* Set intersection, union, and difference: `intersect(set1,set2)`, `union(set1,set2)`, `setdiff(set1,set2)`

## Memory and copy issues

In order to avoid unnecessarily copying large amounts of data, Julia by default copies only the memory address of large objects, unless the programmer explicitly request a so-called "deep" copy. In detail:

**Equal sign \(a=b\)**

* "simple" types \(e.g. `Float64, Int64,` but also `String`\) are deep copied
* containers of simple types \(or other containers\) are shadow copied \(their internal is only referenced, not copied\)

**copy\(x\)**

* simple types are deep copied
* containers of simple types are deep copied
* containers of containers: the content is shadow copied \(the content of the content is only referenced, not copied\)

**deepcopy\(x\)**

* everything is deep copied recursively

You can check if two objects have the same values with `==` and if two objects are actually the same with `===` \(in the sense that immutable objects are checked at the bit level and mutable objects are checked for their memory address\):

* given `a = [1, 2]; b = [1, 2];`, `a == b` and `a === a` are true, but `a === b` is false;
* given `a = (1, 2); b = (1, 2);`,  all `a == b, a === a` and`a === b`are true.

## Various notes on Data types

While boolean values `true` and `false` are evaluated to `1` and `0` respectively, the opposite is not true. So, `if 0 [...] end` brings a _non-boolean \(Int64\) used in boolean context_ `TypeError`.

Attention to the keyword `const`. When applied to a variable \(e.g. `const x = 5`\) doesn't mean that the variable can't change value \(as in C\), but simply that it can not change type. Only global variables can be declared constant.

To convert \("cast"\) between types, use `convertedObj = convert(T,x)`. Still, when conversion is not possible, e.g. trying to convert a 6.4 Float64 in a Int64 value, an error, will be risen \(`InexactError` in this case\).

To convert strings \(representing numbers\) to integers or floats use `myInt = parse(Int,"2017")`.

For the opposite (to convert integers or floats to strings), use `myString = string(123)`.

You can "broadcast" a function to work over an Array \(instead of a scalar\) using the dot \(`.`\) operator.  
For example, to broadcast `parse` to work over an array use:`myNewList = parse.(Float64,["1.1","1.2"])` \(see also Broadcast in the "Functions" Section\)

Variable names have to start with a letter, as if they start with a number there is ambiguity if the initial number is a multiplier or not, e.g. in the expression `6ax` the variable `ax` is multiplied by 6, and it is equal to `6 * ax` \(and note that `6 ax` would result in a compile error\). Conversely, `ax6` would be a variable named `ax6` and not `ax * 6`.

You can import data from a file to a matrix using `readdlm()` \(in standard library package  `DelimitedFiles`\). You can skip rows and/or columns using the slice operator and then convert to the desidered type, e.g.

`myData = convert(Array{Float64,2},readdlm(myinputfile,'\t')[2:end,4:end]); # skip the first 1 row and the first 3 columns`

### Random numbers

* Random float in \[0,1\]: `rand()`
* Random integer in \[a,b\]: `rand(a:b)`
* Random float in \[a,b\] with "precision" to the second digit : `rand(a:0.01:b)` 

  This last can be executed faster and more elegantly using the `Distribution` package:

  ```text
  using Pkg; Pkg.add("Distributions")
  import Distributions: Uniform 
  rand(Uniform(a,b))
  ```

You can obtain an Array or a Matrix of random numbers simply specifying the requested size to rand\(\), e.g. `rand(2,3)`or `rand(Uniform(a,b),2,3)` for a 2x3 Matrix.

### Missing, nothing and NaN

Julia supports different concepts of missingness:

* **`nothing`** \(type `Nothing`\): is the value returned by code blocks and functions which do not return anything. It is a single instance of the singleton type `Nothing`, and the closer to C style NULL \(sometimes it is referred as to the "software engineer’s null"\). Most operations with `nothing` values will result in a run-type error. In some contexts it is printed as `#NULL`;
* **`missing`** \(type `Missing`\): represents a missing value in a statistical sense: there should be a value but we don't know which is \(so it is sometimes referred to as the "data scientist’s null"\). Most operations with missing values will result in missing propagate \(silently\). Containers can handle missing values efficiently when declared of type `Union{T,Missing}`. The [Missing.jl](https://github.com/JuliaData/Missings.jl) package provides additional methods to handle missing elements;
* **`NaN`** \(type `Float64`\):  represents when an operation results in a Not-a-Number value \(e.g. 0/0\). It is similar to `missing` in the fact that it propagates silently. Similarly, Julia also offers `Inf` \(e.g. `1/0`\) and `-Inf` \(e.g. `-1/0`\).

[¹](data-types.md): Technically a `String` is an array in Julia \(try to append a String to an array!\), but for most uses it can be thought as a scalar type.

_While an updated, expanded and revised version of this chapter is available in "Chapter 2 - Data Types and Structures" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
