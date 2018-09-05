# 15 - Weave

Weave allows to produce dynamic documents where the script that produce the output is embedded directly in the document, with optionally only the output rendered.

Save the document below in a file with extension jmd \(e.g. test.jmd\)

```text
---
title : Test of a document with citations
date : 4th September 2018
bibliography: biblio.bib
---
​

# Section 1 (leave two rows from document headers)
​
This is a strong affermation that needs a citation [see @Lecocq:2011, pp. 33-35; also @Caurla:2013b, ch. 1].
​
@Lobianco:2016b [p. 8] affirms something else.

## Subsection 1.1
​
This should be a plot. Not that I am not showing the source code in the final PDF:

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

Note that I can refer to variables defined in previous chunks:

```{julia;}
df[:colour]
```

### Subsubsection

For a much more complete example see the [Weave documentation](http://weavejl.mpastell.com/stable/).
```

You can then "compile" the document \(from within Julia\) with:

`using Weave; weave("test.jmd", out_path = :pwd, doctype = "pandoc2pdf")`

To obtain the following pdf: [https://github.com/sylvaticus/juliatutorial/raw/master/assets/test.pdf](https://github.com/sylvaticus/juliatutorial/raw/master/assets/test.pdf)





In Ubuntu Linux \(but most likely also in other systems\), weave needs pandora and LaTeX \(`texlive-xetex` \) already installed in the system.  
If you use Ununtu, the version of pandora in the official repositories is too old. Use instead the deb available in [https://github.com/jgm/pandoc/releases/latest](https://github.com/jgm/pandoc/releases/latest) .



