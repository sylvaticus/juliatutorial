# 1 - Getting started

## Why Julia

One of the first (initial) reasons one gives a try to Julia is that Julia helps solving a trade-off (partially thanks to the recent developments in _just-in-time_ compilers) that has long existed in programming: _fast coding_ vs. _fast execution_.  
On the one hand, Julia allows us to code in a dynamic language like Python, R or Matlab, allowing for fast interaction with your program and exceptional expressive power (see the [Metaprogramming](metaprogramming.md) chapter, for example).  
On the other hand, with minimum effort programs written in Julia can run nearly as fast as C (see [Performance](performance.md)).
However, if all we need is "just" to use features available in already-developed libraries, we may not need these performances, as computational R/Python libraries are for the most part wrote in a compiled language and the dynamic language is used only to interface them. The performance gain we would have using Julia would be minimal. However if we need to implement some "feature" by ourself, without the possibility to rely to an existing library, there we are, we would _really_ benefit of Julia performances. As further advantages, the fact that Julia libraries can and are written in Julia, make participation on their development much simpler, as potential developers don't need to be expert in multiple languages. And this is one of the reasons the Julia ecosystem is already remarkable, despite its youth.

Aside the breakout in runtime performances from traditional high-level dynamic languages, the fact that Julia has been created from scratch has allowed the use of the best, modern technologies, without concerns to maintain compatibility with existing users code or internal architecture. Built-in git-based package manager, full code introspection, multiple dispatch, in-core high-level methods for parallel computing, Unicode characters in variable names (e.g. Greek letters) are some of the features of Julia that you will likely appreciate.

While it is still young, Julia allows us to easily interface our code with all the major programming languages (see [Interfacing Julia with other languages](interfacing-julia-with-other-languages.md)), hence reusing their huge set of libraries, when these are not already being ported into Julia.  
Julia has its roots in the domain of scientific, high performance computing, but it is becoming more and more mature as a general purpose programming language.

## Installing Julia

