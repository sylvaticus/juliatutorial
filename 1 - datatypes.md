# Datatypes #

## Scalar variables ##
An unusual feature of Julia is that it allows variable names to include a subset of Unicode symbols, allowing a variable to be represented e.g. by a greek letter.

In most Julia development environments (including the console), to input in the script the greek letter you can use a LaTeX-like syntax, typing `\` and then the LaTeX name for the symbol, e.g. `\alpha` for α.
Using LaTeX syntax, you can also add subscripts, superscripts and decorators.

The main types of scalar you will use are `Int64`, `Float64`, `Char` (e.g. `x = 'a';`), `String` (e.g. `x="abc";`) and `Bool`.
The default if you do not specify is `Float64`.

## Arrays (lists) ##
Empty (zero-elements) arrays: `a = []` (or `a = Int64[]`)
5-elements zeros array:`a=zeros(5)` (or `a=zeros(Int64,5)`) (same with ones)

Column vector ('Vector' container) : `a = [1;2;3]`
Row vector ('Matrix' container) : `a = [1 2 3]`

Reference to an element of an array/vector/matrix: `a[1]` (you can use also the keyword `end`, but not `begin`)

Slice syntax [from:step:to] is generally supported.

Push an element to the end of a: `push!(a,b)`

To append the elements of b to a: `append!(a,b)`
(if b is a scalar obviously push! and append! are the same)

Remove an element from the end: `pop!(a)`

Add an element at the beginning (left): `unshift!(a,1)`

Removing an element at the beginning (left) : `shift!(a)`

Sorting: `sort!(a)` or `sort(a)` (depending if we want modify or not the original array)

Reversing an arry: `a[end:-1:1]`

Checking for existence: `in(1, a)`

Getting the length: `length(a)`

## Turples ##
Use turples to have a list of immutable elements: `a = (1,2,3)` or even without parenthesis `a = 1,2,3`


## Dictionaries ##


## Sets ##
Use Sets to represent collections of unordered, unique values

Empty (zero-elements) set: `a = Set()`

Initialize a set with values: `a = Set([1,2,2,3,4])`

Set intersection, union, and difference: `intersect(set1,set2)`, `union(set1,set2)`, `setdiff(set1,set2)`


