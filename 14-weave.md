# [Weave](https://github.com/mpastell/Weave.jl)

Weave allows to produce dynamic documents where the script that produce the output is embedded directly in the document, but optionally only the output is rendered.

e.g. 


```
---
title : Test with citations
date : 14th March 2017
bibliography: biblio.bib
---

#### Section 1

Test [see @Allen:2010, pp. 33-35; also @Archer:2009, ch. 1].

@Arfini:2005 [p. 33] says blah.

``````{julia;echo=false}
using DataFrames, Plots, StatPlots

df = DataFrame(
    fruit = ["orange","orange","orange","orange","apple","apple","apple","apple"],
    year = [2010,2011,2012,2013,2010,2011,2012,2013],
    production = [120,150,170,160,100,130,165,158],
    consumption = [70,90,100,95, 80,95,110,120]
)
println(head(df))
mycolours = [:green :orange]
fruits_plot = plot(df, :year, :production, group=:fruit, linestyle = :solid, linewidth=3, label= reshape("Production of " * sort(unique(df[:fruit])),(1,:)), color=mycolours)
plot!(df, :year, :consumption, group=:fruit, linestyle = :dot, linewidth=3, label ="Consumption of " .* reshape(sort(unique(df[:fruit])),(1,:)), color=mycolours)
``````

#### Section 2
The above references should have been compiled and the plot printed.

### Section 2.1

``````{julia;echo=false}
a = [1,2]
println(a)
``````

![An image](plot.png "Logo Title Text 1")

![An other image](plot.pdf "Logo Title Text 2")
```

And then "compile" the document (from Julia) with: 

`using Weave; weave("testRef.jmd", out_path = :pwd, doctype = "pandoc2pdf")`

Note that citations require, other than pandoc, the ubuntu packages `pandoc-citeproc` and `texlive-xetex` installed (the `pandoc` deb in [https://github.com/jgm/pandoc/releases/latest](https://github.com/jgm/pandoc/releases/latest) already include `pandoc-citeproc`).