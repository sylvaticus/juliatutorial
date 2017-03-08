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


# Plotting multiple groups of series from a DataFrame
The following example uses [StatPlots](https://github.com/JuliaPlots/StatPlots.jl) in order to work directly on DataFrames (rather than on arrays).
Passing the dataFrame as first argument, you can access its columns by name and split the overall serie using a third column.

```
using DataFrames, Plots, StatPlots
df = DataFrame(
  fruit       = ["orange","orange","orange","orange","apple","apple","apple","apple"],
  year        = [2010,2011,2012,2013,2010,2011,2012,2013],
  produption  = [120,150,170,160,100,130,165,158],
  consumption = [70,90,100,95,   80,95,110,120]
)
plotlyjs() 
mycolours = [:green :orange] # note that the serie is piled up alphabetically
fruits_plot = plot(df, :year, :production, group=:fruit, linestyle = :solid, linewidth=3, label = ("Production of " * sort(unique(df[:fruit]))'), color=mycolours)
plot!(df, :year, :consumption, group=:fruit, linestyle = :dot, linewidth=3, label = ("Consumption of " * sort(unique(df[:fruit]))'), color=mycolours)
```
The first call to `plot()` create a new plot. Calling instead `plot!()` modify instead the plot that is passed as first argument (if none, the latest plot is modified)

While to play interactivly I prefer plotlyjs, for saving the charts one has to rely to the saving button on the widget. For scripting task it is hence suggested to use the pyplot backend that allow to save the latest plot as simple as:
```
savefig("fruits_plot.svg")
savefig("fruits_plot.pdf")
savefig("fruits_plot.png")
```


