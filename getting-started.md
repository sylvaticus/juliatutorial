# Getting started

## Why Julia
Without going into long discussions, Julia (partially thankful for the recent development in _just-in-time_ compliers) solves a trade-off that has long existed in programming: fast coding vs fast execution.  
On one side, Julia allows to code in a dynamic language like Python,  R or Matlab, allowing interaction with the code and powerful expressivity (see the [Metaprogramming](metaprogramming.md) chapter for example). 
On the other side, with minimum efforts (see [Performances](performances.md)), programs written in Julia can run as fast as C.  
While still young, Julia allows to easily interface your code with all the mayor programming languages (see [Interfacing Julia with other languages](interfacing-julia-with-other-languages.md)), hence reusing their huge set of libraries (when these are not already being ported in Julia).  
Julia has its roots in the domain of scientific, high performances programming, but is becoming more and more mature as a general purpose programming language.

## Install Julia
All you need to run the code in this tutorial is a working Julia interpreter console (aka REPL - Read Eval Print Loop).
In a recent version of Linux you can simply use your package manager to install `julia`.

For more up-to-date version, or for Windows/Mac packages, download the binaries available on the [download section](http://julialang.org/downloads/) of the [Julia web-site](http://julialang.org).

For Integrated Development Editor, checkout either [Juno](http://junolab.org/)  or IJulia, the Julia [Jupiter](http://jupyter.org/) backend.  
Here you can find their detailed setup instructions:
* [Juno](https://github.com/JunoLab/uber-juno/blob/master/setup.md)
* [IJulia](https://github.com/JuliaLang/IJulia.jl) (in a nutshell: if you already have Jupiter installed, just run `Pkg.add("IJulia")` from the Julia console. That's all! ;-) )


## Run Julia

There are several ways to run Julia code:

1. Julia can be run interactively in a console.
Just run (after having installed it) `julia` in a console and then type your commands there (and type `exit()` when you have finished);
2. Alternatively, create a script, that is a text file ending in `.jl`, and let Julia parse and run it with `julia myscript.jl [arg1, arg2,..]`;
3. Script files can be run also from within the Julia console, just type `include("myscript.jl")`;
4. In Linux, you could instead add at the top of the script the location of the Julia interpreter on your system, preceded by `#!` and followed by an empty row , e.g. `#!/usr/bin/julia` (you can find the full path of the Julia interpreter by typing `which julia` in a console). Be sure that the file is executable (e.g. `chmod 755 myscript.jl`). Then you can run the script with `./myscript.jl`;
5. Use an Integrated Development Editor (such as [Juno](include("test_script.jl") or [Jupiter](http://jupyter.org/)), open your Julia script and use the run command of the editor.

Julia keeps many things in memory within the same work session. If this create problems in the execution of your code, you can empty the current session for all the variables using `workspace()`.

Sometimes that is not enought, and restarting Julia is the only way to get a clean status.

## Syntax elements

Single line comments start with `#` and multi-line comments can be placed in between `#=` and `=#`(and can be nested).

In console mode `;` after a command suppresses the output (this is done automatically in scripting mode), and typed alone switches to one-time command shell prompt. 

Indentation doesn't matter, but empty spaces sometimes do, e.g. functions must have the curved parenthesis with the inputs strictly attached to them, e.g.:

```
print (x)  ERROR  
print(x)   OK
```

If you come from C or Python, One important thing to remember is that Julia is one-based indexing (arrays start counting from `1` and not `0`).

## Packages

Many functions are provided in Julia by external packages.

To automatically download, compile and install a package run from a Julia console (only once) `Pkg.add("mypackage")`.  
But before you do that, run `Pkg.update()` to be sure that (a) your local index of packages and (b) the version of local packages is up to date.
Use `Pkg.status()` to check the current version of your local packages.

To use the functions provided by a package, just include a `using mypackage` statement in the console or at the beginning of the script. If you prefer to import the package but keep the namespace clean, use `import mypackage`.  You can also include other files, without changing the current namespace, using `include("MyFile.jl")`.

`Winston` or `Plots` (plotting) and `DataFrames` (R-like tabular data) are example of packages that you will pretty surely want to consider.


For example (see the [Plotting](plotting.md) section for specific Plotting issues):
```
using Plots
pyplot()
plot(rand(4,4))
```
**or**
```
import Plots
Plots.pyplot()
Plots.plot(rand(4,4))
```
**or**
```
import Plots: pyplot, plot
pyplot()
plot(rand(4,4))
```

If you are interested in writing your own package, you can read more about packages in the [relevant section](http://docs.julialang.org/en/release-0.5/manual/packages/) of the Julia documentation.  



 
### Documentation and debugging

Tipyng `?` in the console leads you to the Julia help system where you can search for function's API (in non-interactive environment you can use `?search_term` instead).

Here you can find some common operations concerning introspection and debugging:

* Retrieve function signatures: `method (myfunction)`
* Retrieve object properties: `fieldnames(myobject)`
* Discover which specific method is used (within the several available, as Julia supports multiple-dispatch aka polymorfism): `@which myfunction(myargs)`
* Discover which type (loosely a "class" in OO languages) an object instance is: `typeof(a)`
* Discover which fields are part of an object: `fieldnames(myobj)`
* Get more information about an object: `dump(myobj)`
* Profile a specific part of code: `@time myCode`

It is a good practice to document your own functions. You can use triple quoted strings (""") just before the function to document and use Markdown syntax in it. The Julia documentation [recommends](http://docs.julialang.org/en/release-0.5/manual/documentation/) that you insert a simplified version of the function, together with an `Arguments` and an `Examples` sessions.  
For example, this is the documentation string of the `ods_reall` function within the `OdsIO` package: 

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
```julia
julia> outDic  = ods_readall("spreadsheet.ods";sheetsPos=[1,3],ranges=[((1,1),(3,3)),((2,2),(6,4))], innerType="Dict")
Dict{Any,Any} with 2 entries:
  3 => Dict{Any,Any}(Pair{Any,Any}("c",Any[33.0,43.0,53.0,63.0]),Pair{Any,Any}("b",Any[32.0,42.0,52.0,62.0]),Pair{Any,Any}("d",Any[34.0,44.0,54.…
  1 => Dict{Any,Any}(Pair{Any,Any}("c",Any[23.0,33.0]),Pair{Any,Any}("b",Any[22.0,32.0]),Pair{Any,Any}("a",Any[21.0,31.0]))
```
"""


