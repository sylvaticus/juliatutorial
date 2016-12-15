# Plotting

Plotting can be obtained with several packages.

## The `Plots` package

Maybe the most flexible plotting package is `Plots`, as it can work on top of various backends, while providing a unified interface. Backends are chosen running `chosenbackend()` (that is, the name of the corresponding backend package, but all in lower case) before calling the `plot` function.  
You need to install at least one backend before being able to use the `Plots` package.

For example:

```
Pkg.add("Plots")
Pkg.add("Plotly")
using Plots
plotly()
plot(sin, -2pi, pi, label="sine function")
```

You can find some useful documentation on `Plots` backends:
* [Which backend to choose ?](https://juliaplots.github.io/backends/)
* [Charts and attributes supported by the various backends](https://juliaplots.github.io/supported/)
