# 8 - Interfacing Julia with other languages

Julia can natively call [C and Fortran libraries](http://docs.julialang.org/en/stable/manual/calling-c-and-fortran-code/) and, through packages, [C++](https://github.com/JuliaInterop/CxxWrap.jl), R ([1](https://github.com/JuliaInterop/RCall.jl),[2](https://github.com/lgautier/Rif.jl)) and [Python](https://github.com/JuliaPy/PyCall.jl).  
This allows Julia to use the huge number of libraries of these more established languages.

## C

mylib.h:

```text
#ifndef _MYLIB_H_
#define _MYLIB_H_

extern float iplustwo (float i);
extern float getTen ();
```

mylib.c:

```text
float
iplustwo (float i){
 return i+2;
}
```

Compiled with:

* `gcc -o mylib.o -c mylib.c`
* `gcc -shared -o libmylib.so mylib.o -lm -fPIC`

Use in julia with:

```julia
i = 2
const mylib = joinpath(@__DIR__, "libmylib.so")
j = ccall((:iplustwo, mylib), Float32, (Float32,), i)
```

## Python

### Use Python in Julia

We show here an example with Python. The following code converts an ODS spreadsheet in a Julia DataFrame, using the Python [ezodf](https://github.com/T0ha/ezodf) module (of course this have to be already be available in the local installation of python):

```julia
using PyCall
using DataFrames

const ez = pyimport("ezodf")  # Equiv. of Python `import ezodf as ez`
destDoc = ez.newdoc(doctype="ods", filename="anOdsSheet.ods")
sheet = ez.Sheet("Sheet1", size=(10, 10))
destDoc.sheets.append(sheet)
dcell1 = get(sheet,(2,3)) # Equiv. of Python `dcell1 = sheet[(2,3)]`. This is cell "D3" !
dcell1.set_value("Hello")
get(sheet,"A9").set_value(10.5) # Equiv. of Python `sheet['A9'].set_value(10.5)`
destDoc.backup = false
destDoc.save()
```

The first thing, is to declare we are using PyCall and to `@pyimport` the python module we want to work with. We can then directly call its functions with the usual Python syntax `module.function()`.

Type conversions are automatically performed for numeric, boolean, string, IO stream, date/period, and function types, along with tuples, arrays/lists, and dictionaries of these types.

Other types are instead converted to the generic PyObject type, as it is the case for the `destDoc` object returned by the module function.  
You can then access its attributes and methods with `myPyObject.attibute` and `myPyObject.method()` respectively.

### Use Julia in Python

The other way around, embedding Julia code in a Python script or terminal, is equally of interest, as it allows in many cases to benefit of substantial performance gains for Python programmers, and it may be easier than embedding C or C++ code.

We show here how to achieve it using the [PyJulia](https://github.com/JuliaPy/pyjulia) Python package, a Python interface to Julia, with the warning that, at time of writing, it is not as polished, simple and stable solution as PyCall, the Julia interface to Python.


#### Installation

Before installing `PyJulia`, be sure that the `PyCall` module is installed in Julia and that it is using the same Python version as the one from which you want to embed the Julia code (eventually, run `ENV["PYTHON"]="/path/to/python"; using Pkg; Pkg.build("PyCall");` from Julia to change its underlying Python interpreter).

At the moment only the `pip` package manager is supported in Python to install the `PyJulia` package (`conda` support should come soon).
Please notice that the name of the package in `pip` is `julia`, not `PyJulia`:

```Python
$ python3 -m pip install --user julia
>>> import julia
>>> julia.install()
```

If we have multiple Julia versions, we can specify the one to use in Python passing `julia="/path/to/julia/binary/executable"` (e.g. `julia = "/home/myUser/lib/julia-1.1.0/bin/julia"`) to the `install()` function.

#### Usage

To obtain an interface to Julia just run:

```Python
>>> import julia;
>>> jl = julia.Julia(compiled_modules=False)
```

The `compiled_module=False` in the Julia constructor is a workaround to the common situation when the Python interpreter is statically linked to `libpython`, but it will slow down interactive experience, as it will disable Julia packages pre-compilation, and every time we will use a module for the first time, this will need to be compiled first.
Other, more efficient but also more complicate, workarounds are given in the package documentation, under the [Troubleshooting section](https://pyjulia.readthedocs.io/en/stable/troubleshooting.html).

We can now access Julia in multiple ways.

We may want for example define all our functions in a Julia script and "include" it.
Let's assume `juliaScript.jl` is made of the following Julia code:

```julia
function helloWorld()
    println("Hello World!")
end
function sumMyArgs(i, j)
  return i+j
end
function getNElement(n)
  a = [0,1,2,3,4,5,6,7,8,9]
  return a[n]
end
```

We can access its functions in Python with:

```python
>>>> jl.include("juliaScript.jl")
>>>> jl.helloWorld() # Prints `Hello World!``
>>>> a = jl.sumMyArgs([1,2,3],[4,5,6]) # Returns `array([5, 7, 9], dtype=int64)``
>>>> b = jl.getNElement(1) # Returns `0`, the "first" element for Julia
```

As in calling Python from Julia, also here we can pass to the functions and retrieve complex data types without warring too much about the conversion. Note that now we get _the Julia way_ on indexing (1-based).

We can otherwise embed Julia code directly in Python using the Julia `eval()` function:

```python
>>> jl.eval("""
... function funnyProd(is, js)
...   prod = 0
...   for i in 1:is
...     for j in 1:js
...       prod += 1
...     end
...   end
...   return prod
... end
... """)
```

We can then call the above function in Python as `jl.funnyProd(2,3)`.

What if, instead, we want to run the function in broadcasted mode, i.e.  applying the function for each elements of a given array ? In Julia we could use the dot notation, e.g. `funnyProd.([2,3],[4,5])` (this would apply the `funnyProd()` function first to the `(2,4)` arguments and then to the `(3,5)` ones and collecting the two results in the array `[8,15]`). The problem is that this would not be valid Python syntax. +
In cases like this one, when we can't simply call a Julia function using Python syntax, we can still rely to the same Julia `eval` function we used to _define_ the Python function to also _call_ it: `jl.eval("funnyProd.([2,3],[4,5])")`

Finally, we can access any module available in Julia with `from julia import ModuleName`, and in particular we can set and access global Julia variables using the `Main` module.

## R

### Use Julia in R

To embed Julia code within a R workflow, we can use the R package [JuliaCall](https://github.com/Non-Contradiction/JuliaCall).

#### Installation

Install the Julia binaries for your OS from [JuliaLang](https://julialang.org/). Then, in R:

```R
> install.packages("JuliaCall")
```

That's all.

#### Usage

````
> library(JuliaCall)
> julia_setup()
````

Note that, differently than `PyJulia`, the "setup" function need to be called every time we start a new R section, not just when we install the `JuliaCall` package.
If we don't have `julia` in the path of our system, or if we have multiple versions and we want to specify the one to work with, we can pass the `JULIA_HOME = "/path/to/julia/binary/executable/directory"` (e.g. `JULIA_HOME = "/home/myUser/lib/julia-1.1.0/bin"`) parameter to the `julia_setup` call.

`JuliaCall` depends for some things (like object conversion between Julia and R) from the Julia `RCall` package. If we don't already have it installed in Julia, it will try to install it automatically.

As expected, also `JuliaCall` offers multiple ways to access Julia in R.

Let's assume we have all our Julia functions in a file. We are going to reuse the `juliaScript.jl` script we used in `PyJulia`:

```julia
function helloWorld()
    println("Hello World!")
end
function sumMyArgs(i, j)
  return i+j
end
function getNElement(n)
  a = [0,1,2,3,4,5,6,7,8,9]
  return a[n]
end
```

we can access its functions in R with:

```R
> julia_source("juliaScript.jl") # Include the file
> julia_eval("helloWorld()") # Prints `Hello World!` and returns NULL
> a <- julia_call("sumMyArgs",c(1,2,3),c(4,5,6)) # Returns `[1] 5 7 9`
> as.integer(1) %>J% getNElement -> b  # Returns `0`, the "first" element for both Julia and R
```

Concerning the last example, it highlights the usage of the `pipe` operator that is very common in R.
The `%>J%` syntax is a special "version" of it, provided by `JuliaCall`, allowing to mix Julia functions in a left-to-right data transformation workflow.

We can otherwise embed Julia code directly in R using the `julia_eval()` function:
```
> funnyProdR <- julia_eval('
+   function funnyProd(is, js)
+     prod = 0
+       for i in 1:is
+         for j in 1:js
+           prod += 1
+         end
+       end
+       return prod
+     end
+ ')
```

We can then call the above function in R either as `funnyProdR(2,3)`, `julia_eval("funnyProd(2,3)")` or `julia_call("funnyProd",2,3)`.

While other "convenience" functions are provided by the package, using `julia_eval` and `julia_call` should suffix to accomplish any task we may need in Julia.


_While an updated, expanded and revised version of this chapter is available in "Chapter 7 - Interfacing Julia with Other Languages" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
