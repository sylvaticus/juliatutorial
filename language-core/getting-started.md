# 1 - Getting started

## Why Julia

Without going into long discussions, Julia \(partially thankful for the recent development in _just-in-time_ compilers\) solves a trade-off that has long been existed in programming: _fast coding_ vs. _fast execution_.  
On one side, Julia allows to code in a dynamic language like Python, R or Matlab, allowing interaction with the code and powerful expressivity \(see the [Metaprogramming](metaprogramming.md) chapter for example\).  
On the other side, with minimum efforts \(see [Performances](performances.md)\), programs written in Julia can run \(almost\) as fast as C.  
While still young, Julia allows to easily interface your code with all the major programming languages \(see [Interfacing Julia with other languages](interfacing-julia-with-other-languages.md)\), hence reusing their huge set of libraries \(when these are not already being ported in Julia\).  
Julia has its roots in the domain of scientific, high performances programming, but it is becoming more and more mature as a general purpose programming language.

## Installing Julia

All you need to run the code in this tutorial is a working Julia interpreter console \(aka REPL - _Read Eval Print Loop_\).  
In a recent version of Linux you could simply use your package manager to install `julia` but for more up-to-date version, or for Windows/Mac packages, I strongly suggest to download the binaries available on the [download section](http://julialang.org/downloads/) of the [Julia web-site](http://julialang.org).

For Integrated Development Editor, checkout either [Juno](http://junolab.org/) or IJulia, the Julia [Jupiter](http://jupyter.org/) backend.  
Here you can find their detailed setup instructions:

* [Juno](https://github.com/JunoLab/uber-juno/blob/master/setup.md) \(an useful tip I always forget: the key binding for block selection mode is `ALT+SHIFT`\)
* [IJulia](https://github.com/JuliaLang/IJulia.jl) \(in a nutshell: if you already have Jupiter installed, just run `using Pkg; Pkg.update();Pkg.add("IJulia")` from the Julia console. That's all! ;-\) \)

You can also choose, at least to start with, _not_ to install Julia at all, and try instead [JuliaBox](https://juliabox.com/), a free online IJulia notebook server that you access from your browser.

## Running Julia

There are several ways to run Julia code:

1. Julia can be run interactively in a console.

   Just write \(after having installed it\) `julia` in a console and then type your commands there \(and type `exit()` when you have finished\);

2. Alternatively, create a script, that is a text file ending in `.jl`, and let Julia parse and run it with `julia myscript.jl [arg1, arg2,..]`;
3. Script files can also  be run from within the Julia console, just type `include("myscript.jl")`;
4. In Linux, you could instead add at the top of the script the location of the Julia interpreter on your system, preceded by `#!` and followed by an empty row , e.g. `#!/usr/bin/julia` \(you can find the full path of the Julia interpreter by typing `which julia` in a console\). Be sure that the file is executable \(e.g. `chmod 755 myscript.jl`\). Then you can run the script with `./myscript.jl`;
5. Use an Integrated Development Editor \(such as \[Juno\]\(include\("test\_script.jl"\) or [Jupiter](http://jupyter.org/)\), open your Julia script and use the run command of the editor.

Julia keeps many things in memory within the same work session. If this create problems in the execution of your code, you can restart Julia or use the [Revise.jl](https://github.com/timholy/Revise.jl) package for a finer control.

You can check which version of Julia you are using with `versioninfo().`

## Syntax elements

Single line comments start with `#` and multi-line comments can be placed in between `#=` and `=#`\(and can be nested\).

In console mode, `;` after a command suppresses the output \(this is done automatically in scripting mode\), and typed alone switches to one-time command shell prompt.

Indentation doesn't matter, but empty spaces sometimes do, e.g. functions must have the curved parenthesis with the inputs strictly attached to them, e.g.:

```text
println (x)  ERROR  
println(x)   OK
```

If you come from C or Python, one important thing to remember is that Julia is one-based indexing \(arrays start counting from `1` and not `0`\).

## Packages

Many functions are provided in Julia by external "packages". Also, many standard functionalities that were in core before Julia 1.0 has been moved to a separate standard library, shipped with Julia itself, but that requires the user to load the package explicitly.

For example, the same package functionality requires the user to type  `using Pkg` to access the  Pkg functionalities \(alternatively, only for the package module, you can type `]` to enter a "special" Pkg mode\).

You can then run the desired command, directly if you are in a terminal in the Pkg mode, or `pkg"cmd to run"` in a script \(notice that there is no space between `pkg` and the quoted command to run\). 

Some useful package commands:

1. `status` Retrieves a list with name and versions of locally installed packages
2. `update` Updates your local index of packages and all your local packages to the latest version
3. `add myPkg` Automatically downloads and installs a package
4. `rm myPkg` Removes a package and all its dependent packages that has been installed automatically only for it
5. `add pkgName#master`Checkouts the master branch of a package \(and `free pkgName` returns to the released version\)
6. `add pkgName#branchName`Checkout a specific branch
7. `add git@github.com:userName/pkgName.jl.git` Checkout a non registered pkg

To use the functions provided by a package, just include a `using mypackage` statement in the console or at the beginning of the script. If you prefer to import the package but keep the namespace clean, use `import mypackage`\(you will then need to refer to a package function as `myPkg.myFunction`\). You can also include other files using `include("MyFile.jl")`: when that line is run, the included file is completely ran \(not only parsed\) and any symbol defined there becomes available in the namespace relative to where include has been called.

`Winston` or `Plots` \(plotting\) and `DataFrames` \(R-like tabular data\) are example of packages that you will pretty surely want to consider.

For example \(see the [Plotting](../useful-packages/plotting.md) section for specific Plotting issues\):  
\(note: as of writing, the Plot package has not yet be ported to Julia 1.0\)

```text
using Plots
pyplot()
plot(rand(4,4))
```

**or**

```text
import Plots
const pl = Plots # this create an an alias, equivalent to Python "import Plots as pl". Declaring it constant may improve the performances.
pl.pyplot()
pl.plot(rand(4,4))
```

**or**

```text
import Plots: pyplot, plot
pyplot()
plot(rand(4,4))
```

You can read more about packages  in the [relevant section](https://docs.julialang.org/en/stable/manual/packages) of the Julia documentation, and if you are interested in writing your own package, skip to the ["Developing Julia package" section](11-developing-julia-packages.md).

## Help system \(Julia and package documentation\)

Typing `?` in the console leads you to the Julia help system where you can search for function's API \(in non-interactive environment you can use `?search_term` instead\). If you don't remember exactly the function name, Julia is kind enough to return a list of similar functions.

