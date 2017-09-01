# [SymPy](https://github.com/JuliaPy/SymPy.jl)

SymPy is a wrapper to the Python SymPy library for symbolic computation: solve equations (or system of equations), simplify them, find derivates or integrals...

An overview of its capabilities can be found on the following notebook:

http://nbviewer.jupyter.org/github/sylvaticus/juliatutorial/blob/master/assets/Symbolic%20computation.ipynb


Some additions to that notebook:

Plotting:
"""
using Sympy, Plots
x, y = symbols("x y")
plot(2x,0,1) # 1 D plotting
plot(0.5x, x, 0, 1) # parametric 1-d plotting, first expression used to build x values associated to the second expression, i.e. equal to plot(x, 2x, 0, 1) 
plot(sin(2x), cos(3x), 0, 40pi) # other parametric 1 D plotting
z = x + y 
surface([-10,10],[-10,10], z) # 2-D plotting
contour([-10,10],[-10,10], z) # contour plotting
"""

Infinity: either "oo" or "Inf"

