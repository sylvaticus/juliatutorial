# Datatypes

## Scalar types

An unusual feature of Julia is that it allows variable names to include a subset of Unicode symbols, allowing a variable to be represented e.g. by a greek letter.

In most Julia development environments (including the console), to input in the script the greek letter you can use a LaTeX-like syntax, typing `\` and then the LaTeX name for the symbol, e.g. `\alpha` for `α`.
Using LaTeX syntax, you can also add subscripts, superscripts and decorators.

The main types of scalar you will use are `Int64`, `Float64`, `Char` (e.g. `x = 'a'`), `String` (e.g. `x="abc"`) and `Bool`.
The default if you do not specify is Float64. Attenction to use the single quote for chars and double quotes for strings.

Also, while boolean values `true` and `false` are evaluated to `1` and `0` respectively, the opposite is not true. So, ` if 0 [...] end` brings an error. 

## Strings

Typical string operations are supported:
`split(s)` _(default on whitespaces)_, `replace(s, "toSearch", "toReplace")` and `strip(s)` _(remove whitespaces)_

### Concatenation

There are several ways to concatenate strings:
* Concatenation operator: `*`;
* Function `string(str1,str2,str3)`;
* Combine string variables in a bigger one using the dollar symbol: `a = "$str1 is a string and $(myobject.int1) is an integer"` ("interpolation")

The first method doesn't authomatically cast integer and floats to strings.


## Arrays \(lists\)

Empty (zero-elements) arrays: `a = []` (or `a = Int64[]`)

5-elements zeros array: `a=zeros(5)` (or a=`zeros(Int64,5)`) (same with `ones()`)

Column vector (_Vector_ container, most common) : `a = [1;2;3]` or `a=[1,2,3]`

Row vector (_Matrix_ container, less common) : `a = [1 2 3]`

Reference to an element of an array/vector/matrix: `a[1]` (you can use also the keyword `end`, but not `begin`)

Arrays can be heterogeneus (but in this case the array will be of `Any` type and I guess much slower): `x = [10, "foo", false]`

Slice syntax `[from:step:to]` is generally supported and in several context it will return a (fast) iterator rather than a list.

To trasform an iterator in a list use `collect(myiterator)`.

Push an element to the end of a: `push!(a,b)`

To append the elements of b to a: `append!(a,b)`
(if b is a scalar obviously push! and append! are the same)

Remove an element from the end: `pop!(a)`

Add an element (b) at the beginning (left): `unshift!(a,b)`

Removing an element at the beginning (left) : `shift!(a)`

Sorting: `sort!(a)` or `sort(a)` (depending if we want modify or not the original array)

Reversing an arry: `a[end:-1:1]`

Checking for existence: `in(1, a)`

Getting the length: `length(a)`

### Multidimensional arrays
In Julia there exists also `Vector` and `Matrix`, but these are just aliasis for 1-D and 2-D arrays.

`a = [[1,2,3],[4,5,6]]` creates a 1-dimensional array with 2-elements (each of those is again a vector)

`a = [[1,2,3] [4,5,6]]` creates a 2-dimensional array (a matrix with 2 columns) with three elements (scalars). The number of elements of each column must be the same, but the elements can be an arrays too: `a = [[[1,2],[1,2]] [[4,5],[4,5]]]`.

`size(a)` returns a tuple with the size of the 1 or 2 dimensions

`ndim(a)` returns the number of dimensions of the array (either 1 or 2)

Arrays can be changed dimension with either `reshape(a, nElementsDim1, nElementsDim2)` or `squeeze(a, numDimensions)` or using the transpose `'` operator.

reshape and squeeze (bun not transpose) perform a shadow copy, returning just a differnet "view" of the underlying data.

A 2x3 matrix can be constructed in one of the following ways:

* `a = [[1,2] [3,4] [5,6]]`
* `a = Array(Int64, 2, 3)` (content is garbage)
* `a = zeros(2,3)` or `a = ones(2,3)`
* `a = fill("abc",2,3)` (content is "abc")

Elements of bidimensional arrays can be accessed with `a[row,col]` syntax.
Note: for row vectors both `a[2]` or `a[1,2]` returns the second element.

Sub-array or sub-matrices can be extracted using slice operator. Given `a` is a 3x3 Matrice, `a[1:2,:]` would return a 2x3 Matrix with all the column elements of the first and second row.








## Turples

Use turples to have a list of immutable elements: `a = (1,2,3)` or even without parenthesis `a = 1,2,3`

They can be easily unpacked to multiple variable:
`var1, var2 = (x,y)` (this is useful for e.g. collect the values of functions returning multiple values) 

## Dictionaries

Dictionaries store mappings from keys to values. They have an apparently random sorting.

Empty (zero-elements) dictionary: `mydict = Dict()`

Initialize a dictionary with values: `mydict = Dict('a'=>1, 'b'=>2, 'c'=>3)`

Look up values: `mydict['a']` (it raises an error if looked-up value doesn't exist)

Look up value with a default value for non-existing key: `get(mydict,'a',0)`

Get all keys: `keys(mydict)` (the result is an iterator, not a list)
Get all values: `values(mydict)` (result is again an iterator)

Check if a key exists: `haskey(mydict, 'a')`

Check if a given key/value pair exists (that it, if the key exists and has that specific value): `in(('a' => 1), mydict)`

Iterate trough a dictionary:

```
for (k,v) in mydict
   println("$k is $v")
end
```

## Sets

Use Sets to represent collections of unordered, unique values

Empty (zero-elements) set: `a = Set()`

Initialize a set with values: `a = Set([1,2,2,3,4])`

Set intersection, union, and difference: `intersect(set1,set2)`, `union(set1,set2)`, `setdiff(set1,set2)`

