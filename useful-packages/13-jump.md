# JuMP

\`\`[`JuMP`](https://github.com/JuliaOpt/JuMP.jl) is an algebraic modelling language for mathematical optimisation problems, similar to GAMS, AMPL or Pyomo.

It is solver-independent. It supports also non-linear solvers, providing them with the Gradient and the Hessian.

[This notebook](http://nbviewer.jupyter.org/github/sylvaticus/juliatutorial/blob/master/assets/JuMP.ipynb) provides a commented implementation in JuMP of the classical transport problem found in the GAMS tutorial:

Note: While JuMP seems to work in Julia 0.7/1.0, many solver interfaces \(including the ones used in the above notebook\) don't jet work with Julia versions above 0.6.

_While an updated, expanded and revised version of this chapter is available in "Chapter 10 - Mathematical Libraries" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
