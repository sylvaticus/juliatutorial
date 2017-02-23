# Plotting

Plotting in julia can be obtained using a specific plotting package (e.g. [Gadfly](https://github.com/dcjones/Gadfly.jl), [Winston](https://github.com/nolta/Winston.jl)) or, as I prefer, use the [Plots](https://github.com/JuliaPlots/Plots.jl) package that provide a unified API to several supported backends

Backends are chosen running `chosenbackend()` (that is, the name of the corresponding backend package, but written all in lower case) before calling the `plot` function.  
You need to install at least one backend before being able to use the `Plots` package. My preferred one is [PlotlyJS](https://github.com/sglyon/PlotlyJS.jl) (a julia interface to the [plotly.js](https://plot.ly) visualization library. ), but you may be interested also in [PyPlot](https://github.com/JuliaPy/PyPlot.jl) (that use the excellent python [matplotlib](http://matplotlib.org/api/pyplot_api.html)).

For example:

```
Pkg.add("Plots")
Pkg.add("PlotlyJS") # or Pkg.add("PyPlot.jl") 
using Plots
plotlyjs()          # or pyplot()
plot(sin, -2pi, pi, label="sine function")
```

Attenction not to mix using different plotting packages (`Plots` and one of its backends). I had troubles with that. If you already imported a plot package and you want to use an other package, always restart the julia kernel (this is not necessary, and it is one of the advantage, when switching between different bakends of the `Plots` package).

You can find some useful documentation on `Plots` backends:
* [Which backend to choose ?](https://juliaplots.github.io/backends/)
* [Charts and attributes supported by the various backends](https://juliaplots.github.io/supported/)

