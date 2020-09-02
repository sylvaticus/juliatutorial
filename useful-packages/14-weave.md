# Weave

[`Weave`](https://github.com/mpastell/weave.jl) allows to produce dynamic documents where the script that produce the output is embedded directly in the document, with optionally only the output rendered.

Save the document below in a file with extension jmd \(e.g. testWeave.jmd\)

```text
---
title : Test of a document with embedded Julia code and citations
date : 5th September 2018
bibliography: biblio.bib
---
​

# Section 1 (leave two rows from document headers)
​
This is a strong affermation that needs a citation [see @Lecocq:2011, pp. 33-35; @Caurla:2013b, ch. 1].
​
@Lobianco:2016b [pp. 8] affirms something else.

## Subsection 1.1
​
This should print a plot. Note that I am not showing the source code in the final PDF:

```{julia;echo=false}
using Plots
pyplot()
plot(sin, -2pi, pi, label="sine function")
```
Here instead I will put in the PDF both the script source code and the output:

```{julia;}
using DataFrames
df = DataFrame(
         colour = ["green","blue","white","green","green"],
         shape  = ["circle", "triangle", "square","square","circle"],
         border = ["dotted", "line", "line", "line", "dotted"],
         area   = [1.1, 2.3, 3.1, missing, 5.2]
    )
df
```

Note also that I can refer to variables defined in previous chunks (or "cells", following Jupyter terminology):

```{julia;}
df[:colour]
```

### Subsubsection

For a much more complete example see the [Weave documentation](http://weavejl.mpastell.com/stable/).

# References
```

You can then "compile" the document \(from within Julia\) with:

`using Weave; weave("testWeave.jmd", out_path = :pwd, doctype = "pandoc2pdf")`

To obtain the [following pdf](https://github.com/sylvaticus/juliatutorial/raw/master/assets/testWeave.pdf):

![Page 1](https://github.com/sylvaticus/juliatutorial/raw/master/assets/imgs/testWave_p1.png)

![Page 2](https://github.com/sylvaticus/juliatutorial/raw/master/assets/imgs/testWave_p2.png)

In Ubuntu Linux \(but most likely also in other systems\), weave needs pandora and LaTeX \(`texlive-xetex` \) already installed in the system.  
If you use Ununtu, the version of pandora in the official repositories is too old. Use instead the deb available in [https://github.com/jgm/pandoc/releases/latest](https://github.com/jgm/pandoc/releases/latest) .


_While an updated, expanded and revised version of this chapter is available in "Chapter 11 - Utilities" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
