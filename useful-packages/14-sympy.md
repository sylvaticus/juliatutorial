# SymPy

## SymPy

[`SymPy`](https://github.com/JuliaPy/SymPy.jl) is a wrapper to the Python SymPy library for symbolic computation: solve equations \(or system of equations\), simplify them, find derivates or integrals...

An overview of its capabilities can be found on the following notebook:

[http://nbviewer.jupyter.org/github/sylvaticus/juliatutorial/blob/master/assets/Symbolic computation.ipynb](http://nbviewer.jupyter.org/github/sylvaticus/juliatutorial/blob/master/assets/Symbolic%20computation.ipynb)

Some additional notes to that notebook:

* You can plot a function that includes symbols, e.g.:  `plot(2x,0,1)` plots `y=2x` in the \[0,1\] range
* For the infinity symbol use either `oo` or `Inf` \(eventually with + or -\)

## Other Mathematical packages

* Numerical integration of definite integrals \(univariate\): \([QuadGK Package](https://github.com/JuliaMath/QuadGK.jl): `quadgk(x->2x,0,2)`\)



_While an updated, expanded and revised version of this chapter is available in "Chapter 10 - Mathematical Libraries" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
