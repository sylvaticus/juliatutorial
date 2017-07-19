# [Weave](https://github.com/mpastell/Weave.jl)

Weave allows to produce dynamic documents where the script that produce the output is embedded directly in the document, but optionally only the output is rendered.

e.g. 


```
---
title : Test with citations
date : 14th March 2017
bibliography: biblio.bib
---

Test [see @Allen:2010, pp. 33-35; also @Archer:2009, ch. 1].

@Arfini:2005 [p. 33] says blah.

``````{julia;echo=false}
using DataFrames

df = DataFrame(
colour = ["green","blue","white","green","green"],
shape = ["circle", "triangle", "square","square","circle"],
border = ["dotted", "line", "line", "line", "dotted"],
area = [1.1, 2.3, 3.1, 4.2, 5.2])
head(df)
``````

The above references should have been compiled
```

And then "compile" the document with: 

`weave("testRef.jmd", out_path = :pwd, doctype = "pandoc2pdf")`

Note that citations currently require the master branch of Weave (`Pkg.checkout("Weave"); Pkg.build("Weave")`) and on Linux they require, other than pandoc, the ubuntu packages `pandoc-citeproc` and `texlive-xetex` installed.