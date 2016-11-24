# Ways to run julia #
4 Different ways to run julia code:
 - 1) julia can be run interactivelly in a console.
 Just run (after having installed it) `julia` in a console and then type your commands there
 - 2) Alternativly create a script, that is a text file ending in `.jl`, and let julia parse and run it with `julia myscript.jl [arg1, arg2,..]`
 - 3) Finally, add to the top of the script the location of the julia interpreter preceeded by #! followed by an empty row (e.g. `#!/usr/bin/julia`, you can find it typying `which julia` in a console), be sure that the file is executable (e.g. `chmod 755 myscript.jl`) and then run it with `./myscript.jl`
 - 4) Use an Integrated Development Editor (such as Juno), open your Julia script and click the run comand of the editor

# Syntaxt elements #
Single line comments: start with `#` 

Multiline comments: in between `#=` and `=#`(can be nested)

Each command must ends with `;`. Rows and spaces doesn't matter.


# Packages #
Many functions are provided in Julia by external packages. 

To automatically download, compile and install a package run from a julia console (only once) `Pkg.add("mypackage")`.
But before you do that, run `Pkg.update()` to be sure your local list of packages and their versions is up to date.

Then, in the concole or at the beginning of the script using the functions provided by the package just inlude a `using mypackage` statement.

Packages that you may pretty surelly will need are `Winston` (plotting) and `DataFrames` (R-like tabular data).




