
## Resources

# Markdown
https://help.github.com/articles/basic-writing-and-formatting-syntax/
https://help.github.com/articles/working-with-advanced-formatting/
https://guides.github.com/features/mastering-markdown/

# Julia
http://ucidatascienceinitiative.github.io/IntroToJulia/



## Ways to run Julia

4 Different ways to run julia code:

* 1\) julia can be run interactivelly in a console.
  Just run \(after having installed it\) `julia` in a console and then type your commands there
* 2\) Alternativly create a script, that is a text file ending in `.jl`, and let julia parse and run it with `julia myscript.jl [arg1, arg2,..]`
* 3\) Finally, add to the top of the script the location of the julia interpreter preceeded by \#! followed by an empty row \(e.g. `#!/usr/bin/julia`, you can find it typying `which julia` in a console\), be sure that the file is executable \(e.g. `chmod 755 myscript.jl`\) and then run it with `./myscript.jl`
* 4\) Use an Integrated Development Editor \(such as Juno\), open your Julia script and click the run comand of the editor

## Syntax elements

Single line comments: start with `#`

Multiline comments: in between `#=` and `=#`\(can be nested\)

In console mode \`;\` suppress the output \(done automatically in scripting mode\)

Identation don't matter.

Empty spaces sometimes do, e.g. functions must have the curved parenthesis with the inputs striclty attached to them, e.g.:

`print (x)`  ERROR
`print(x)`   OK

Functions that modify their inputs \(call by reference\) have names that end in `!`

One-based indexing \(arrays start counting from 1 and not 0\)

Containers \(arrays, vectors, matrices..\) are shadow-copied by default \(only a new reference is made, so when you change a value of the new container, also the old container get updated\).
To make a hard copy use the function copy\(\).

Using the dollar operator inside a string allows to replace the value of the variable in the string, e.g. `a = "$str1 is a string and $int1 is an integer"`

## Packages

Many functions are provided in Julia by external packages.

To automatically download, compile and install a package run from a julia console \(only once\) `Pkg.add("mypackage")`.
But before you do that, run `Pkg.update()` to be sure your local list of packages and their versions is up to date.

Then, in the console or at the beginning of the script using the functions provided by the package just inlude a `using mypackage` statement or, if you want to import the package but keep the namespace clean, use \`import mypackage\`.

Packages that you may pretty surelly will need are `Winston` or \`Plots\` \(plotting\) and `DataFrames` \(R-like tabular data\).

### Documentation and debug

Tipyng \`?\` in the concole lead you to the Julia help system where you can search for function api. In non-interactive environment you can use \`?search\_term\`.

To retrieve function signatures, type \`method\(myfunction\)\`.

To retrieve object properties: \`fieldnames\(myobject\)\`

To discover which specific method is used \(within the several available, as Julia support multiple-dispatch aka polymorfism\): \`@which myfunction\(myargs\)\`

To discover which type aka class an object istance is: \`typeof\(a\)\`

To profile a specific part of code: `@time myCode`