All we need to run the code in this tutorial is a working Julia interpreter (aka REPL - _Read Eval Print Loop_).  
In Linux we can simply use our package manager to install `julia`, but for a more up-to-date version, or for Windows/Mac packages, I strongly suggest to download the binaries available on the [download section](http://julialang.org/downloads/) of the [Julia web-site](http://julialang.org).

For a more user-friendly Integrated Development Environment, we have several options:

* [Juno](http://junolab.org/) is a plugin for Julia the Atom text editor. Setup instructions are [here](http://docs.junolab.org/latest/man/installation/#Installation-Instructions). While at the moment it is the most feature-rich IDE, development is switching to the VSCode plugin, due to the almost-abandoned nature of Atom. If you have to start, you may want to directly start with the VSCode plugin instead.
* [Julia for VSCode](https://www.julia-vscode.org/) is a plugin for Julia for the Visual Studio Code IDE. Setup instructions are [here](https://www.julia-vscode.org/docs/dev/gettingstarted/#Installation-and-Configuration-1). As said, this is where all new development of Julia IDE is moving to, although it could still look a bit immature.
* [IJulia](https://github.com/JuliaLang/IJulia.jl), the Julia Kernel for [Jupyter](http://jupyter.org/). We can either first install Jupyter using Python and then install the Julia kernel by typing `using Pkg; Pkg.update();Pkg.add("IJulia")` from the Julia console, or we can have IJulia create and manage its own Python/Jupyter installation (see the IJulia readme). IJulia/Jupyter is particularly useful if we need to communicate concerning some code, as we can mix code, markdown text and code outputs (like charts or tables)
* [Pluto](https://github.com/fonsp/Pluto.jl). Install it with `using Pkg; Pkg.update();Pkg.add("Pluto")` and start it with `import Pluto; Pluto.run()`. Like `IJulia`, `Pluto` is a notebook, but it employ a new concept of _reactiviness_: when we change a variable in a cell, Pluto automatically re-runs the cells that refer to it, both above and below the cell where we changed the code. Very impressive !

You can also choose, at least to start with, _not_ to install Julia at all, and try one of the various online computational environments that support Julia, like  [CoCalc](https://cocalc.com/doc/software-julia.html), [nextJournal](https://nextjournal.com), [Binder](https://mybinder.org), [Google Colab](https://colab.research.google.com/github/ageron/julia_notebooks/blob/master/Julia_Colab_Notebook_Template.ipynb), [Matrix DS](https://matrixds.com/platform/)...

## Running Julia

There are several ways to run Julia code:

1. Julia can be run interactively in a console.

   Once we have it installed, we can just type `julia` in a console and then enter your commands in the prompt that follows. We then type `exit()` or CTRL+D when we have finished;

2. Alternatively, Julia can be run as a script.

   A Julia script is a text file ending in `.jl`, which we can have Julia parse and run with `julia myscript.jl [arg1, arg2,..]`.
   Script files can also  be run from within the Julia console, just type `include("myscript.jl")`;

4. In addition, on UNIX-based systems Julia can be run using a shebang script.

   To make a shebang script, we just add the location of the Julia interpreter on our system, preceded by `#!` and followed by an empty row, to the top of the script. You can find the full path of the Julia interpreter by typing `which julia` in a console, for example, `/usr/bin/julia`. Be sure that the file is executable (e.g. `chmod +x myscript.jl`). Then you can run the script with `./myscript.jl`;

5. Using an Integrated Development Environment (such as those mentioned), we can open a Julia script and use the run command specific of the editor.

We can define both a global (for all users of the computer) and local (for a single user) Julia file that will be executed at any start-up, where we can for example define functions or variables that should be always available.
The locations of these two files are:

* Global Julia startup file: `[JULIA_INSTALL_FOLDER]\etc\julia\startup.jl`  (where `JULIA_INSTALL_FOLDER` is the place where Julia is installed,
* Local Julia startup file:  `[USER_HOME_FOLDER]\.julia\config\startup.jl` (where `USER_HOME_FOLDER` is the home folder of the local user, e.g. `%HOMEPATH%` in Windows and `~` in Linux)



Julia keeps many things in memory within the same work session, so if this creates problems in the execution of your code, you can restart Julia. You can also use the [Revise.jl](https://github.com/timholy/Revise.jl) package for a finer control over what Julia keeps in memory during a work session.

You can check which version of Julia you are using with `versioninfo().`

## Syntax elements

Single line comments start with `#` and multi-line comments can be placed in between `#=` and `=#`. Multi-line comments can be nested, as well.

In console mode, `;` after a command suppresses the output \(this is done automatically in scripting mode\), and typed alone switches to one-time command shell prompt.

Indentation doesn't matter, but empty spaces sometimes do, e.g. functions must have the curved parenthesis with the inputs strictly attached to them, e.g.:

```text
println (x)  ERROR  
println(x)   OK
```

Note: If you come from C or Python, one important thing to remember is that Julia's arrays and other ordered data structures start indexes counting from `1` and not `0`.

## Packages

Many functions are provided in Julia by external "packages". The "standard library" is a package that is shipped with Julia itself, but like normal packages the user is required to manually load the standard library. Many standard features that were in the language core before Julia 1.0 have been moved to the standard library, so if you're moving from an older version of Julia be aware of this.

To include a Julia package's functionality in your Julia code, you must write `using Pkg` to use `Pkg`'s capabilities \(alternatively, only for the package module, you can type `]` to enter a "special" Pkg mode\).

You can then run the desired command, directly if you are in a terminal, in the Pkg mode, or `pkg"cmd to run"` in a script \(notice that there is no space between `pkg` and the quoted command to run\).

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

```text
using Plots
pyplot()
plot(rand(4,4))
```

**or**

```text
import Plots
const pl = Plots # this create an an alias, equivalent to Python "import Plots as pl". Declaring it constant may improve the performance.
pl.pyplot()
pl.plot(rand(4,4))
```

**or**

```text
import Plots: pyplot, plot
pyplot()
plot(rand(4,4))
```

Finally, we can also include any Julia source files using `include("MyFile.jl")`: when that line is run, the included file is completely ran (not only parsed) and any symbol defined there becomes available in the scope (the region of code within which a variable is visible) relative to where `include` has been called.

While there is no issues in calling `import x` or `using x` several times in the code, calling `include("x.jl")` more than once should be avoided, as it may end up to duplicated objects.

You can read more about module and packages in the [relevant section](https://docs.julialang.org/en/stable/manual/packages) of the Julia documentation, and if you are interested in writing your own package, skip to the ["Julia Modules and Packages" section](11-developing-julia-packages.md).

## Help system \(Julia and package documentation\)

Typing `?` in the console leads you to the Julia help system where you can search for function's API \(in non-interactive environment you can use `?search_term` instead\). If you don't remember exactly the function name, Julia is kind enough to return a list of similar functions.


_While an updated, expanded and revised version of this chapter is available in "Chapter 1 - Getting Started" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
