# 6 - Input - Output

## File reading/writing

File reading/writing is similar to other languages where you first `open` the file, specify the modality \(`r` read, `w` write or `a` append\) and bind the file to an object, and finally operate on this object and `close()` it when you are done.

A better alternative is however to encapsulate the file operations in a `do` block that closes the file automatically when the block ends:

Write:

```julia
open("afile.txt", "w") do f  # "w" for writing
  write(f, "test\n")         # \n for newline
end
```

Read the whole file in a single operation:

```julia
open("afile.txt", "r") do f   # "r" for reading
  filecontent = read(f,String) # attention that it can be used only once. The second time, without reopening the file, read() would return an empty string
  print(filecontent)
end
```

or, reading line by line:

```julia
open("afile.txt", "r") do f
  for ln in eachline(f)
    println(ln)
  end
end
```

or, if you want to keep track of the line numbers:

```julia
open("afile.txt", "r") do f
   for (i,ln) in enumerate(eachline(f))
     println("$i $ln")
   end
end
```

## Other IO

Some packages that deals with IO are:

* CSV: [CSV.jl](https://github.com/JuliaData/CSV.jl)
* Web stream: [HTTP.jl](https://github.com/JuliaWeb/HTTP.jl)
* Spreadsheets \(OpenDocument\): [OdsIO.jl](https://github.com/sylvaticus/OdsIO.jl)
* HDF5: [HDF5.jl](https://github.com/JuliaIO/HDF5.jl)

Some basic examples that use them are available in the [DataFrame](../useful-packages/dataframes.md) section.

_While an updated, expanded and revised version of this chapter is available in "Chapter 5 - Input/Output" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
