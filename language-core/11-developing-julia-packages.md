# 11 - Developing Julia packages

Patching other people packages:

* pkg&gt;  `develop pkgName`
* \[patch & commit\]
* `using PkgDev; PkgDev.submit(pkgName)`

Develop your own project and publish a new version

* pkg&gt; `develop git@github.com:userName/pkgName.jl.git`to checkout master from GitHub
* \[...work on the project..\]
* `PkgDev.tag(pkg, v"0.X.X")`
* `PkgDev.publish(pkg)`

or \(much better\) use the package [Registrator](https://github.com/JuliaRegistries/Registrator.jl) that automatise the workflow \(after you installed Registrator on your GitHub repository, just create a new GitHub release in order to spread it to the Julia package ecosystem\).

* Testing a package: `Pkg.test("pkg")`

It is a good practice to document your own functions. You can use triple quoted strings \("""\) just before the function to document and use Markdown syntax in it. The Julia documentation [recommends](http://docs.julialang.org/en/stable/manual/documentation/) that you insert a simplified version of the function, together with an `Arguments` and an `Examples` sessions.  
For example, this is the documentation string of the `ods_readall` function within the `OdsIO` package:

```text
"""
    ods_readall(filename; <keyword arguments>)

Return a dictionary of tables|dictionaries|dataframes indexed by position or name in the original OpenDocument Spreadsheet (.ods) file.

# Arguments
* `sheetsNames=[]`: the list of sheet names from which to import data.
* `sheetsPos=[]`: the list of sheet positions (starting from 1) from which to import data.
* `ranges=[]`: a list of pair of touples defining the ranges in each sheet from which to import data, in the format ((tlr,trc),(brr,brc))
* `innerType="Matrix"`: the type of the inner container returned. Either "Matrix", "Dict" or "DataFrame"

# Notes
* sheetsNames and sheetsPos can not be given together
* ranges is defined using integer positions for both rows and columns
* individual dictionaries or dataframes are keyed by the values of the cells in the first row specified in the range, or first row if `range` is not given
* innerType="Matrix", differently from innerType="Dict", preserves original column order, it is faster and require less memory
* using innerType="DataFrame" also preserves original column order

# Examples
``julia
julia> outDic  = ods_readall("spreadsheet.ods";sheetsPos=[1,3],ranges=[((1,1),(3,3)),((2,2),(6,4))], innerType="Dict")
Dict{Any,Any} with 2 entries:
  3 => Dict{Any,Any}(Pair{Any,Any}("c",Any[33.0,43.0,53.0,63.0]),Pair{Any,Any}("b",Any[32.0,42.0,52.0,62.0]),Pair{Any,Any}("d",Any[34.0,44.0,54.…
  1 => Dict{Any,Any}(Pair{Any,Any}("c",Any[23.0,33.0]),Pair{Any,Any}("b",Any[22.0,32.0]),Pair{Any,Any}("a",Any[21.0,31.0]))
``
"""
```
