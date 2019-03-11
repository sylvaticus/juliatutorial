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
j = ccall((:iplustwo, "[MY FULL PATH]/libmylib.so"), Float32, (Float32,), i)
```

## Python

We show here an example with Python. The following code converts an ODS spreadsheet in a Julia DataFrame, using the Python [ezodf](https://github.com/T0ha/ezodf) module \(of course this have to be already be available in the local installation of python\):

```julia
using PyCall
using DataFrames

@pyimport ezodf
doc = ezodf.opendoc("test.ods")
nsheets = length(doc[:sheets])
println("Spreadsheet contains $nsheets sheet(s).")
for sheet in doc[:sheets]
    println("---------")
    println("   Sheet name : $(sheet[:name])")
    println("Size of Sheet : (rows=$(sheet[:nrows]()), cols=$(sheet[:ncols]()))")
end

# convert the first sheet to a DataFrame
sheet = doc[:sheets][1]
df_dict = Dict()
col_index = Dict()
for (i, row) in enumerate(sheet[:rows]())
  # row is a list of cells
  # assume the header is on the first row
  if i == 1
      # columns as lists in a dictionary
      [df_dict[cell[:value]] = [] for cell in row]
      # create index for the column headers
      [col_index[j]=cell[:value]  for (j, cell) in enumerate(row)]
      continue
  end
  for (j, cell) in enumerate(row)
      # use header instead of column index
      append!(df_dict[col_index[j]],cell[:value])
  end
end
# and convert to a DataFrame
df = DataFrame(df_dict)
```

The first thing, is to declare we are using PyCall and to `@pyimport` the python module we want to work with. We can then directly call its functions with the usual Python syntax `module.function()`.

Type conversions are automatically performed for numeric, boolean, string, IO stream, date/period, and function types, along with tuples, arrays/lists, and dictionaries of these types.

Other types are instead converted to the generic PyObject type, as it is the case for the `doc` object returned by the module function.  
You can then access its attributes and methods with `myPyObject[:attibute]` and `myPyObject[:method]()` respectively.

