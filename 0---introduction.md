## Resources

# Markdown

[https://help.github.com/articles/basic-writing-and-formatting-syntax/](https://help.github.com/articles/basic-writing-and-formatting-syntax/)  
[https://help.github.com/articles/working-with-advanced-formatting/](https://help.github.com/articles/working-with-advanced-formatting/)  
[https://guides.github.com/features/mastering-markdown/](https://guides.github.com/features/mastering-markdown/)

# Julia

[http://ucidatascienceinitiative.github.io/IntroToJulia/](http://ucidatascienceinitiative.github.io/IntroToJulia/)
[http://lectures.quantecon.org/jl/learning_julia.html](http://lectures.quantecon.org/jl/learning_julia.html)

## Ways to run Julia

Different ways to run julia code:

1. julia can be run interactivelly in a console.
Just run (after having installed it) `julia` in a console and then type your commands there;
2. Alternatively, create a script, that is a text file ending in `.jl`, and let julia parse and run it with `julia myscript.jl [arg1, arg2,..]`;
3. Script files can be run from within the Julia console, just type `include("myscript.jl")`
3. Finally, add at the top of the script the location of the julia interpreter preceeded by `#!` and followed by an empty row (e.g. `#!/usr/bin/julia` (you can find the fullpath of the Julia interpreter by typying `which julia` in a console). Be sure that the file is executable (e.g. `chmod 755 myscript.jl`) and then run it with `./myscript.jl`;
4. Use an Integrated Development Editor (such as [Juno](include("test_script.jl")) or [Jupiter](http://jupyter.org/)), open your Julia script and click the run comand of the editor.

Julia keeps many things in memory. If this create problems in the eecution of your code, you can empty the current session for all the variables using `workspace()`.

## Syntax elements

Single line comments: start with `#`

Multiline comments: in between `#=` and `=#`(can be nested)

In console mode `;` after a command suppresses the output (done automatically in scripting mode), and typed alone swithes to one-time command shell prompt. 

Identation doesn't matter.

Empty spaces sometimes do, e.g. functions must have the curved parenthesis with the inputs striclty attached to them, e.g.:

```
print (x)  ERROR  
print(x)   OK
```

One-based indexing (arrays start counting from `1` and not `0`)

## Packages

Many functions are provided in Julia by external packages.

To automatically download, compile and install a package run from a julia console (only once) `Pkg.add("mypackage")`.  
But before you do that, run `Pkg.update()` to be sure (a) your local index of packages and (b) version of local packages is up to date.
Use `Pkg.status()` to check the current version of your local packages.

Then, in the console or at the beginning of the script using the functions provided by the package, just inlude a `using mypackage` statement or, if you want to import the package but keep the namespace clean, use `import mypackage`.
Packages that you pretty surelly will need are `Winston` or `Plots` (plotting) and `DataFrames` (R-like tabular data).
You can include other files, without changing the current namespace, using `include("MyFile.jl")`.

## A bit on Plotting
The package "Plots" can work on top of various backends. These are chosen running `chosenBackend()` before calling the plot function.

Some useful doc:
* [Which backend to choose ?](https://juliaplots.github.io/backends/)
* [Charts and attributes supported by the various backends](https://juliaplots.github.io/supported/)

 

### Documentation and debug

Tipyng `?` in the console lead you to the Julia help system where you can search for function api. In non-interactive environment you can use `?search_term`.

To retrieve function signatures, type `method (myfunction)`.

To retrieve object properties: `fieldnames(myobject)`

To discover which specific method is used (within the several available, as Julia supports multiple-dispatch aka polymorfism): `@which myfunction(myargs)`

To discover which type aka class an object istance is: `typeof(a)`

To profile a specific part of code: `@time myCode`

