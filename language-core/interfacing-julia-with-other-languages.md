# 8 - Interfacing Julia with other languages

Julia can natively call [C and Fortran libraries](http://docs.julialang.org/en/stable/manual/calling-c-and-fortran-code/) and, through packages, [C++](https://github.com/JuliaInterop/CxxWrap.jl), R \([1](https://github.com/JuliaInterop/RCall.jl),[2](https://github.com/lgautier/Rif.jl)\) and [Python](https://github.com/JuliaPy/PyCall.jl).  
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

We show here an example with Python. The following code converts an ODS spreadsheet in a Julia DataFrame, using the Python [ezodf](https://github.com/T0ha/ezodf) module \(of course this have to be already be available in the local installation of python\):

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

_While an updated, expanded and revised version of this chapter is available in "Chapter 7 - Interfacing Julia with Other Languages" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
