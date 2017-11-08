# Datatypes

## Scalar types

In Julia, variable names can include a subset of Unicode symbols, allowing a variable to be represented, for example, by a Greek letter.  
In most Julia development environments (including the console), to type the Greek letter you can use a LaTeX-like syntax, typing `\` and then the LaTeX name for the symbol, e.g. `\alpha` for `α`.
Using LaTeX syntax, you can also add subscripts, superscripts and decorators.

The main types of scalar are `Int64`, `Float64`, `Char` (e.g. `x = 'a'`), `String`[¹](#myfootnote1) (e.g. `x="abc"`) and `Bool`.
The default, if you do not specify, is Float64 (but for DataFrames, at least columns with all NA values, seems to be Int64!)  

## Strings

Julia supports most typical string operations, for example:
`split(s)` _(default on whitespaces)_, `join([s], "")`, `replace(s, "toSearch", "toReplace")` and `strip(s)` _(remove leading and trailing whitespaces)_ 
Attention to use the single quote for chars and double quotes for strings.


### Concatenation

There are several ways to concatenate strings:
* Concatenation operator: `*`;
* Function `string(str1,str2,str3)`;
* Combine string variables in a bigger one using the dollar symbol: `a = "$str1 is a string and $(myobject.int1) is an integer"` ("interpolation")

Note: the first method doesn't automatically cast integer and floats to strings.


## Arrays (lists)

Arrays are N-dimensional mutable containers. In this section, we deal with 1-dimensional arrays, in the next one we consider2 or more dimensional arrays. 

There are several ways to create an array:

* Empty (zero-elements) arrays: `a = []`. Alternative ways:
  * `a = T[]`, e.g. `a = Int64[]`;
  * using explictitly the contructor `a = Array{T,1}()`;
  * using the `Vector` alias: `c = Vector{T}()`;
* 5-elements zeros array: `a=zeros(5)` (or a=`zeros(Int64,5)`) (same with `ones()`)
* Column vector (_Vector_ container, alias for 1-dimensions array) : `a = [1;2;3]` or `a=[1,2,3]`
* Row vector (_Matrix_ container, alias for 2-dimensions array, see next section "Multidimensional and nested arrays
"): `a = [1 2 3]`

Arrays can be heterogeneous (but in this case the array will be of `Any` type and in general much slower): `x = [10, "foo", false]`

`a = Int64[]` is just a shortland for `a = Array{Int64,1}()` (e.g. `a = Any[1,1.5,2.5]` is equivalent to `a = Array{Any,1}([1,1.5,2.5])`).
Attenction that `a = Array{Int64,1}` doesn't create an Array at all, but just assign the "DataType" `Array{Int64,1}` to `a`.
You can also declare an array of size _n_ (with garbage content) with `a=Array{T,1}(n)`.

Square brackets are used to access the elements of an array  (e.g. `a[1]`). The slice syntax `[from:step:to]` is generally supported and in several contexts will return a (fast) iterator rather than a list (you can use the keyword `end`, but not `begin`). To then transform the iterator in a list use `collect(myiterator)`. 
You can initialisate an array with a mix of values and ranges with either `y=[2015; 2025:2030; 2100]` (note the semicolon) or `y=vcat(2015, 2025:2030, 2100)`.

The following methods are useful while working with arrays:

* Push an element to the end of a: `push!(a,b)` (as a single element even if it is an Array. Equivalent to python `append`)
* To append all the elements of b to a: `append!(a,b)` (if b is a scalar obviously push! and append! are the same. Attention that a string is treated as a list!. Equivalent to Python `extend` or `+=`)
* Concatenation of arrays (new array): `a = [1,2,3]; b = [4,5]; c = cat(1,a,b)`
* Remove an element from the end: `pop!(a)`
* Removing an element at the beginning (left) : `shift!(a)`
* Remove an element at an arbitrary position: `deleteat!(a, pos)`
* Add an element (b) at the beginning (left): `unshift!(a,b)`
* Sorting: `sort!(a)` or `sort(a)` (depending on whether we want to modify or not the original array)
* Reversing an arry: `a[end:-1:1]`
* Checking for existence: `in(1, a)`
* Getting the length: `length(a)`
* Get the maximum value: `maximum(a)` or  `max(a...)` (`max` returns the maximum value between the given arguments)
* Empty an array: `empty!(a)`
* Random-shuffling the elements: `shuffle(a)` (or `shuffle!(a)`)
* Checking if an array is empty: `isempty(a)`
* Find the index of a value in an array: `find(x -> x == value, myarray)`. This is a bit tricky.  The first argument is an anonymous function that returns a boolean value for each value of `myarray`, and then `find()` returns the index position(s).
* Delete a given item from a list: `deleteat!(myarray, find(x -> x == myunwanteditem, myarray))`

### Multidimensional and nested arrays
In Julia, an array can have 1 dimension (a column, also known as `Vector`), 2 dimensions (that is, a `Matrix`) or more.
Then each element of the Vector or Matrix can be a scalar, a vector or an other Matrix.  
The main difference between a `Matrix` and an _array of array_ is that in the former the number of elements on each column (row) must be the same and rules of linear algebra applies.

There are two ways to create a Matrix:
* `a = [[1,2,3] [4,5,6]]`  [[elements of the first column] [elements of the second column] ...]
* `a = [1 4; 2 5; 3 6]`    [elements of the first row; elements of the second row; ...]

Attention to this difference:
* `a = [[1,2,3],[4,5,6]]` creates a 1-dimensional array with 2-elements (each of those is again a vector);
* `a = [[1,2,3] [4,5,6]]` creates a 2-dimensional array (a matrix with 2 columns) with three elements (scalars).

An empty Matrix can be constructed in one of the following ways:
* a = Array{T,2}()
* a = Matrix{T}()  # just a name alias to Array{T,2}

A 2x3 matrix can be constructed in one of the following ways:
* `a = [[1,2] [3,4] [5,6]]`
* `a = Array(Int64, 2, 3)`  (content is garbage, **DEPRECATED**)
* `a = Array{Int64}(2, 3)`  (content is garbage)
* `a = Array{Int64,2}(2,3)` (content is garbage)
  (note that `a = Array{Int64,2}(2,3,4)` would result in an error, as you are specifing 3 sizes for a 2-dimensional array)
* `a = zeros(2,3)` or `a = ones(2,3)`
* `a = fill("abc",2,3)` (content is "abc")

Nested arrays can be accessed with double square brackets, e.g. `a[2][3]`.  
Elements of bidimensional arrays can be accessed instead with the `a[row,col]` syntax, where again the slice syntax can be used, for example, given `a` is a 3x3 Matrix, `a[1:2,:]` would return a 2x3 Matrix with all the column elements of the first and second row.

Boolean selection is implemented using a boolean array/matrix for the selection:
```
a = [[1,2,3] [4,5,6]]
mask = [[true,true,false] [false,true,false]]
```
`a[mask]` returns an 1-D array with 1, 2 and 5. Note that boolean selection results always in a flatted array, even if delete a whole row or a whole column of the original data. It is up to the programmer to then reshape the data accordingly.

Note: for row vectors, both `a[2]` or `a[1,2]` returns the second element.\\

n-D arrays support several methods:

* `size(a)` returns a tuple with the sizes of the _n_ dimensions
* `ndim(a)` returns the number of dimensions of the array (e.g. 2 for a Matrix)
* Arrays can be changed dimension with either `reshape(a, nElementsDim1, nElementsDim2)` or `squeeze(a, numDimensions)` or using the transpose `'` operator.

`reshape` and `squeeze` (bun not transpose) perform a shadow copy, returning just a different "view" of the underlying data.

`AbstractVector{T}` is just an alias to `AbstractArray{T,1}`, as `AbstractMatrix{T}` is just an alias to `AbstractArray{T,2}`.

Multidimensional Arrays can arice for example from using list comprehension: `a = [3x + 2y + z for x in 1:2, y in 2:3, z in 1:2]`

For further operations on arrays and matrices have a look at the [QuantEcon tutorial](http://lectures.quantecon.org/jl/julia_arrays.html#operations-on-arrays).


## Tuples

Use tuples to have a list of immutable elements: `a = (1,2,3)` or even without parenthesis `a = 1,2,3`

Tuples can be easily unpacked to multiple variable: `var1, var2 = (x,y)` (this is useful, for example, to collect the values of functions returning multiple values) 

Useful tricks:
* Convert a tuple in a vector: `a=(1,2,3); v = [a...]` or `v = [i[1] for i in a]`
* Convert an array in tuple: `a = (v...)`

## Dictionaries

Dictionaries store mappings from keys to values, and they have an apparently random sorting.

You can create an empty (zero-elements) dictionary with `mydict = Dict()`, or initialize a dictionary with values: `mydict = Dict('a'=>1, 'b'=>2, 'c'=>3)`

There are some useful methods to work with dictionaries:
* Add pairs to the dictionary: `mydict[akey] = avalue`
* Add pairs using maps: `map((i,j) -> mydict[i]=j, [1,2,3], [10,20,30])`
* Look up values: `mydict['a']` (it raises an error if looked-up value doesn't exist)
* Look up value with a default value for non-existing key: `get(mydict,'a',0)`
* Get all keys: `keys(mydict)` (the result is an iterator, not a list)
* Get all values: `values(mydict)` (result is again an iterator)
* Check if a key exists: `haskey(mydict, 'a')`
* Check if a given key/value pair exists (that it, if the key exists and has that specific value): `in(('a' => 1), mydict)`

You can iterate trough both the key and the values of a dictionary at the same time:

```
for (k,v) in mydict
   println("$k is $v")
end
```

## Sets

Use sets to represent collections of unordered, unique values.

Some methods:
* Empty (zero-elements) set: `a = Set()`
* Initialize a set with values: `a = Set([1,2,2,3,4])`
* Set intersection, union, and difference: `intersect(set1,set2)`, `union(set1,set2)`, `setdiff(set1,set2)`

## Memory and copy issues
In order to unnecessarily copying large amount of data, Julia by default copy only the memory address of large objects, unless the programmer explicitly request a so-called "deep" copy. In detail:

**Equal sign (a=b)**

* simple types are deep copied
* containers of simple types (or other containers) are shadow copied (their internal is only referenced, not copied)

**copy(x)**

* simple types are deep copied
* containers of simple types are deep copied
* containers of containers: the content is shadow copied (the content of the content is only referenced, not copied)

**deepcopy(x)**

* everything is deep copied recursively

You can check if two objects have the same value with `==` and if two objects are actually the same with `===` (in the sense that immutable objects are checked at the bit level and mutable objects are checked for their memory address):  given `a = [1, 2]; b = [1, 2];`, `a == b` and `a === a` are true, but `a === b` is false.


## Various notes on Data types

While boolean values `true` and `false` are evaluated to `1` and `0` respectively, the opposite is not true. So, ` if 0 [...] end` brings an error.

Attention to the keyword `const`. When applied to a variable (e.g. `const  x::Int64`) doesn't mean that the variable can't change value (as in C), but simply that it can not change type.
 
To convert ("cast") between types, use `convertedObj = convert(T,x)`. Still, when conversion is not possible, e.g. trying to convert a 6.4 Float64 in a Int64 value, an error, will be risen (`InexactError()` in this case).

To convert strings (representing numbers) to integers or floats use `myInt = parse(Int,"2017")`.

The opposite, to convert integers or floats to strings, use `myString = string(123)`.

You can broadcast `parse` to work over an array (or a df column) using `myNewList = parse.([Float64],["1.1","1.2"])` (from Julia version 0.6 the brackets arount `Float64` are no longer necessary).

Variable names have to start with a letter, as if they start by a number there is ambiguity if the initial number is a multiplier or not, e.g. in the expression `6ax` the variable `ax` is multiplied by 6, and it is equal to `6 * ax` (and note that `6 ax` would result in a compile error). Conversly, `ax6` would be a variable named `ax6` and not `ax * 6`.

### Random numbers
* Random float in [0,1]: `rand()`
* Random integer in [1,n]: `Int(floor(n* rand()) + 1)`

- - -

<a name="myfootnote1">¹</a>: Technically a `String` is an array in Julia (try to append a String to an array!), but for most uses it can be thought as a scalar type.
